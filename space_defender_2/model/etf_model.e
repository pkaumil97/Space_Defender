note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			i := 0

			create s.make_empty

			create print_state.make

			create {LINKED_LIST[STATES]}states.make

			create starfighter.make

			create grid.make_filled ("_", 0, 0)
			states_cursor := 1
			enemyid_counter := 1
			projectileid_counter := -1

			adding_states
			initial_state
			create enemy_collection.make (100)
			enemy_collection.compare_objects
			create friendly_proj_collection.make (100)
			friendly_proj_collection.compare_objects
			create enemy_proj_collection.make(100)
			enemy_proj_collection.compare_objects
			create turn.make_empty
			create score.make
			isin_debug := false
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	print_state : PRINT_STATE
	states : LIST[STATES]
	states_cursor : INTEGER
	starfighter : STARFIGHTER
	grid : ARRAY2[STRING]
	random : RANDOM_GENERATOR_ACCESS
	random_i: INTEGER
	random_j: INTEGER
	enemyid_counter : INTEGER
	projectileid_counter : INTEGER
	enemy_collection : HASH_TABLE[ENEMY, INTEGER]
	friendly_proj_collection : HASH_TABLE[FRIENDLY_PROJECTILE, INTEGER]
	enemy_proj_collection : HASH_TABLE[ENEMY_PROJECTILE, INTEGER]
	turn : STRING
	in_game:BOOLEAN

	isin_debug : BOOLEAN
	isin_setup : BOOLEAN
	score : SCORE
--	isin_game : BOOLEAN


feature -- model operations

	abort
		do
			turn := "abort"

			current.set_in_game (false)

			-- starfighter
			create starfighter.make

			-- creating new hashtable
			create enemy_collection.make (100)
			enemy_collection.compare_objects
			create friendly_proj_collection.make (100)
			friendly_proj_collection.compare_objects
			create enemy_proj_collection.make(100)
			enemy_proj_collection.compare_objects


			--reset ids
			states_cursor := 1
			enemyid_counter := 1
			projectileid_counter := -1

			--a new grid
			create grid.make_filled ("_", 0, 0)

			create score.make


		end
	default_update
			-- Perform update to the model state.
		do
			i := i + 1

		end

	reset
			-- set model state.
		do
			make
		end
feature -- play command

			rows, columns, grunt_threshold, fighter_threshold, carrier_threshold, interceptor_threshold, pylon_threshold : INTEGER
feature -- state releated



----------------------------------------------------------------------------------------------------------------------------------

	initial_state
		do

			print_state.set_intial_state_string ("state:not started, normal, ok")
			print_state.set_welcome_string ("Welcome to Space Defender Version 2.")
		end

-----------------------------------------------------------------------------------------------------------------------------------
	adding_states
		do

			states.force (create {WEAPON}.make)
			states.force (create {ARMOUR}.make)
			states.force (create {ENGINE}.make)
			states.force (create {POWER}.make)
			states.force (create {SUMMARY}.make)
		end
-------------------------------------------------------------------------------------------------------------------------------------------		
	toggle_debug_mode
		do
			turn := "debug_mode"
			if isin_debug then
				isin_debug := false
				if states_cursor <= 5 and current.isin_setup then
					print_state.set_state_string (states[states_cursor].state_name, "ok")
				elseif not isin_setup AND NOT in_game then
					print_state.set_state_string ("not started", "ok")
				else
					print_state.inc_y
					print_state.set_state_string ("in game", "ok")
				end
				print_state.set_options_string ("  Not in debug mode.")
			else
				isin_debug := true
				if states_cursor <= 5 and current.isin_setup then
					print_state.set_state_string (states[states_cursor].state_name, "ok")
				elseif not isin_setup AND NOT in_game then
					print_state.set_state_string ("not started", "ok")
				else
					print_state.inc_y
					print_state.set_state_string ("in game", "ok")
				end
				print_state.set_options_string ("  In debug mode.")
			end


		end
------------------------------------------------------------------------------------------------------------------------------------------
	set_in_game(b : BOOLEAN)
	do
		in_game := b
		if not in_game then
			print_state.set_state_string ("not started", "ok")
		end
	end
----------------------------------------------------------------------------------------------------------------------------------------------
-- this is for testing of scoring


	test_score
			local
				bronze1, bronze2, silver, gold: ORB
				diamond, platinum: FOCUS
				total: SCORE
			do
				create total.make

				create {SILVER} silver.make
				total.add (silver)

				create {DIAMOND} diamond.make
				total.add (diamond)

				create {GOLD} gold.make
				total.add (gold)

				create {BRONZE} bronze1.make
				total.add (bronze1)

				create {PLATINUM} platinum.make
				total.add (platinum)

				create {BRONZE} bronze2.make
				total.add (bronze2)

--				current.set_score (total.get_score)
--				current.print_state.set_natural_enemy_spawn (total.get_score.out)


			end


-------------------------------------------------------------------------------------------------------------------------------------------

feature -- etf level
	play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		do

