/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

	var/unwet_timer	// Used to keep track of the unwet timer & delete it on turf change so we don't runtime if the new turf is not simulated.

	roof_type = /turf/simulated/floor/airless/ceiling

/turf/simulated/proc/wet_floor(var/wet_val = 1)
	if(wet_val < wet)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		add_overlay(wet_overlay, TRUE)

	unwet_timer = addtimer(CALLBACK(src, .proc/unwet_floor), 120 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/turf/simulated/proc/unwet_floor()
	--wet
	if (wet < 1)
		wet = 0
		if(wet_overlay)
			cut_overlay(wet_overlay, TRUE)
			wet_overlay = null
	else
		unwet_timer = addtimer(CALLBACK(src, .proc/unwet_floor), 120 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/Initialize(mapload)
	if (mapload)
		if(istype(loc, /area/chapel))
			holy = 1

	. = ..()
	levelupdate(mapload)
	if (!mapload)
		updateVisibility(src)

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+1, 101)
	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "<span class='danger'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return

	if (istype(A,/mob/living))
		var/mob/living/M = A
		if(M.lying)
			return ..()

		// Ugly hack :( Should never have multiple plants in the same tile.
		var/obj/effect/plant/plant = locate() in contents
		if(plant) plant.trodden_on(M)

		// Dirt overlays.
		update_dirt()

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(H.m_intent == "run" ? 1 : 0))
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(src.wet)

			if(M.buckled || (src.wet == 1 && M.m_intent == "walk"))
				return

			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"

			switch(src.wet)
				if(2) // Lube
					floor_type = "slippery"
					slip_dist = 4
					slip_stun = 10
				if(3) // Ice
					floor_type = "icy"
					slip_stun = 4

			if(M.slip("the [floor_type] floor",slip_stun))
				for(var/i = 0;i<slip_dist;i++)
					step(M, M.dir)
					sleep(1)
			else
				M.inertia_dir = 0
		else
			M.inertia_dir = 0

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.virus2 = virus_copylist(M.virus2)
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/Destroy()
	//Yeah, we're just going to rebuild the whole thing.
	//Despite this being called a bunch during explosions,
	//the zone will only really do heavy lifting once.
	if (zone)
		zone.rebuild()

	// Letting this timer continue to exist can cause runtimes, so we delete it.
	if (unwet_timer)
		// deltimer will no-op if the timer is already deleted, so we don't need to check the timer still exists.
		deltimer(unwet_timer)

	return ..()
