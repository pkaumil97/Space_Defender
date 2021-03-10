note
	description: "Summary description for {ENGINE_ARMOURED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_ARMOURED

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
			create selected_option.make_from_string( "Armoured")
			create {LINKED_LIST[like current]}option_select.make
			health := 50
		    energy := 100
		    armour := 3
		    vision := 6
		    move := 4
		    move_cost := 5
			create regen.default_create
			regen := [0,3]
		end


end
