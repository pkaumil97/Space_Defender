note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SPECIAL
inherit
	ETF_SPECIAL_INTERFACE
create
	make
feature -- command
	special
    	do
			-- perform some update on the model state
			model.print_state.set_compalete_empty
			if not model.in_game then

				model.print_state.set_state_string ("not started", "error")
				model.print_state.set_error_string ("  Command can only be used in game.")

			else
				if (model.states[4].select_cursor = 1 or model.states[4].select_cursor = 2) and (model.starfighter.current_energy + model.starfighter.total_e_regen)  >= 50 then
						model.print_state.set_all_string_empty
						model.print_state.inc_x
						model.print_state.set_state_string ("in game", "ok")
						model.special
				elseif (model.states[4].select_cursor = 4 or model.states[4].select_cursor = 5) and (model.starfighter.current_energy + model.starfighter.total_e_regen)  >= 100  then

											model.print_state.set_all_string_empty
											model.print_state.inc_x
											model.print_state.set_state_string ("in game", "ok")
											model.special
				elseif model.states[4].select_cursor = 3 then

											model.print_state.set_all_string_empty
											model.print_state.inc_x
											model.print_state.set_state_string ("in game", "ok")
											model.special
				else
								model.print_state.inc_y
								model.print_state.set_state_string ("in game", "error")
								model.print_state.set_error_string ("  Not enough resources to use special.")

				end

			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
