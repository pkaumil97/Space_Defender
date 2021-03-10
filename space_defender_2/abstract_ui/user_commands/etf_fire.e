note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state

			model.print_state.set_compalete_empty
			if not model.in_game then
				model.print_state.set_state_string ("not started", "error")
				model.print_state.set_error_string ("  Command can only be used in game.")
			else
					model.print_state.set_all_string_empty
					model.print_state.inc_x
					model.print_state.set_state_string ("in game", "ok")
					model.fire
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
