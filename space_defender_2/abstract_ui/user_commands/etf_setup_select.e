note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_SELECT
inherit
	ETF_SETUP_SELECT_INTERFACE
create
	make
feature -- command
	setup_select(value: INTEGER_32)
		require else
			setup_select_precond(value)
    	do
			-- perform some update on the model state

			if  (not model.isin_setup) or model.states_cursor = 5   then
				model.print_state.set_state_string (model.states[model.states_cursor].state_name, "error")
				model.print_state.set_error_string ("  Command can only be used in setup mode (excluding summary in setup).")
			elseif (model.states_cursor = 2) and value = 5 then
				model.print_state.set_state_string (model.states[model.states_cursor].state_name, "error")
				model.print_state.set_error_string ("  Menu option selected out of range.")
			elseif (model.states_cursor = 3) and (value = 4 or value = 5)  then
				model.print_state.set_state_string (model.states[model.states_cursor].state_name, "error")
				model.print_state.set_error_string ("  Menu option selected out of range.")
--			elseif (model.states_cursor = 4) and (value = 5)  then
--				model.print_state.set_state_string (model.states[model.states_cursor].state_name, "error")
--				model.print_state.set_error_string ("  Menu option selected out of range.")
			else
				model.setup_select(value)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
