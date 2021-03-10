note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER
inherit
	ENEMY
create
	make
feature
	make(enemy_id: INTEGER)
		do
			current_health:= 200
			total_health:= 200
			regen:= 10
			armour:= 15
			vision:= 15
			id := enemy_id
			create pos.default_create
			create symbole.make_from_string ("C")
			create name.make_from_string ("Carrier")
			is_alive := true
			set_on_board

		end
	set_end_turn(ending_turn : BOOLEAN)
		do
			end_turn := ending_turn
		end
	set_current_health (curr_health : INTEGER)
		do
			current_health := curr_health
			if current.current_health >= current.total_health then
				current_health := total_health
			end
		end
	set_total_health (tot_health : INTEGER)
		do
			total_health := tot_health
		end
	set_pos(row: INTEGER; column: INTEGER)
		do
		 	pos.e_r := row
		 	pos.e_c := column
--		 	set_seen_by_starfighter
--		 	set_can_see_starfighter
		 	set_on_board
		end
	set_seen_by_starfighter
		do
			seen_by_starfighter :=	((pos.e_r - model_access.m.starfighter.pos.s_r).abs + (pos.e_c - model_access.m.starfighter.pos.s_c).abs) <= model_access.m.starfighter.total_vision
		end
	set_can_see_starfighter
		do
			can_see_starfighter := ((pos.e_r - model_access.m.starfighter.pos.s_r).abs + (pos.e_c - model_access.m.starfighter.pos.s_c).abs) <= vision
		end
	set_on_board
		do
			if ((pos.e_r < 1) or (pos.e_r > model_access.m.grid.height) or (pos.e_c < 1) or (pos.e_c > model_access.m.grid.width))  then
				on_board := false
			else
				on_board := true
			end
		end
	set_alive (alive: BOOLEAN)
		do
			is_alive := alive
			if not is_alive then
				model_Access.m.score.add (create {DIAMOND}.make)
			end
		end
	health_regen
		do
			if current_health < total_health then
				current_health := current_health + regen
				if current_health > total_health then
					current_health := total_health
				end
			end
		end

	preemptive_action
		local
			output : STRING
			interceptor1, interceptor2: INTERCEPTOR
		do


			if model_access.m.turn ~ "special" then
				create output.make_empty
				regen := regen + 10
				output.append("%N    A "+ name + "(id:" + id.out + ") gains "+ "10" + " regen.")
				model_access.m.print_state.set_enemy_action_section (output)
			end

			if model_access.m.turn ~ "pass" then
				current.set_end_turn (true)
				current.health_regen
				moving(2)
				if is_alive and on_board then
					if (not (model_access.m.retrive_id_by_pos (pos.e_r - 1, pos.e_c) > 0)) or (model_access.m.retrive_id_by_pos (pos.e_r - 1, pos.e_c) = 9999) then
							create output.make_empty
							create interceptor1.make (model_access.m.enemyid_counter)
							interceptor1.set_pos (pos.e_r - 1, pos.e_c)
							interceptor1.set_can_see_starfighter
							interceptor1.set_seen_by_starfighter
							interceptor1.set_end_turn (true)  -- very important
							output.append ("%N      A "+ interceptor1.name +"(id:"+ interceptor1.id.out + ") spawns at location ")
							   if interceptor1.on_board then
									output.append("["+ model_access.m.print_state.rows[interceptor1.pos.e_r] + ","+  interceptor1.pos.e_c.out + "].")
							   else
								    output.append ("out of board.")
							   end
							   model_access.m.print_state.set_enemy_action_section (output)
							current.enemy_collition (interceptor1)
							if interceptor1.is_alive and interceptor1.on_board then
								model_access.m.grid.put (interceptor1.symbole, interceptor1.pos.e_r, interceptor1.pos.e_c)
							end
							model_access.m.enemy_collection.put (interceptor1, interceptor1.id)
							model_access.m.update_enemyid
					end

					if (not (model_access.m.retrive_id_by_pos (pos.e_r + 1, pos.e_c) > 0)) or (model_access.m.retrive_id_by_pos (pos.e_r + 1, pos.e_c) = 9999) then
							create output.make_empty
							create interceptor2.make (model_access.m.enemyid_counter)
							interceptor2.set_pos (pos.e_r + 1, pos.e_c)
							interceptor2.set_can_see_starfighter
							interceptor2.set_seen_by_starfighter
							interceptor2.set_end_turn (true)  -- very important
							output.append ("%N      A "+ interceptor2.name +"(id:"+ interceptor2.id.out + ") spawns at location ")
							   if interceptor2.on_board then
									output.append("["+model_access.m.print_state.rows[interceptor2.pos.e_r] + ","+  interceptor2.pos.e_c.out + "].")
							   else
								    output.append ("out of board.")
							   end
							   model_access.m.print_state.set_enemy_action_section (output)
							current.enemy_collition (interceptor2)
							if interceptor2.is_alive and interceptor2.on_board then
								model_access.m.grid.put (interceptor2.symbole, interceptor2.pos.e_r, interceptor2.pos.e_c)
							end
							model_access.m.enemy_collection.put (interceptor2, interceptor2.id)
							model_access.m.update_enemyid
					end
				end

			end




		end

	action
		local
			interceptor1: INTERCEPTOR
			output: STRING
		do
			create output.make_empty

			if can_see_starfighter then
				moving(1)
				if is_alive and on_board then
						if (not (model_access.m.retrive_id_by_pos (pos.e_r, pos.e_c - 1) > 0)) or (model_access.m.retrive_id_by_pos (pos.e_r , pos.e_c - 1) = 9999) then
							create interceptor1.make (model_access.m.enemyid_counter)
							interceptor1.set_pos (pos.e_r, pos.e_c - 1)
							interceptor1.set_can_see_starfighter
							interceptor1.set_seen_by_starfighter
							output.append ("%N      A "+ interceptor1.name +"(id:"+ interceptor1.id.out + ") spawns at location ")
							   if interceptor1.on_board then
									output.append("["+model_access.m.print_state.rows[interceptor1.pos.e_r] + ","+  interceptor1.pos.e_c.out + "].")
							   else
								    output.append ("out of board.")
							   end
							   model_access.m.print_state.set_enemy_action_section (output)
							current.enemy_collition (interceptor1)
							if interceptor1.is_alive and interceptor1.on_board then
								model_access.m.grid.put (interceptor1.symbole, interceptor1.pos.e_r, interceptor1.pos.e_c)
							end
							model_access.m.enemy_collection.put (interceptor1, interceptor1.id)
							model_access.m.update_enemyid
						end
				end

			else
				moving(2)
			end

		end

	moving (spaces : INTEGER)
		local
			output, output0 : STRING
			k, i, retrived_id : INTEGER
			stop : BOOLEAN
		do
			create output.make_empty
			create output0.make_empty
			if on_board and is_alive then
				model_access.m.grid.put ("_", pos.e_r, pos.e_c)
			    output0.append("%N    A "+ name +"(id:" + id.out + ") moves: [" + model_access.m.print_state.rows[pos.e_r] +
									"," + pos.e_c.out +"] -> ")
			end
					i := pos.e_c - 1
					from
						k := i
					until
						k < ((i + 1) - spaces)
					loop
						if is_alive and on_board and (not stop) and model_access.m.in_game then

									retrived_id := model_access.m.retrive_id_by_pos (pos.e_r, k)
										if retrived_id < 0 and is_alive then
												if model_access.m.is_id_of_enemy_proj (retrived_id) then
													if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
														set_current_health(current_health + e_pro.damage)
														e_pro.set_alive (false)
														model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
														output.append("%N      The "+ name +" collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
																		model_access.m.print_state.rows[pos.e_r] +"," + k.out + "], healing "+ (e_pro.damage).out + " damage.")

				                                        end
												elseif model_access.m.is_id_of_friendly_proj (retrived_id) then
													if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
														set_current_health ( current_health - model_access.m.max((f_pro.damage - armour), 0))
														f_pro.set_alive (false)
														model_access.m.grid.put("_", f_pro.pos.f_r, f_pro.pos.f_c)

														output.append("%N      The "+ name +" collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
															model_access.m.print_state.rows[pos.e_r] +"," + k.out + "], taking "+ (f_pro.damage - armour).out + " damage.")
														if current_health <= 0 then
																		-- enemy distroyed
																		set_alive(false)
																		set_pos(pos.e_r, k)
																		model_access.m.grid.put("_", pos.e_r, pos.e_c)
																		stop := true
																		output.append ("%N      The "+name+" at location [" + model_Access.m.print_state.rows[pos.e_r]
																						+"," + pos.e_c.out +"] has been destroyed.")
														end
													end

												end
									   elseif retrived_id > 0 and is_alive  then
												if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
													    stop := true



												end

									  elseif retrived_id = 0 and is_alive then
												model_access.m.starfighter.set_current_health ( model_access.m.starfighter.current_health - current_health)
												current.set_alive (false)
												set_pos(pos.e_r, k)
												model_access.m.grid.put("_", pos.e_r, pos.e_c)


												output.append("%N      The "+ name +" collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out+ ") at location [" +
												    	model_access.m.print_state.rows[pos.e_r] +"," + k.out + "], trading " + (current_health).out + " damage." )
												 output.append ("%N      The "+ name+" at location ["+ model_access.m.print_state.rows[pos.e_r] + "," + pos.e_c.out +"] has been destroyed.")
												if model_access.m.starfighter.current_health <= 0 then
																																		--game over
																model_access.m.set_in_game (false)
																model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																model_access.m.print_state.set_game_over
																output.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
												end
									  end
						    if stop and is_alive then
						    	set_pos(pos.e_r, k + 1)
						    elseif is_alive then

								set_pos(pos.e_r, k)
							end
						end
					k := k - 1
					end


			 		if on_board and is_alive then
						output0.append ("[" + model_access.m.print_state.rows[pos.e_r]+ "," + pos.e_c.out + "]")
						model_access.m.grid.put (symbole, pos.e_r, pos.e_c)
			 		elseif on_board then
			 			output0.append ("[" + model_access.m.print_state.rows[pos.e_r]+ "," + pos.e_c.out + "]")
			 		else
						output0.append ("out of board")
					end

					if
						(i  + 1) = pos.e_c
					then
						output0.make_empty
						output0.append("%N    A "+ name +"(id:" + id.out + ") stays at: [" + model_access.m.print_state.rows[pos.e_r] +
									"," + pos.e_c.out +"]")
					end

				model_access.m.print_state.set_enemy_action_section (output0)
				model_access.m.print_state.set_enemy_action_section (output)




		end

	enemy_collition(e: ENEMY)
		local
			retrived_id : INTEGER
			output : STRING
		do
			create output.make_empty
			retrived_id := model_access.m.retrive_id_by_pos (e.pos.e_r, e.pos.e_c)
				if retrived_id < 0 and e.is_alive then
						if model_access.m.is_id_of_enemy_proj (retrived_id) then
							if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
								e.set_current_health(e.current_health + e_pro.damage)
								e_pro.set_alive (false)
								model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
								output.append("%N      The "+ e.name +" collides with enemy projectile(id:"+ e_pro.id.out+ ") at location [" +
											model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], healing "+ (e_pro.damage).out + " damage.")

                                        end
						elseif model_access.m.is_id_of_friendly_proj (retrived_id) then
							if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
								e.set_current_health ( e.current_health - model_access.m.max((f_pro.damage - e.armour), 0))
								f_pro.set_alive (false)
								model_access.m.grid.put("_", f_pro.pos.f_r, f_pro.pos.f_c)

								output.append("%N      The "+ e.name +" collides with friendly projectile(id:"+ f_pro.id.out+ ") at location [" +
									model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], taking "+ (f_pro.damage - e.armour).out + " damage.")

									if e.current_health <= 0 then
												-- enemy distroyed
												e.set_alive(false)
												e.set_pos(e.pos.e_r, e.pos.e_c)
												model_access.m.grid.put("_", e.pos.e_r, e.pos.e_c)
												output.append ("%N      The "+ e.name+" at location [" + model_Access.m.print_state.rows[e.pos.e_r]
																+"," + e.pos.e_c.out +"] has been destroyed.")
									end
							end

						end


			  elseif retrived_id = 0 and e.is_alive then
						model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - e.current_health)
						e.set_alive (false)




						output.append("%N      The "+ e.name +" collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out+ ") at location [" +
						    			model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], trading " + (e.current_health).out + " damage." )

										-- enemy distroyed
					--	model_access.m.grid.put("_", e.pos.e_r, e.pos.e_c)
						output.append ("%N      The "+ e.name+" at location [" + model_Access.m.print_state.rows[e.pos.e_r]
										+"," + e.pos.e_c.out +"] has been destroyed.")

						if model_access.m.starfighter.current_health <= 0 then
																												--game over
								model_access.m.set_in_game (false)
								model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
								model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
								model_access.m.print_state.set_game_over
								output.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
								model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
						end
			  end

			  model_access.m.print_state.set_enemy_action_section (output)

		end

end
