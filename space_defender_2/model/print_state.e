note
	description: "Summary description for {PRINT_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRINT_STATE

inherit
	ANY
	redefine
		out
	end

create
	make

feature
	model_access : ETF_MODEL_ACCESS
	state_string : STRING
	welcome_string : STRING
	options_string : STRING
	starfighter_section : STRING
	enemy_section : STRING
	projectile_section:STRING
	friendly_projectile_section : STRING
	enemy_projectile_section : STRING
	starfighter_action_section: STRING
	enemy_action_section: STRING
	natural_enemy_spawn: STRING
	game_over: STRING
	state_rep: STRING
	rows : ARRAY[STRING]
	error: STRING
	score: STRING

	x : INTEGER
	y : INTEGER





feature -- constuctor

	make
	do

		create state_string.make_empty
		create welcome_string.make_empty
		create options_string.make_empty
		create starfighter_section.make_empty
		create enemy_section.make_from_string ("  Enemy:")
		create projectile_section.make_from_string("  Projectile:")
		create friendly_projectile_section.make_from_string("  Friendly Projectile Action:")
		create enemy_projectile_section.make_from_string("  Enemy Projectile Action:")
		create starfighter_action_section.make_from_string("  Starfighter Action:")
		create enemy_action_section.make_from_string("  Enemy Action:")
		create natural_enemy_spawn.make_from_string ("  Natural Enemy Spawn:")
		create game_over.make_empty
		create error.make_empty

		create state_rep.make_empty
		create score.make_empty

		rows := <<"A","B","C","D","E","F","G","H","I","J">>

	end

feature -- getters and setters


	setboard(grid : ARRAY2[STRING])
	do
	state_rep.make_empty

	if	model_access.m.isin_debug then
		current.state_rep.append ("    ")
		across 1 |..| grid.width is w
		loop
				if w < 10 then
				 state_rep.append ("  ")
				else
				 state_rep.append (" ")
				end
				state_rep.append (w.out)
		end

		state_rep.append ("%N")

			across 1 |..| grid.height is h
				loop
				   state_rep.append ("    ")
				   state_rep.append (rows[h])
				   state_rep.append (" ")
				   across 1 |..| grid.width is w
				   loop
				   		state_rep.append(grid.item (h, w))
				   		if w /= grid.width then
							state_rep.append ("  ")
						end
				   end
				   if h /= grid.height then
				   		 state_rep.append ("%N")
				   end


			end
		else
			current.state_rep.append ("    ")
			across 1 |..| grid.width is w
				loop
					if w < 10 then
					 state_rep.append ("  ")
					else
					 state_rep.append (" ")
					end
					state_rep.append (w.out)
				end

			state_rep.append ("%N")

				across 1 |..| grid.height is h
				loop
				   state_rep.append ("    ")
				   state_rep.append (rows[h])
				   state_rep.append (" ")
				   across 1 |..| grid.width is w
				   loop
				   		if not model_access.m.starfighter.can_seen_by_s (h, w) then
				   			state_rep.append ("?")
				   		else
				   			state_rep.append(grid.item (h, w))
				   		end
				   		if w /= grid.width then
							state_rep.append ("  ")
						end
				   end
				   if h /= grid.height then
				   		 state_rep.append ("%N")
				   end


				end

		end

	end
	set_compalete_empty
	do
		 state_string.make_empty
		 welcome_string.make_empty
		 error.make_empty
		 options_string.make_empty
		 state_rep.make_empty
		 starfighter_section.make_empty
		 score.make_empty
		 game_over.make_empty

		 enemy_section.make_empty

		 projectile_section.make_empty

		 friendly_projectile_section.make_empty

		 enemy_projectile_section.make_empty

		 starfighter_action_section.make_empty

		 enemy_action_section.make_empty

		 natural_enemy_spawn.make_empty

	end
	set_all_string_empty
	do

		 state_string.make_empty
		 welcome_string.make_empty
		 error.make_empty
		 options_string.make_empty
		 state_rep.make_empty
		 starfighter_section.make_empty
		 score.make_empty
		 game_over.make_empty


		 enemy_section.make_from_string ("  Enemy:")

		 projectile_section.make_from_string("  Projectile:")

		 friendly_projectile_section.make_from_string("  Friendly Projectile Action:")

		 enemy_projectile_section.make_from_string("  Enemy Projectile Action:")

		 starfighter_action_section.make_from_string("  Starfighter Action:")

		 enemy_action_section.make_from_string("  Enemy Action:")

		 natural_enemy_spawn.make_from_string ("  Natural Enemy Spawn:")



	end