--			print_state.set_all_string_empty
			create starfighter.make

			-- creating new hashtable
			create enemy_collection.make (100)
			enemy_collection.compare_objects
			create friendly_proj_collection.make (100)
			friendly_proj_collection.compare_objects
			create enemy_proj_collection.make(100)
			enemy_proj_collection.compare_objects


			--reset ids
			states_cursor := 1
			enemyid_counter := 1
			projectileid_counter := -1

			--score
			create score.make

			print_state.set_compalete_empty
			isin_setup := true
			rows := row
			columns := column
			grunt_threshold := g_threshold
			fighter_threshold := f_threshold
			carrier_threshold := c_threshold
			interceptor_threshold := i_threshold
			pylon_threshold := p_threshold
			print_state.set_state_string (states[states_cursor].state_name, "ok")
			states[states_cursor].set_options

		end

	play_helper
		do

			grid.make_empty
			grid.make_filled ("_", rows, columns)
			grid.initialize ("_")
			starfighter.set_pos ((grid.height/2).ceiling_real_64.truncated_to_integer,1)
			grid.put (starfighter.symbole, starfighter.pos.s_r, starfighter.pos.s_c)

			current.set_in_game (true)

			turn.make_empty

--			current.test_score -- this is for testing only
		end

---------------------------------------------------------------------------------------------------------------------------------------		
	setup_next(st: INTEGER_32)
		do
			print_state.set_all_string_empty

			if (states_cursor + st) > 5 then

				-- play the game
				print_state.reset_xy
				print_state.set_state_string ("in game", "ok")
				starfighter.set_final_attribute
				current.set_in_game (true)
				isin_setup:= false
				play_helper
				starfighter.show
				print_state.setboard (grid)
				states_cursor := states_cursor + st




			else
				print_state.set_state_string (states[states_cursor + st].state_name, "ok")
				states_cursor := states_cursor + st
				states[states_cursor].set_options
				isin_setup := true
			end
		end

	setup_back(st: INTEGER_32)
		do
			print_state.set_all_string_empty
			print_state.set_state_string (states[states_cursor - st].state_name, "ok")
			if (states_cursor - st) < 1 then

				initial_state
				isin_setup := false

			else
				states_cursor := states_cursor - st

				states[states_cursor].set_options
			end
		end

	setup_select(value: INTEGER_32)
		do
			states[states_cursor].set_select_cursor (value)
			states[states_cursor].set_options
		end

