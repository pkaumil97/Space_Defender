note
	description: "Summary description for {ENGINE_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_STANDARD

inherit
	ENGINE
	redefine
		make
	end
create
	make

feature
	make
		do
			create state_name.make_from_string ("Engine setup")
			create selected_option.make_from_string( "Standard")
			create {LINKED_LIST[like current]}option_select.make
			health := 10
		    energy := 60
		    armour := 1
		    vision := 12
		    move := 8
		    move_cost := 2
			create regen.default_create
			regen := [0, 2]
		end
end
