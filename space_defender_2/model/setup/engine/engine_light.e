note
	description: "Summary description for {ENGINE_LIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_LIGHT

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
			create selected_option.make_from_string( "Light")
			create {LINKED_LIST[like current]}option_select.make
			health := 0
		    energy := 30
		    armour := 0
		    vision := 15
		    move := 10
		    move_cost := 1
			create regen.default_create
			regen := [0,1]
		end

end
