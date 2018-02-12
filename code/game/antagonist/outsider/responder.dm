//var/datum/antagonist/responder/responder
/datum/antagonist/responder
	bantype = "Emergency Response Team"


	id_type = /obj/item/weapon/card/id
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_RANDOM_EXCEPTED | ANTAG_SET_APPEARANCE | ANTAG_CHOOSE_NAME
	default_access = list(access_maint_tunnels, access_external_airlocks)

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7


var/datum/antagonist/responder/iac/iac
/datum/antagonist/responder/iac
	id = MODE_IAC
	role_text = "IAC Responder"
	role_text_plural = "IAC Responders"
	welcome_text = "You are an Interstellar Aid Corps representative. Respond to the distress beacon and aid in any way you can."
	landmark_id = "IAC"
	

/datum/antagonist/responder/iac/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/responder/iac/New()
	..()
	iac = src

/datum/antagonist/responder/iac/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/responder(player), slot_l_ear)
	//player.equip_to_slot_or_del(new /obj/item/clothing/under/iac (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(player), slot_shoes)

	create_id("Interstellar Aid Corps", player)
	return 1

var/datum/antagonist/responder/ai/ai
/datum/antagonist/responder/ai
	id = MODE_AI
	role_text = "AI Responder"
	role_text_plural = "AI Responders"
	welcome_text = "You are a Artemis Initative soldier. Respond to the distress beacon and take charge of the situation for the glory of ATLAS."
	landmark_id = "AI"

/datum/antagonist/responder/ai/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/responder/ai/New()
	..()
	ai = src

/datum/antagonist/responder/ai/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/responder(player), slot_l_ear)
	//player.equip_to_slot_or_del(new /obj/item/clothing/under/ai (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(player), slot_shoes)

	create_id("Artemis Initiative", player)
	return 1

var/datum/antagonist/responder/ffm/ffm
/datum/antagonist/responder/ffm
	id = MODE_FFM
	role_text = "FFM Responder"
	role_text_plural = "FFM Responders"
	welcome_text = "You are a Freedom Frontier Militia soldier. Respond to the distress beacon and wipe out all resistance."
	landmark_id = "FFM"

/datum/antagonist/responder/ffm/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/responder/ffm/New()
	..()
	ffm = src

/datum/antagonist/responder/ffm/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/responder(player), slot_l_ear)
	//player.equip_to_slot_or_del(new /obj/item/clothing/under/ffm (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/black (player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(player), slot_shoes)

	create_id("Freedom Frontier Militia", player)
	return 1