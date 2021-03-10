note
	description: "Summary description for {MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDIUM

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
			create selected_option.make_from_string( "Medium")
			create {LINKED_LIST[like current]}option_select.make
			health := 100
		    energy := 0
		    armour := 5
		    vision := 0
		    move := 0
		    move_cost := 3
			create regen.default_create
			regen := [3, 0]
		end

end