------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
	move(row: INTEGER_32 ; column: INTEGER_32)
		local
			valid_r: INTEGER
			valid_c: INTEGER
			j, k, total_moves, retrived_id : INTEGER
			output, output0: STRING
		do
			-- apply health regen

			turn := "move"




			-- phase1 : friendly prjectile act
			if attached {WEAPON}states[1] as w then
				w.friendly_projectile_act
			end
			-- phase2 : enemy projectile act
	if in_game then
			current.enemy_projectile_act_f
	end
	if in_game then
			-- phase3 : starfighter act
			starfighter.health_regen
			starfighter.energy_regen





			valid_r := row - starfighter.pos.s_r
			valid_c := column - starfighter.pos.s_c


			-- substract the cost of moving from energy
			total_moves := valid_r.abs + valid_c.abs



			-- move the S, it can be distroyed on way
			create output.make_empty
			create output0.make_empty
			output0.append ("%N    The Starfighter(id:" + starfighter.id.out + ") moves: ["
							+ print_state.rows[starfighter.pos.s_r] + "," + (starfighter.pos.s_c).out
															 + "] -> ")
			grid.put ("_",starfighter.pos.s_r, starfighter.pos.s_c)



					if valid_r > 0  and in_game then
						across (starfighter.pos.s_r + 1) |..| row is r
						loop
							if in_game then


								starfighter.substract_energycost (1)
								retrived_id := retrive_id_by_pos (r, starfighter.pos.s_c)
									if retrived_id < 0 then
										if is_id_of_enemy_proj (retrived_id) then
											if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
												starfighter.set_current_health (starfighter.current_health - max(e_pro.damage - starfighter.total_armour, 0))
												e_pro.set_alive (false)
												grid.put ("_", e_pro.pos.f_r, e_pro.pos.f_c)
												output.append("%N      The Starfighter collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
																print_state.rows[r] +"," + starfighter.pos.s_c.out + "], taking "+ (e_pro.damage - starfighter.total_armour).out + " damage.")
                                             end
										elseif is_id_of_friendly_proj (retrived_id) then
											if attached friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
												starfighter.set_current_health ( starfighter.current_health - max(f_pro.damage - starfighter.total_armour, 0))
												f_pro.set_alive (false)
												grid.put ("_", f_pro.pos.f_r,  f_pro.pos.f_c)
												output.append("%N      The Starfighter collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
																print_state.rows[r] +"," + starfighter.pos.s_c.out + "], taking "+ (f_pro.damage - starfighter.total_armour).out + " damage.")


											end

										end
											if starfighter.current_health <= 0 then
												--game over
												set_in_game (false)
												starfighter.set_pos (r, starfighter.pos.s_c)
												grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
												print_state.set_game_over
												output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
												output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
													starfighter.pos.s_c.out + "] has been destroyed.")

											end
									elseif retrived_id > 0  then
										if attached enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
											    starfighter.set_current_health ((starfighter.current_health - e.current_health))
												e.set_alive(false)

												grid.put ("_", e.pos.e_r, e.pos.e_r)
												output.append("%N      The Starfighter collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
										    	print_state.rows[r] +"," + starfighter.pos.s_c.out + "], trading " +  (e.current_health).out + " damage." )

												output.append ("%N      The "+e.name+" at location ["+print_state.rows[e.pos.e_r]+","+ e.pos.e_c.out +"] has been destroyed.")
												if starfighter.current_health <= 0 then
													--game over
													set_in_game (false)
													starfighter.set_pos (r, starfighter.pos.s_c)
													grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
													print_state.set_game_over
													output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
													output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
													starfighter.pos.s_c.out + "] has been destroyed.")
												end

										end



									end
									end
						end
					end
					if valid_r < 0 and in_game then
						from
							j := starfighter.pos.s_r - 1

						until
							j < row
						loop
							if in_game then


							starfighter.substract_energycost (1)
							retrived_id := retrive_id_by_pos (j, starfighter.pos.s_c)
								if retrived_id < 0 then
										if is_id_of_enemy_proj (retrived_id) then
											if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
												starfighter.set_current_health (starfighter.current_health - max(e_pro.damage - starfighter.total_armour, 0))
												e_pro.set_alive (false)
												grid.put ("_", e_pro.pos.f_r, e_pro.pos.f_c)
												output.append("%N      The Starfighter collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
																print_state.rows[j] +"," + starfighter.pos.s_c.out + "], taking "+ (e_pro.damage - starfighter.total_armour).out + " damage.")
                                             end
										elseif is_id_of_friendly_proj (retrived_id) then
											if attached friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board  then
												starfighter.set_current_health ( starfighter.current_health - max(f_pro.damage - starfighter.total_armour, 0))
												f_pro.set_alive (false)
												grid.put ("_", f_pro.pos.f_r, f_pro.pos.f_c)
												output.append("%N      The Starfighter collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
																print_state.rows[j] +"," + starfighter.pos.s_c.out + "], taking "+ (f_pro.damage - starfighter.total_armour).out + " damage.")


											end

										end

											if starfighter.current_health <= 0 then
																--game over
												set_in_game (false)
												starfighter.set_pos (j, starfighter.pos.s_c)
												grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
												print_state.set_game_over
												output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
												output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
												starfighter.pos.s_c.out + "] has been destroyed.")

											end
								elseif retrived_id > 0  then
										if attached enemy_collection.at (retrived_id) as e and then e.is_alive then
											    starfighter.set_current_health ((starfighter.current_health - e.current_health))
												e.set_alive(false)

												grid.put ("_", e.pos.e_r, e.pos.e_c)

										    	output.append("%N      The Starfighter collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
										    	print_state.rows[j] +"," + starfighter.pos.s_c.out + "], trading " +  (e.current_health).out + " damage." )
												output.append ("%N      The "+e.name+" at location ["+print_state.rows[e.pos.e_r]+","+ e.pos.e_c.out +"] has been destroyed.")
												if starfighter.current_health <= 0 then
													--game over
													set_in_game (false)
													starfighter.set_pos (j, starfighter.pos.s_c)
													grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
													print_state.set_game_over
													output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
																	starfighter.pos.s_c.out + "] has been destroyed.")

												end

										end



								end
								end

							j := j -1
						end
					end
					if valid_c > 0 and in_game  then
						across (starfighter.pos.s_c + 1) |..| column  is c
						loop
							if in_game then


							starfighter.substract_energycost (1)
							retrived_id := retrive_id_by_pos (row, c)
							if retrived_id < 0 then
									if is_id_of_enemy_proj (retrived_id) then
										if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive then
											starfighter.set_current_health (starfighter.current_health - max(e_pro.damage - starfighter.total_armour, 0))
											e_pro.set_alive (false)

											grid.put ("_", e_pro.pos.f_r, e_pro.pos.f_c)
											output.append("%N      The Starfighter collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
															print_state.rows[row] +"," + c.out + "], taking "+ (e_pro.damage - starfighter.total_armour).out + " damage.")
                                         end
									elseif is_id_of_friendly_proj (retrived_id) then
										if attached friendly_proj_collection.at (retrived_id) as f_pro then
											starfighter.set_current_health ( starfighter.current_health - max(f_pro.damage - starfighter.total_armour, 0))
											f_pro.set_alive (false)
											grid.put ("_", f_pro.pos.f_r, f_pro.pos.f_c)
											output.append("%N      The Starfighter collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
															print_state.rows[row] +"," + c.out + "], taking "+ (f_pro.damage - starfighter.total_armour).out + " damage.")


										end



									end

									if starfighter.current_health <= 0 then
																		--game over
												set_in_game (false)
												starfighter.set_pos (row, c)
												grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
												print_state.set_game_over
												output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
												output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
												starfighter.pos.s_c.out + "] has been destroyed.")
									end
						   elseif retrived_id > 0  then
									if attached enemy_collection.at (retrived_id) as e and then e.is_alive then
										    starfighter.set_current_health ((starfighter.current_health - e.current_health))
											e.set_alive(false)
											grid.put ("_", e.pos.e_r, e.pos.e_c)

									    	output.append("%N      The Starfighter collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
									    			print_state.rows[row] +"," + c.out + "], trading " + ( e.current_health).out + " damage." )
											output.append ("%N      The "+e.name+" at location ["+print_state.rows[e.pos.e_r]+","+ e.pos.e_c.out +"] has been destroyed.")
									   			if starfighter.current_health <= 0 then
													--game over
													set_in_game (false)
													starfighter.set_pos (row, c)
													grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
													print_state.set_game_over
													output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
													output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
													starfighter.pos.s_c.out + "] has been destroyed.")
												end

									end




							end
							end


						end
					end
					if valid_c < 0 and in_game then
						from
						  	k := starfighter.pos.s_c - 1
						until
						  	k < column
						loop
							if in_game then


							starfighter.substract_energycost (1)
							retrived_id := retrive_id_by_pos (row, k)
							if retrived_id < 0 then
									if is_id_of_enemy_proj (retrived_id) then
										if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive then
											starfighter.set_current_health (starfighter.current_health - max(e_pro.damage - starfighter.total_armour, 0))
											e_pro.set_alive (false)
											output.append("%N      The Starfighter collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
															print_state.rows[row] +"," + k.out + "], taking "+ (e_pro.damage - starfighter.total_armour).out + " damage.")
                                             end
									elseif is_id_of_friendly_proj (retrived_id) then
										if attached friendly_proj_collection.at (retrived_id) as f_pro then
											starfighter.set_current_health ( starfighter.current_health - max(f_pro.damage - starfighter.total_armour, 0))
											f_pro.set_alive (false)
											output.append("%N      The Starfighter collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
															print_state.rows[row] +"," + k.out + "], taking "+ (f_pro.damage - starfighter.total_armour).out + " damage.")


										end



									end
									if starfighter.current_health <= 0 then
											--game over
												set_in_game (false)
												starfighter.set_pos (row, k)
												grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
												print_state.set_game_over
												output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
												output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
												starfighter.pos.s_c.out + "] has been destroyed.")
									end

						   elseif retrived_id > 0  then
									if attached enemy_collection.at (retrived_id) as e and then e.is_alive then
										    starfighter.set_current_health ((starfighter.current_health - e.current_health))
											e.set_alive(false)
											grid.put ("_", e.pos.e_r, e.pos.e_c)


									    	output.append("The Starfighter collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
									    			print_state.rows[row] +"," + k.out + "], trading " + (e.current_health).out + " damage." )
											output.append ("%N      The "+e.name+" at location ["+print_state.rows[e.pos.e_r]+","+ e.pos.e_c.out +"] has been destroyed.")
											if starfighter.current_health <= 0 then
																		--game over
																			set_in_game (false)
																			starfighter.set_pos (row, k)
																			grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
																			print_state.set_game_over
																			output0.append ("[" +print_state.rows[starfighter.pos.s_r] +"," + starfighter.pos.s_c.out +"]")
																			output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
																			starfighter.pos.s_c.out + "] has been destroyed.")
																end

									end






							end
							end
						 	k := k - 1
						end

					end

					if in_game then


						starfighter.pos.s_r := starfighter.pos.s_r + valid_r
						starfighter.pos.s_c := starfighter.pos.s_c + valid_c
						grid.put (starfighter.symbole, starfighter.pos.s_r, starfighter.pos.s_c)
						output0.append( "[" + print_state.rows[starfighter.pos.s_r] + "," + starfighter.pos.s_c.out + "]")
					end

					print_state.set_starfighter_action(output0)
					print_state.set_starfighter_action (output)

		end

				    -- phase 4 : enemy vision update
					if in_game then
				    	current.enemy_seen_update
					end
				    -- phase5 : enemy act
					if in_game then
						current.preemptive_action
						current.enemy_action
					end
					-- phase 6 : enemy vision update
					if in_game then
				    	current.enemy_seen_update
					end
				   -- phase 7 : natural enemy spawn
				  	if in_game then
				   		current.enemy_spawn
					end

					projectile_show_ph1
		    		enemy_show
		    		starfighter.show
					print_state.setboard (grid)

		end




