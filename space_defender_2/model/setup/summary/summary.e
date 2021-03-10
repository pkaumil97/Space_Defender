note
	description: "Summary description for {SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUMMARY

inherit
	STATES

create
	make
feature
	make
		do
			create state_name.make_from_string("setup summary")
			create {LINKED_LIST[like current]}option_select.make
			create selected_option.make_empty
		end
	set_options
		local
			op: STRING
		do
			create op.make_empty
			op.append ("  Weapon Selected:" + model_access.m.states[1].option_select[model_access.m.states[1].select_cursor].selected_option + "%N")
			op.append ("  Armour Selected:" + model_access.m.states[2].option_select[model_access.m.states[2].select_cursor].selected_option + "%N")
			op.append ("  Engine Selected:" + model_access.m.states[3].option_select[model_access.m.states[3].select_cursor].selected_option + "%N")
			op.append ("  Power Selected:" + model_access.m.states[4].option_select[model_access.m.states[4].select_cursor].selected_option)

			model_access.m.print_state.set_options_string (op)
		end

	set_select_cursor(i : INTEGER)
		do

		end

end
