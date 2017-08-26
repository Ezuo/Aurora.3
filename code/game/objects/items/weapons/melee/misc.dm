/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	item_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = 3
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/weapon/melee/chainsword
	name = "chainsword"
	desc = "A deadly chainsaw in the shape of a sword."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainswordoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = 4
	sharp = 1
	edge = 1
	origin_tech = list(TECH_COMBAT = 5)
	attack_verb = list("chopped", "sliced", "shredded", "slashed", "cut", "ripped")
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/active = 0
	can_embed = 0//A chainsword can slice through flesh and bone, and the direction can be reversed if it ever did get stuck

/obj/item/weapon/melee/chainsword/attack_self(mob/user)
	active= !active
	if(active)
		playsound(user, 'sound/weapons/chainsawstart.ogg', 50, 1)
		user << span("notice", "\The [src] rumbles to life.")
		force = 35
		hitsound = 'sound/weapons/chainsword.ogg'
		icon_state = "chainswordon"
		slot_flags = null
	else
		user << span("notice", "\The [src] slowly powers down.")
		force = initial(force)
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		slot_flags = initial(slot_flags)
	user.regenerate_icons()

/*
/obj/item/weapon/melee/chainsword/suicide_act(mob/user)
	viewers(user) << "<span class='danger'>[user] is slicing \himself apart with the [src.name]! It looks like \he's trying to commit suicide.</span>"
	return (BRUTELOSS|OXYLOSS)
*/

//This is essentially a crowbar and a baseball bat in one.
/obj/item/weapon/melee/hammer
	name = "kneebreaker hammer"
	desc = "A heavy hammer made of plasteel, the other end could be used to pry open doors."
	icon = 'icons/obj/kneehammer.dmi'
	icon_state = "kneehammer"
	item_state = "kneehammer"
	contained_sprite = 1
	slot_flags = SLOT_BELT
	force = 22
	throwforce = 15.0
	throw_speed = 5
	throw_range = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
	hitsound = 'sound/weapons/genhit3.ogg'
