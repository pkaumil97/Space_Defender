note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
		local
			move_row : INTEGER
    	do
			-- perform some update on the model state
			if row = A then move_row := 1
			elseif row = B then move_row := 2
			elseif row = C then move_row := 3
			elseif row = D then move_row := 4
			elseif row = E then move_row := 5
			elseif row = F then move_row := 6
			elseif row = G then move_row := 7
			elseif row = H then move_row := 8
			elseif row = I then move_row := 9
			else move_row := 10
			end
			model.print_state.set_compalete_empty
			if not model.in_game and not model.isin_setup then
				model.print_state.set_state_string ("not started", "error")
				model.print_state.set_error_string ("  Command can only be used in game.")
			elseif model.isin_setup then
				model.print_state.inc_y
				model.print_state.set_state_string (model.states[model.states_cursor].state_name, "error")
				model.print_state.set_error_string ("  Command can only be used in game.")
			elseif move_row > model.grid.height or column > model.grid.width then
				model.print_state.inc_y
				model.print_state.set_state_string ("in game", "error")
				model.print_state.set_error_string ("  Cannot move outside of board.")
			elseif
				move_row = model.starfighter.pos.s_r and column = model.starfighter.pos.s_c
			then
				model.print_state.inc_y
				model.print_state.set_state_string ("in game", "error")
				model.print_state.set_error_string ("  Already there.")
			elseif ((move_row - model.starfighter.pos.s_r).abs + (column - model.starfighter.pos.s_c).abs ) > model.starfighter.total_move then
				model.print_state.inc_y
				model.print_state.set_state_string ("in game", "error")
				model.print_state.set_error_string ("  Out of movement range.")
			elseif ( ((move_row - model.starfighter.pos.s_r).abs + (column - model.starfighter.pos.s_c).abs ) * model.starfighter.total_move_cost ) > model.starfighter.current_energy then
				model.print_state.inc_y
				model.print_state.set_state_string ("in game", "error")
				model.print_state.set_error_string ("  Not enough resources to move.")
			else
				model.print_state.set_all_string_empty
				model.print_state.inc_x
				model.print_state.set_state_string ("in game", "ok")
				model.move(move_row, column)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
