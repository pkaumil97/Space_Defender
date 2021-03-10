note
	description: "Summary description for {FRIENDLY_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE
create
	make
feature
	pos : TUPLE[f_r: INTEGER; f_c:INTEGER]
	id : INTEGER
	damage: INTEGER
	move_per_turn: INTEGER
	symbole : STRING
	on_board : BOOLEAN
	model_access : ETF_MODEL_ACCESS
	is_alive : BOOLEAN
feature
	make(f_id: INTEGER)
		do
			id := f_id
			create symbole.make_from_string("*")
			create pos.default_create
			is_alive := true
			current.set_on_board
		end
	set_alive (alive : BOOLEAN)
		do
			is_alive := alive
		end

	set_damage(d: INTEGER)
		do
			damage := d
		end
	set_pos (row: INTEGER; column: INTEGER)
		do
			pos.f_r := row
			pos.f_c	:= column
			set_on_board
		end
	set_move_per_turn (move_steps : INTEGER)
		do
			move_per_turn := move_steps
		end
	set_on_board
		do
			if ((pos.f_r < 1) or (pos.f_r > model_access.m.grid.height) or (pos.f_c < 1) or (pos.f_c > model_access.m.grid.width))  then
				on_board := false
			else
				on_board := true
			end
		end

end
