note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		require else
			play_precond(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
    	do
			-- perform some update on the model state
			model.print_state.set_compalete_empty
			if model.isin_setup then

				model.print_state.set_error_string ("  Already in setup mode.")

			elseif model.in_game then
				model.print_state.inc_y
		        model.print_state.set_error_string ("  Already in a game. Please abort to start a new one.")
		    else
		    	if  (g_threshold <= f_threshold) and (f_threshold<= c_threshold) and  (c_threshold<= i_threshold) and  (i_threshold<= p_threshold) then

		    			model.play(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
		    	else
		    			model.print_state.inc_y
		    			model.print_state.set_error_string ("  Threshold values are not non-decreasing.")
		    	end
			end
			etf_cmd_container.on_change.notify ([Current])
    	end


end
