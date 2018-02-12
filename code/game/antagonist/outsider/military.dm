var/datum/antagonist/military/military

/datum/antagonist/military
	id = MODE_MILITARY
	bantype = "Emergency Response Team"
	role_text = "Military Commando"
	role_text_plural = "Military Commandos"
	welcome_text = "You are a Biesel military special forces operative. Move in, secure the civilians, and eliminate all hostiles with extreme prejudice."
	landmark_id = "Military"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_OVERRIDE_MOB | ANTAG_RANDOM_EXCEPTED
	id_type = /obj/item/weapon/card/id/military
	default_access = list(access_maint_tunnels, access_external_airlocks)

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

/datum/antagonist/military/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/military/New()
	..()
	military = src

/datum/antagonist/military/update_antag_mob(var/datum/mind/player)
	..()
	var/military_commando_rank
	military_commando_rank = pick("Lieutenant", "Captain", "Major")
	var/military_commando_name = pick(last_names)
	player.name = "[military_commando_rank] [military_commando_name]"
	player.current.name = player.name
	player.current.real_name = player.current.name
	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.gender = pick(MALE)
		H.age = rand(25,45)
		H.dna.ready_dna(H)
		H.h_style = "CIA"
		H.f_style = "3 O'clock Shadow"
	return

/datum/antagonist/military/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/responder(player), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/rank/fatigues/marine (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(player), slot_shoes)

	var/obj/item/weapon/card/id/id = create_id("Commando", player)
	if(id)
		id.name = "[player.name]'s dogtags"

	player.regenerate_icons()
	return 1