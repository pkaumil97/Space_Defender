note
	description: "Summary description for {HEAVY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEAVY
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
			create selected_option.make_from_string( "Heavy")
			create {LINKED_LIST[like current]}option_select.make
			health := 200
		    energy := 0
		    armour := 10
		    vision := 0
		    move := -1
		    move_cost := 5
			create regen.default_create
			regen := [4, 0]
		end



end