--------------------------------------------------------------------------------------------------------------------------------------------------
	pass
		do

			turn := "pass"

			-- phase1 : friendly prjectile act
			if attached {WEAPON}states[1] as w then
				w.friendly_projectile_act
			end
			-- phase2 : enemy projectile act
			if in_game then
				current.enemy_projectile_act_f
			end
			-- phase3 : starfighter act
			if in_game then


			starfighter.health_regen
			starfighter.health_regen
			starfighter.energy_regen
			starfighter.energy_regen
			print_state.set_starfighter_action ( "%N" +
		    									"    The Starfighter(id:" + starfighter.id.out + ") passes at location [" +
		    									print_state.rows[starfighter.pos.s_r] + "," + starfighter.pos.s_c.out + "]" +
		    									", doubling regen rate.")
			end
	    -- phase 4 : enemy vision update
		if in_game then
	    	current.enemy_seen_update
		end
	    -- phase5 : enemy act
		if in_game then
			current.preemptive_action
			current.enemy_action
		end
		-- phase 6 : enemy vision update
		if in_game then
	    	current.enemy_seen_update
		end
	   -- phase 7 : natural enemy spawn
	  	if in_game then
	   		current.enemy_spawn
		end



			projectile_show_ph1
    		enemy_show
    		starfighter.show
			print_state.setboard (grid)

		end