-----------------------------------------------------------------------------------------------------------------------------------------------------------

	inc_x
		do
			x := x + 1
			y := 0
		end
	inc_y
		do
			y := y + 1
		end
	reset_xy
		do
			x := 0
			y := 0
		end
------------------------------------------------------------------------------------------------------------------------------------------------------------
	set_welcome_string(str : STRING)
	do
		welcome_string.append ("  ")
		welcome_string.append (str)
	end
	set_intial_state_string (str: STRING)
	do
		state_string.make_empty
		state_string.append ("  ")
		state_string.append (str)
		state_string.append ("%N")
	end
	set_state_string(state_name: STRING; status: STRING)
	do
		state_string.make_empty
		state_string.append ("  ")
		if state_name ~ "in game" then
			if model_access.m.isin_debug then
				state_string.append ("state:" + state_name + "(" + x.out + "." + y.out + ")" + ", " + "debug" + ", " + status)
			else
				state_string.append ("state:" + state_name + "(" + x.out + "." + y.out + ")" + ", " + "normal" + ", " + status)
			end
		else
			if model_access.m.isin_debug then
				state_string.append ("state:" + state_name + ", " + "debug" + ", " + status)
			else
				state_string.append ("state:" + state_name + ", " + "normal" + ", " + status)
			end
		end
		state_string.append ("%N")
	end
	set_error_string(str: STRING)
	do
		error.make_empty
		error.append(str)
	end


	set_options_string(str: STRING)
	do

		options_string.make_empty
		options_string.append (str)
	end

	set_starfighter_section(str: STRING)
	do
		starfighter_section.make_empty
		starfighter_section := str
		starfighter_section.append ("%N")
	end
	set_projectile_section (str: STRING)
	do
		projectile_section.append (str)

	end
	set_enemy_section (str: STRING)
	do
		enemy_section.append (str)
	end
	set_friendly_projectile_section(str: STRING)
	do
		friendly_projectile_section.append (str)
	end
	set_enemy_projectile_section(str: STRING)
	do
		enemy_projectile_section.append (str)
	end
	set_starfighter_action(str: STRING)
	do

		starfighter_action_section.append (str)

	end

	set_enemy_action_section (str: STRING)
	do
		enemy_action_section.append (str)
	end

	set_natural_enemy_spawn(str: STRING)
	do
		natural_enemy_spawn.append (str)

	end

	set_score_string(s : INTEGER)
	do
		score.make_empty
		score.append ("score:" + s.out)
		score.append ("%N")
	end
	set_game_over
	do
		 game_over.make_from_string ("%N  The game is over. Better luck next time!")
	end
feature --out

	out : STRING
	do
		create Result.make_empty

		Result.append (state_string)
		if not error.is_empty then
			Result.append (error)
		else

			Result.append(welcome_string)

			Result.append(options_string)

			Result.append (starfighter_section)
			if model_access.m.isin_debug  and not (model_access.m.turn ~ "debug_mode") and not model_access.m.isin_setup then

					Result.append (current.enemy_section)
					if not current.enemy_section.is_empty then
						Result.append ("%N")
					end


					Result.append (current.projectile_section)
					if not current.projectile_section.is_empty then
						Result.append ("%N")
					end


					Result.append (current.friendly_projectile_section)
					if not current.friendly_projectile_section.is_empty then
						Result.append ("%N")
					end


					Result.append (current.enemy_projectile_section)
					if not current.enemy_section.is_empty then
						Result.append ("%N")
					end

					Result.append (current.starfighter_action_section)
					if not current.enemy_section.is_empty then
						Result.append ("%N")
					end

					Result.append (current.enemy_action_section)
					if not current.enemy_section.is_empty then
						Result.append ("%N")
					end

					Result.append (current.natural_enemy_spawn)
					if not current.enemy_section.is_empty then
						Result.append ("%N")
					end


			end
			Result.append (score)

			Result.append (state_rep)
			if not model_access.m.in_game then
				Result.append (game_over)
			end

		end


	end
end
