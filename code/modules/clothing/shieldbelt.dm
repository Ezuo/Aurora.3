obj/item/clothing/suit/armor/shieldbelt
	name = "shield belt"
	desc = "A highly advanced piece of equipment with kinetic and photonic field projectors attached."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "shieldbelt-0"
	item_state = "shieldbelt-0"
	slot_flags = SLOT_BELT
	body_parts_covered = null
	armor = null
	item_flags = THICKMATERIAL|NOSLIP
	flags = NOBLOODY|PHORONGUARD

	//origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 2)
	var/celltype = /obj/item/weapon/cell/high
	var/obj/item/weapon/cell/cell
	var/charge_consumption = 2000 // SS process runs every 2 seconds, 1000 per second, 10s with the default cell
	var/on = 0

/obj/item/clothing/suit/armor/shieldbelt/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	cell = new celltype(src)
	pockets = null
	
/obj/item/clothing/suit/armor/shieldbelt/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(cell)
	return ..()

/obj/item/clothing/suit/armor/shieldbelt/proc/turn_on()
	if(!cell)
		if (ismob(loc))
			var/mob/M = loc
			to_chat(M, "There is no cell in the [src]!")
		return
	if(cell.charge <= 0)
		if (ismob(loc))
			var/mob/M = loc
			to_chat(M, "The [cell.name] in the [src] has no charge!")
		return
	
	on = 1
	body_parts_covered = FULL_BODY
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	icon_state = "shieldbelt-1"
	item_state = "shieldbelt-1"
	if (ismob(loc))
		var/mob/M = loc
		M.update_inv_belt()
	update_icon()

/obj/item/clothing/suit/armor/shieldbelt/proc/turn_off()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.show_message("\The [src] clicks and whines as it powers down.", 2)	//let them know in case it's run out of power.
	
	on = 0
	body_parts_covered = null
	armor = null
	icon_state = "shieldbelt-0"
	item_state = "shieldbelt-0"
	if (ismob(loc))
		var/mob/M = loc
		M.update_inv_belt()
	update_icon()

/obj/item/clothing/suit/armor/shieldbelt/process()
	if (!on || !cell)
		return

	cell.use(charge_consumption)

	if(cell.charge <= 0)
		turn_off()


obj/item/clothing/suit/armor/shieldbelt/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list("chest", "groin")))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation

obj/item/clothing/suit/armor/shieldbelt/attack_self(mob/user as mob)
	if (src.on)
		src.turn_off()
	else
		src.turn_on()
	src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/shieldbelt/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (isscrewdriver(W) && src.cell)
		if(src.on)
			to_chat(user, "You can't do this while the [src] is on!")
			return
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.loc = get_turf(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		to_chat(user, "You remove the [src.cell].")
		src.cell = null

	if (istype(W, /obj/item/weapon/cell))
		if(cell)
			user << "There is a [cell] already installed here."
		else
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, "You insert the [cell].")
		update_icon()
		return

	return ..()