-----------------------------------------------------------------------------------------------------------------------------------------------------
	fire
		local
			temp : INTEGER
		do
			turn := "fire"

			-- phase1 : friendly prjectile act
			if attached {WEAPON}states[1] as w then
				w.friendly_projectile_act
			end
			-- phase2 : enemy projectile act
			if in_game then
				current.enemy_projectile_act_f
			end



			-- phase3 : starfighter act
			if in_game then
			starfighter.health_regen
			starfighter.energy_regen
			starfighter.substract_cost_of_firing

			if attached {WEAPON}states[1] as w then
				w.fire
			end

			end



		    -- phase 4 : enemy vision update
			if in_game then
		    	current.enemy_seen_update
			end
		    -- phase5 : enemy act
			if in_game then
				current.preemptive_action
				current.enemy_action
			end
			-- phase 6 : enemy vision update
			if in_game then
		    	current.enemy_seen_update
			end
		   -- phase 7 : natural enemy spawn
		  	if in_game then
		   		current.enemy_spawn
			end
		   	projectile_show_ph1
    		enemy_show
    		starfighter.show
			print_state.setboard (grid)




		end
-----------------------------------------------------------------------------------------------------------------------------------------------------
	friendly_projectile_act
		local
			temp : INTEGER
		do
			from
				temp := -1
			until
				temp = projectileid_counter - 1
			loop
			if attached friendly_proj_collection.at (temp) as f then
				if f.pos.f_c < columns + 1 then
					grid.put ("_", f.pos.f_r, f.pos.f_c)
					print_state.set_friendly_projectile_section ("%N    ")
					print_state.set_friendly_projectile_section ("A friendly projectile(id:" + f.id.out + ") moves: [" +
																  print_state.rows[f.pos.f_r]  + "," + f.pos.f_c.out + "]")
				end
				f.pos.f_c := f.pos.f_c + 5
				if f.pos.f_c < columns + 1 then
					grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
					print_state.set_friendly_projectile_section (" -> " + "[" + print_state.rows[f.pos.f_r]  + "," + f.pos.f_c.out + "]")
				elseif (f.pos.f_c - 5) < columns + 1 then

					print_state.set_friendly_projectile_section (" -> out of board")
				end





			end
				temp := temp - 1
			end
		end

----------------------------------------------------------------------------------------------------------------------------------------------------
	enemy_projectile_act_f
		local
			temp, p : INTEGER
			retrived_id: INTEGER
			output, output0 : STRING
		do
			from
				temp := -1
			until
				temp = projectileid_counter - 1
			loop
				if attached enemy_proj_collection.at (temp) as e_p and then e_p.is_alive and then e_p.on_board and in_game then
					create output.make_empty
					create output0.make_empty
					grid.put ("_", e_p.pos.f_r, e_p.pos.f_c)
					output0.append("%N    A enemy projectile(id:"+ e_p.id.out + ") moves: [" + print_state.rows[e_p.pos.f_r] + "," + e_p.pos.f_c.out+ "] -> ")
					from
						p := e_p.pos.f_c - 1
					until
						p < (e_p.pos.f_c - e_p.move_per_turn)

					loop
						if in_game then


								retrived_id := retrive_id_by_pos (e_p.pos.f_r, p)

									if retrived_id < 0 and e_p.is_alive  then
											if is_id_of_friendly_proj (retrived_id) then
												if attached friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
													if (f_pro.damage > e_p.damage) then
														f_pro.set_damage (f_pro.damage - e_p.damage)
														e_p.set_alive (false)
													elseif (f_pro.damage < e_p.damage) then
														e_p.set_damage (e_p.damage - f_pro.damage)
														f_pro.set_alive (false)
														grid.put ("_", f_pro.pos.f_r, f_pro.pos.f_c)
													elseif (f_pro.damage = e_p.damage) then
														f_pro.set_alive (false)
														e_p.set_alive (false)
														grid.put ("_", f_pro.pos.f_r, f_pro.pos.f_c)

													end
													if not e_p.is_alive then

														e_p.set_pos (e_p.pos.f_r, p)
														if e_p.on_board then
															output0.append("[" + print_state.rows[e_p.pos.f_r] +"," + e_p.pos.f_c.out + "]" )
														else
															output0.append("out of board.")
														end
													end

													output.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																				") at location [" + print_state.rows[e_p.pos.f_r] +"," + p.out + "], negating damage.")


												end

											elseif is_id_of_enemy_proj (retrived_id) then
												if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
													e_p.set_damage (e_p.damage + e_pro.damage)
													e_pro.set_alive (false)
													grid.put ("_", e_pro.pos.f_r, e_pro.pos.f_c)

													output.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																				") at location [" + print_state.rows[e_p.pos.f_r] +"," + p.out + "], combining damage.")

												end

											end
									elseif retrived_id > 0 and e_p.is_alive then
											if attached enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

												e.set_current_health (e.current_health + e_p.damage)
												e_p.set_alive (false)
													if not e_p.is_alive then
														e_p.set_pos (e_p.pos.f_r, p)
														if e_p.on_board then
															output0.append("[" +print_state.rows[e_p.pos.f_r] +"," + e_p.pos.f_c.out + "]" )
														else
															output0.append("out of board")
														end
													end

													output.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
							    																 print_state.rows[e_p.pos.f_r] +"," + p.out + "], healing " + e_p.damage.out + " damage." )


											end


									elseif retrived_id = 0 and e_p.is_alive then

					                        --friendly_proj removed from the board
											-- S_current_health := health - max(freiendly_pro_damage - starfighter_armour, 0)

											-- current health below 0 after collition starfigher distroyed

																	starfighter.set_current_health (starfighter.current_health - max (e_p.damage - starfighter.total_armour, 0))
																	e_p.set_alive (false)

																	if starfighter.current_health < 0 then
																		-- game over
																	end
																	-- current health below 0 after collition starfigher distroyed
																	if not e_p.is_alive then

																				e_p.set_pos (e_p.pos.f_r, p)
																				if e_p.on_board then
																					output0.append("[" + print_state.rows[e_p.pos.f_r] +"," + e_p.pos.f_c.out + "]" )
																				else
																					output.append("out of board" )
																				end
																	end
																	output.append("%N      The projectile collides with "+ starfighter.name + "(id:" + starfighter.id.out + ") at location [" +
																	    														print_state.rows[e_p.pos.f_r] +"," + p.out + "], dealing " + (e_p.damage - starfighter.total_armour).out + " damage." )
																	-- The projectile collides with <entity name>(id:<id>) at location [X,Y], dealing <projectile damage - entity armour> damage.

																	if starfighter.current_health <= 0 then
																												--game over
																		set_in_game (false)
																		starfighter.set_pos (starfighter.pos.s_r, starfighter.pos.s_c)
																		grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
																		print_state.set_game_over

																		output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
																		starfighter.pos.s_c.out + "] has been destroyed.")

																	end
									end
							end
							p := p - 1
						end

							if e_p.is_alive then

								e_p.set_pos (e_p.pos.f_r, e_p.pos.f_c - e_p.move_per_turn)
								if e_p.on_board  then
									grid.put (e_p.symbole, e_p.pos.f_r, e_p.pos.f_c)
									output0.append("[" + print_state.rows[e_p.pos.f_r] +"," + e_p.pos.f_c.out + "]" )
								else
									output0.append("out of board" )
								end

							end

							print_state.set_enemy_projectile_section (output0)
							print_state.set_enemy_projectile_section (output)


				end
				temp := temp - 1
			end
		end

