note
	description: "Summary description for {ARMOUR_NONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_NONE
inherit
	ARMOUR
		redefine
			make
		end
create
	make

feature
	make
		do
			create state_name.make_from_string ("armour setup")
			create selected_option.make_from_string( "None")
			create {LINKED_LIST[like current]}option_select.make
			health := 50
		    energy := 0
		    armour := 0
		    vision := 0
		    move := 1
		    move_cost := 0
			create regen.default_create
			regen := [1, 0]
		end

end
