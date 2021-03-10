note
	description: "Summary description for {ARMOUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR
inherit
	STATES


create
	make
feature
	make
		do
			create state_name.make_from_string ("armour setup")
			create {LINKED_LIST[like current]}option_select.make
			create regen.default_create
			option_select.force (create {ARMOUR_NONE}.make)
			option_select.force (create {LIGHT}.make)
			option_select.force (create {MEDIUM}.make)
			option_select.force (create {HEAVY}.make)
			select_cursor := 1
			create selected_option.make_empty
		end

feature
	health, energy, armour,vision, move, move_cost : INTEGER
	regen: TUPLE[h_regen :like health; e_regen :like energy]

feature
	set_select_cursor (i : INTEGER)
		do
			select_cursor := i
		end
feature

	set_options
	local
		op : STRING
	do
		create op.make_empty

		  op.append ("  1:None%N")
		  op.append ("    Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0%N")
		  op.append ("  2:Light%N")
		  op.append ("    Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1%N")
		  op.append ("  3:Medium%N")
		  op.append ("    Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3%N")
		  op.append ("  4:Heavy%N")
		  op.append ("    Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5%N")
		  op.append ("  Armour Selected:" + option_select[select_cursor].selected_option)

		model_access.m.print_state.set_options_string (op)
	end


end