-------------------------------------------------------------------------------------------------------------------------
	preemptive_action
		local
			temp, k: INTEGER
		do
			k := enemy_collection.count

			from
				temp := 1
			until
				temp > k
			loop
				if attached current.enemy_collection.at (temp) as e and then e.is_alive and then e.on_board and in_game then

					e.preemptive_action
				end
				temp := temp + 1
			end

		end
---------------------------------------------------------------------------------------------------------------------------
	enemy_projectile_act
		local
			temp : INTEGER
		do
			from
				temp := -1
			until
				temp = projectileid_counter - 1
			loop
			if attached enemy_proj_collection.at (temp) as f  then
				if f.pos.f_c > 0 then
					grid.put ("_", f.pos.f_r, f.pos.f_c)
					print_state.set_enemy_projectile_section ("%N    ")
					print_state.set_enemy_projectile_section ("A enemy projectile(id:" + f.id.out + ") moves: [" +
																  print_state.rows[f.pos.f_r]  + "," + f.pos.f_c.out + "]")
				end
				f.pos.f_c := f.pos.f_c - f.move_per_turn

				if f.pos.f_c > 0 then
					grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
					print_state.set_enemy_projectile_section (" -> " + "[" + print_state.rows[f.pos.f_r]  + "," + f.pos.f_c.out + "]")
				elseif (f.pos.f_c + f.move_per_turn) > 0 then

					print_state.set_enemy_projectile_section (" -> out of board")
				end





			end
				temp := temp - 1
			end
		end
-----------------------------------------------------------------------------------------------------------------------------------------------------

	enemy_seen_update
		do
		across 1 |..| enemy_collection.count is j
			loop

				if attached enemy_collection.at (j) as e and then e.is_alive and then e.on_board and in_game then

					e.set_seen_by_starfighter
					e.set_can_see_starfighter

				end
			end

		end
---------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------
	enemy_action

		local
			temp, k: INTEGER
		do
			k := enemy_collection.count

			from
				temp := 1
			until
				temp > k
			loop
				if attached current.enemy_collection.at (temp) as e and then e.is_alive and then e.on_board and in_game then
					if (not e.end_turn) then
						e.health_regen
						e.action
					end
				end
				temp := temp + 1
			end

		end

---------------------------------------------------------------------------------------------------------------------------------------------------------	
	enemy_show
		local
			k : INTEGER
		do
			k := enemy_collection.count
			across 1 |..| k is j
			loop

				if attached enemy_collection.at (j) as e and then e.is_alive and then e.on_board then
--				if e.pos.e_c > 0 then
				e.set_end_turn(false)
				print_state.set_enemy_section ("%N    " + "[" + e.id.out + "," + e.symbole + "]->" +
												"health:" + e.current_health.out +"/" + e.total_health.out +
												", Regen:"+ e.regen.out + ", Armour:" + e.armour.out +
												", Vision:" + e.vision.out +", seen_by_Starfighter:"+
												 if e.seen_by_starfighter then "T" else "F" end +
												 ", can_see_Starfighter:" +
												 if e.can_see_starfighter then "T" else "F" end +
												 ", location:[" + print_state.rows[e.pos.e_r] +
												 "," + e.pos.e_c.out + "]")

--				end
				end
			end
		end

	projectile_show_ph1
		local
			temp : INTEGER
		do
--			from
--				j := -1
--			until
--				j < enemy_proj_collection.count
--			loop
--				if attached enemy_proj_collection.at (j) as ep then

