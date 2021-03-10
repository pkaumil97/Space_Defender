note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ABORT
inherit
	ETF_ABORT_INTERFACE
create
	make
feature -- command
	abort
    	do
			-- perform some update on the model state
		--	if (not model.in_game) or (not model.isin_setup) then
			model.print_state.set_compalete_empty
			if not model.in_game then


			 		model.print_state.inc_y
			 		model.print_state.set_state_string ("not started", "error")
			 		model.print_state.set_error_string ("  Command can only be used in setup mode or in game.")
			else
					model.print_state.set_compalete_empty
					model.print_state.reset_xy
					model.print_state.set_state_string ("not started", "ok")
					model.print_state.set_error_string ("  Exited from game.")
					model.abort
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
