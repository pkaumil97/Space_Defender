note
	description: "Summary description for {LIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIGHT

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
			create selected_option.make_from_string( "Light")
			create {LINKED_LIST[like current]}option_select.make
			health := 75
		    energy := 0
		    armour := 3
		    vision := 0
		    move := 0
		    move_cost := 1
			create regen.default_create
			regen := [2, 0]
		end
end