--					print_state.set_projectile_section ("    [" + ep.id.out + "," + ep.symbole + "]->damage:" + ep.damage.out + ","  + "move:"
--															+ ep.move_per_turn.out + ", location:[ " + print_state.rows[ep.pos.f_r] + "," + ep.pos.f_c.out + "]" )

--				end
--				j := j - 1
--			end
			from
				temp := -1
			until
				temp = projectileid_counter - 1
			loop
			if attached enemy_proj_collection.at (temp) as f and then f.is_alive and then f.on_board then

--				if f.pos.f_c > 0 then


				print_state.set_projectile_section("%N    ")
				print_state.set_projectile_section( "[" + f.id.out + "," + f.symbole +
													"]->damage:" + f.damage.out + ", move:"+ f.move_per_turn.out +
													", location:[" + print_state.rows[f.pos.f_r] + ","+ f.pos.f_c.out + "]")
--				end

			end
			if attached current.friendly_proj_collection.at (temp) as f and then f.is_alive and then f.on_board then
				print_state.set_projectile_section("%N    ")
				print_state.set_projectile_section( "[" + f.id.out + "," + f.symbole +
													"]->damage:" + f.damage.out + ", move:"+ f.move_per_turn.out +
													", location:[" + print_state.rows[f.pos.f_r] + ","+ f.pos.f_c.out + "]")
			end
				temp := temp - 1
			end
	end



-----------------------------------------------------------------------------------------------------------------------------------------------------
	update_enemyid
		do
			enemyid_counter := enemyid_counter + 1
		end
	update_projectileid
		do
			projectileid_counter := projectileid_counter - 1
		end
	enemy_spawn
		local
			enemy: ENEMY

		do
			random_i := random.rchoose (1, grid.height)
			random_j := random.rchoose (1, 100)
			if (not (current.retrive_id_by_pos (random_i, grid.width) > 0)) or  current.retrive_id_by_pos (random_i, grid.width) = 9999 then


			if 1 <= random_j and random_j < grunt_threshold then


				create {GRUNT} enemy.make(enemyid_counter)
				enemy.set_pos (random_i,grid.width)
				enemy.set_seen_by_starfighter
				enemy.set_can_see_starfighter
				grid.put (enemy.symbole, enemy.pos.e_r, enemy.pos.e_c)

				print_state.set_natural_enemy_spawn ("%N    A Grunt(id:" + enemyid_counter.out + ") spawns at location [" + print_state.rows[random_i] + "," + enemy.pos.e_c.out + "].")
				current.enemy_spawn_collision (enemy)
				enemy_collection.put (enemy, enemyid_counter)

				update_enemyid
			elseif grunt_threshold <= random_j and random_j < fighter_threshold then
				create {FIGHTER} enemy.make(enemyid_counter)
				enemy.set_pos (random_i,grid.width)
				enemy.set_seen_by_starfighter
				enemy.set_can_see_starfighter
				grid.put (enemy.symbole, enemy.pos.e_r, enemy.pos.e_c)
				print_state.set_natural_enemy_spawn ("%N    A Fighter(id:" + enemyid_counter.out + ") spawns at location [" + print_state.rows[random_i] + "," + enemy.pos.e_c.out + "].")
				current.enemy_spawn_collision (enemy)
				enemy_collection.put (enemy, enemyid_counter)

				update_enemyid

			elseif fighter_threshold <= random_j and random_j < carrier_threshold then
				create {CARRIER} enemy.make(enemyid_counter)
				enemy.set_pos (random_i,grid.width)
				enemy.set_seen_by_starfighter
				enemy.set_can_see_starfighter
				grid.put (enemy.symbole, enemy.pos.e_r, enemy.pos.e_c)

				print_state.set_natural_enemy_spawn ("%N    A Carrier(id:" + enemyid_counter.out + ") spawns at location [" + print_state.rows[random_i] + "," + enemy.pos.e_c.out + "].")

				current.enemy_spawn_collision (enemy)
				enemy_collection.put (enemy, enemyid_counter)

				update_enemyid

			elseif carrier_threshold <= random_j and random_j < interceptor_threshold then
				create {INTERCEPTOR} enemy.make(enemyid_counter)
				enemy.set_pos (random_i,grid.width)
				enemy.set_seen_by_starfighter
				enemy.set_can_see_starfighter
				grid.put (enemy.symbole, enemy.pos.e_r, enemy.pos.e_c)
				print_state.set_natural_enemy_spawn ("%N    A Interceptor(id:" + enemyid_counter.out + ") spawns at location [" + print_state.rows[random_i] + "," + enemy.pos.e_c.out + "].")

				current.enemy_spawn_collision (enemy)
				enemy_collection.put (enemy, enemyid_counter)

				update_enemyid

			elseif interceptor_threshold <= random_j and random_j < pylon_threshold  then
				create {PYLON} enemy.make(enemyid_counter)
				enemy.set_pos (random_i,grid.width)
				enemy.set_seen_by_starfighter
				enemy.set_can_see_starfighter
				grid.put (enemy.symbole, enemy.pos.e_r, enemy.pos.e_c)
				print_state.set_natural_enemy_spawn ("%N    A Pylon(id:" + enemyid_counter.out + ") spawns at location [" + print_state.rows[random_i] + "," + enemy.pos.e_c.out + "].")

				current.enemy_spawn_collision (enemy)
				enemy_collection.put (enemy, enemyid_counter)

				update_enemyid



			end

			end


		end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	enemy_spawn_collision (e: ENEMY)
		local
			retrived_id : INTEGER
			output : STRING
		do
			create output.make_empty
			retrived_id := retrive_id_by_pos (e.pos.e_r, e.pos.e_c)
				if retrived_id < 0 and e.is_alive then
						if is_id_of_enemy_proj (retrived_id) then
							if attached enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
								e.set_current_health(e.current_health + e_pro.damage)
								e_pro.set_alive (false)
								grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
								output.append("%N      The "+ e.name +" collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
											print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], healing "+ (e_pro.damage).out + " damage.")

                                        end
						elseif is_id_of_friendly_proj (retrived_id) then
							if attached friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
								e.set_current_health ( e.current_health - max((f_pro.damage - e.armour), 0))
								f_pro.set_alive (false)


								output.append("%N      The "+ e.name +" collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
									print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], taking "+ (f_pro.damage - e.armour).out + " damage.")

									if e.current_health <= 0 then
											-- enemy distroyed
											e.set_alive(false)
											grid.put("_", f_pro.pos.f_r, f_pro.pos.f_c)
											output.append ("%N      The " + e.name +" at location ["+print_state.rows[e.pos.e_r]+","+e.pos.e_c.out+"] has been destroyed.")
									end
							end

						end


			  elseif retrived_id = 0 and e.is_alive then
						starfighter.set_current_health (starfighter.current_health - e.current_health)
						e.set_alive (false)
						grid.put ("S", starfighter.pos.s_r, starfighter.pos.s_c)



						output.append("%N      The "+ e.name +" collides with "+ starfighter.name + "(id:" + starfighter.id.out+ ") at location [" +
						    			print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], trading " + ( e.current_health).out + " damage." )
						output.append ("%N      The "+ e.name+" at location [" + print_state.rows[e.pos.e_r]
																								+"," + e.pos.e_c.out +"] has been destroyed.")
						 	if starfighter.current_health <= 0 then
																																		--game over
									set_in_game (false)
									starfighter.set_pos (starfighter.pos.s_r, starfighter.pos.s_c)
									grid.put ("X", starfighter.pos.s_r, starfighter.pos.s_c)
									print_state.set_game_over
									output.append ("%N      The "+ starfighter.name +" at location [" + print_state.rows[starfighter.pos.s_r] + "," +
									starfighter.pos.s_c.out + "] has been destroyed.")
							end

			  end

			  print_state.set_natural_enemy_spawn (output)

		end
