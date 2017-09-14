// Holds Forzun specific items. Their snowflake respirators, clothing, voidsuits, helmets, etc
/obj/item/clothing/mask/breath/forzun
	desc = "A respirator designed for Forzun, allowing them to breathe in atmosphere."
	name = "respirator"
	//icon = 'icons/obj/vaurca_items.dmi'
	//icon_state = "m_garment"

/obj/item/clothing/mask/breath/forzun/adjust_mask(mob/user)
	user << "The respirator cannot be adjusted"
	return

/obj/item/clothing/under/forzun/
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "black"
	desc = "A specialised jumpsuit for Forzun, allowing them to survive in atmosphere without taking damage to their bodies."
	name = "scalesuit"
	item_flags = STOPPRESSUREDAMAGE
	species_restricted = list("exclude","Forzun")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS//|HANDS|FEET