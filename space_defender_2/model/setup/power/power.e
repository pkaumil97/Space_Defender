note
	description: "Summary description for {POWER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POWER

inherit
	STATES


create
	make
feature
	make
		do
			create state_name.make_from_string ("power setup")
			create {LINKED_LIST[like current]}option_select.make
			option_select.force (create {RECALL}.make)
			option_select.force (create {REPAIR}.make)
			option_select.force (create {OVERCHARGE}.make)
			option_select.force (create {DEPLOY_DRONES}.make)
			option_select.force (create {ORBITAL_STRIKE}.make)
			select_cursor := 1
			create selected_option.make_empty
		end

feature
	set_options
	local
		op : STRING
	do
		create op.make_empty

		  op.append ("  1:Recall (50 energy): Teleport back to spawn.%N")
		  op.append ("  2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.%N")
		  op.append ("  3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.%N")
		  op.append ("  4:Deploy Drones (100 energy): Clear all projectiles.%N")
		  op.append ("  5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.%N")
		  op.append ("  Power Selected:" + option_select[select_cursor].selected_option)
		  model_access.m.print_state.set_options_string (op)
	end

	set_select_cursor (i : INTEGER)
		do
			select_cursor := i
		end
	special
		do
			option_select[select_cursor].special
		end

end