---------------------------------------------------------------------------------------------------------------------------------------------------------
 	special
 		do
 			turn := "special"

 						-- phase1 : friendly prjectile act
			if attached {WEAPON}states[1] as w then
				w.friendly_projectile_act
			end
			-- phase2 : enemy projectile act
			if in_game then
				current.enemy_projectile_act_f
			end
			-- phase3 : starfighter act
			if in_game then
			starfighter.health_regen
			starfighter.energy_regen
			if attached {POWER}states[4] as p then
				p.special
			end
			end
		    -- phase 4 : enemy vision update
			if in_game then
		   	 	current.enemy_seen_update
			end
		    -- phase5 : enemy act
			if in_game then
				current.preemptive_action
				current.enemy_action
			end
			-- phase 6 : enemy vision update
			if in_game then
		    	current.enemy_seen_update
			end
		   -- phase 7 : natural enemy spawn
		   	if in_game then
		   		current.enemy_spawn
			end

			projectile_show_ph1
    		enemy_show
    		starfighter.show
			print_state.setboard (grid)



 		end

------------------------------------------------------------------------------------------------------------------------------------------------------------
	retrive_id_by_pos (r : INTEGER; c: INTEGER): INTEGER

		do
			Result := 9999
			across current.friendly_proj_collection is f_pro
			loop
				 if f_pro.pos.f_r = r and f_pro.pos.f_c = c and f_pro.is_alive and f_pro.on_board then
				 	Result := f_pro.id
				 end
			end

			across current.enemy_proj_collection is e_pro
			loop
				if e_pro.pos.f_r = r and e_pro.pos.f_c = c and e_pro.is_alive and e_pro.on_board then
					Result := e_pro.id
				end
			end

			across current.enemy_collection is e
			loop
				if e.pos.e_r = r and e.pos.e_c = c and e.is_alive and e.on_board then
					Result := e.id
				end
			end
			if starfighter.pos.s_r = r and starfighter.pos.s_c = c then
					Result := starfighter.id
			end



		end
	is_id_of_enemy_proj (id: INTEGER) : BOOLEAN
		do
			if current.enemy_proj_collection.has (id) then
				Result := true
			else
				Result := false
			end

		end
	is_id_of_friendly_proj (id: INTEGER) : BOOLEAN
		do
			if current.friendly_proj_collection.has (id) then
				Result := true
			else
				Result := false
			end

		end

--------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------
	max(a : INTEGER; b: INTEGER) : INTEGER
		do
			if a > b then
				Result := a
			else
				Result := b
			end
		end

------------------------------------------------------------------------------------------------------------------------------------------------------
feature -- queries

	out : STRING
		do
			create Result.make_from_string ("  ")
			Result := print_state.out
		end

end




