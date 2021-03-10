note
	description: "Summary description for {ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE

inherit
	STATES

create
	make
feature
	make
		do
			create state_name.make_from_string ("engine setup")
			create {LINKED_LIST[like current]}option_select.make
			create regen.default_create
			option_select.force (create {ENGINE_STANDARD}.make)
			option_select.force (create {ENGINE_LIGHT}.make)
			option_select.force (create {ENGINE_ARMOURED}.make)
			select_cursor := 1
			create selected_option.make_empty
		end

feature
	health, energy, armour,vision, move, move_cost : INTEGER
	regen: TUPLE[h_regen:like health; e_regen: like energy]
feature
	set_options
	local
		op : STRING
	do
		create op.make_empty

		  op.append ("  1:Standard%N")
		  op.append ("    Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2%N")
		  op.append ("  2:Light%N")
		  op.append ("    Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1%N")
		  op.append ("  3:Armoured%N")
		  op.append ("    Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5%N")
		  op.append ("  Engine Selected:" + option_select[select_cursor].selected_option)
		  model_access.m.print_state.set_options_string (op)
	end

	set_select_cursor (i : INTEGER)
		do
			select_cursor := i
		end

end
