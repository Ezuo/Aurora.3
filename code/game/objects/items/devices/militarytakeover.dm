/obj/item/device/militaryhacktool
	name = "military hack tool"
	desc = "A device used by Biesel military with the capability to hack into any network."
	icon = 'icons/obj/items.dmi'
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 1.0

/obj/item/device/militaryhacktool/attack_self(mob/user as mob)
	if(..()) return

	var/selection = input("Are you sure you want to hack the station systems and begin the assault?") in list("Yes","No")
	switch(selection)
		if ("Yes")
			command_announcement.Announce("Attention: This %s &0t #*&^ $7-ystem now under military command.", "System Takeover", new_sound = 'sound/AI/militarytakeover.ogg')
			qdel(src)
		if ("No")
			return
	return