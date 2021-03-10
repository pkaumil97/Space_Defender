note
	description: "Summary description for {ROCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROCKET

inherit
	WEAPON
	redefine
		make,fire, friendly_projectile_act
	end
create
	make

feature
	make
		do
			create state_name.make_from_string ("weapon setup")
			create selected_option.make_from_string( "Rocket")
			create {LINKED_LIST[like current]}option_select.make
			health := 10
		    energy := 0
		    armour := 2
		    vision := 2
		    move := 0
		    move_cost := 3
		    projectile_damage:= 100
		    projectile_cost:=10 -- (health)
			create regen.default_create
			regen := [10, 0]

	end


fire
	local
		p1: FRIENDLY_PROJECTILE
		p2: FRIENDLY_PROJECTILE
		retrived_id : INTEGER
	do
		create p1.make (model_access.m.projectileid_counter)
		p1.set_pos(model_access.m.starfighter.pos.s_r - 1, model_access.m.starfighter.pos.s_c - 1)
		p1.set_move_per_turn (1)
		p1.set_damage (projectile_damage)
				model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:" + model_access.m.starfighter.id.out + ") fires at location [" +
																	model_access.m.print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																	model_access.m.starfighter.pos.s_c.out +"]." + "%N      " +
	      																"A friendly projectile(id:" + p1.id.out + ") spawns at location " +
	      																	if p1.on_board then
      																"[" + model_access.m.print_state.rows[p1.pos.f_r]+ "," + p1.pos.f_c.out+ "]."
      															else
      																"out of board."
      															end


																	)
				retrived_id := model_access.m.retrive_id_by_pos (p1.pos.f_r, p1.pos.f_c)
								if retrived_id < 0 and p1.is_alive then
									------
									if model_access.m.is_id_of_enemy_proj (retrived_id)  and p1.is_alive then
										if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board  then
												if (e_pro.damage > p1.damage) then
													e_pro.set_damage (e_pro.damage - p1.damage)
													p1.set_alive (false)

												elseif (e_pro.damage < p1.damage) then
													p1.set_damage (p1.damage - e_pro.damage)
													e_pro.set_alive(false)
													model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
												elseif (e_pro.damage = p1.damage) then
													p1.set_alive (false)
													e_pro.set_alive(false)
													model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
												end

												model_access.m.print_state.set_starfighter_action ("%N    The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																							") at location [" + model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], negating damage.")
										end

									elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p1.is_alive then
											if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
												 p1.set_damage (p1.damage + f_pro.damage)
												 f_pro.set_alive (false)
												 model_access.m.print_state.set_starfighter_action ("%N   The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																							") at location [" + model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], combining damage.")
											end

									end
									-------
								elseif retrived_id > 0 then
									if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

												e.set_current_health (e.current_health - model_access.m.max (p1.damage - e.armour, 0))
												p1.set_alive (false)


										    	model_access.m.print_state.set_starfighter_action ("The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
										    																 model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], dealing " + (p1.damage - e.armour).out + " damage." )

												if e.current_health <= 0 then
												e.set_alive (false)
												model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
												model_access.m.print_state.set_starfighter_action ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
												end
									end
								end

								if  p1.is_alive and p1.on_board then
									model_access.m.grid.put (p1.symbole, p1.pos.f_r, p1.pos.f_c)
								end


		model_access.m.friendly_proj_collection.put (p1, p1.id)
		model_access.m.update_projectileid

		create p2.make (model_access.m.projectileid_counter)
		p2.set_pos(model_access.m.starfighter.pos.s_r + 1, model_access.m.starfighter.pos.s_c - 1)
		p2.set_move_per_turn (1)
		p2.set_damage (projectile_damage)
				model_access.m.print_state.set_starfighter_action (  "%N      " +
	      																"A friendly projectile(id:" + p2.id.out + ") spawns at location " +
	      																	if p2.on_board then
      																"[" + model_access.m.print_state.rows[p2.pos.f_r]+ "," + p2.pos.f_c.out+ "]."
      															else
      																"out of board."
      															end


																	)
		retrived_id := model_access.m.retrive_id_by_pos (p2.pos.f_r, p2.pos.f_c)
						if retrived_id < 0  and p2.is_alive then
							------
							if model_access.m.is_id_of_enemy_proj (retrived_id)  and p2.is_alive then
								if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board  then
										if (e_pro.damage > p2.damage) then
											e_pro.set_damage (e_pro.damage - p2.damage)
											p2.set_alive (false)
										elseif (e_pro.damage < p2.damage) then
											p2.set_damage (p2.damage - e_pro.damage)
											e_pro.set_alive(false)
										elseif (e_pro.damage = p2.damage) then
											p2.set_alive (false)
											e_pro.set_alive(false)
										end

										model_access.m.print_state.set_starfighter_action ("%N    The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																					") at location [" + model_access.m.print_state.rows[p2.pos.f_r] +"," + p2.pos.f_c.out + "], negating damage.")
								end

							elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p2.is_alive then
									if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
										 p2.set_damage (p2.damage + f_pro.damage)
										 f_pro.set_alive (false)
										 model_access.m.print_state.set_starfighter_action ("%N   The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																					") at location [" + model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], combining damage.")
									end

							end
							-------
						elseif retrived_id > 0 and p2.is_alive then
							if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

										e.set_current_health (e.current_health - model_access.m.max (p2.damage - e.armour, 0))
										p2.set_alive (false)


								    	model_access.m.print_state.set_starfighter_action ("The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
								    																 model_access.m.print_state.rows[p2.pos.f_r] +"," + p2.pos.f_c.out + "], dealing " + (p2.damage - e.armour).out + " damage." )

										if e.current_health <= 0 then
																						e.set_alive (false)
																						model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
																						model_access.m.print_state.set_starfighter_action ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
																						end
							end
						end

						if  p2.is_alive and p2.on_board then
							model_access.m.grid.put (p2.symbole, p2.pos.f_r, p2.pos.f_c)
						end

		model_access.m.friendly_proj_collection.put (p2, p2.id)
		model_access.m.update_projectileid




	end

	friendly_projectile_act
		local
			retrived_id : INTEGER
			temp, k : INTEGER
			list_key: ARRAY[INTEGER]
			output0: STRING
			output: STRING

		do
			create list_key.make_from_array (model_access.m.friendly_proj_collection.current_keys)
			from
				temp := 1
			until
				temp > list_key.count
			loop

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				if attached model_access.m.friendly_proj_collection.at (list_key[temp]) as f  and then f.is_alive and then f.on_board and model_access.m.in_game then
					create output0.make_empty
					create output.make_empty
					model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
					output0.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] + "," + f.pos.f_c.out +"] -> ")
					k := f.pos.f_c
					across (k + 1) |..| (k + f.move_per_turn) is p
					loop

					retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r, p)

							if retrived_id < 0 and f.is_alive then
								if model_access.m.is_id_of_enemy_proj (retrived_id) then
									if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
										if (e_pro.damage > f.damage) then
											e_pro.set_damage (e_pro.damage - f.damage)
											f.set_alive (false)

										elseif (e_pro.damage < f.damage) then
											f.set_damage (f.damage - e_pro.damage)
											e_pro.set_alive(false)
											model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
										elseif (e_pro.damage = f.damage) then
											f.set_alive (false)
											e_pro.set_alive(false)
											model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
										end
										if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append ("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board.")
											end
										end
										output.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out +
													  ") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] + "," + p.out + "], negating damage.")

									end

								elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
									if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
										 f.set_damage (f.damage + f_pro.damage)
										 f_pro.set_alive (false)
										 model_access.m.grid.put("_", f_pro.pos.f_r, f.pos.f_c)

										 output.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
													   ") at location [" + model_access.m.print_state.rows[f_pro.pos.f_r] +"," + p.out + "], combining damage.")

									end

								end
							elseif retrived_id > 0 and f.is_alive then
								if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

										e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
										f.set_alive (false)
										if e.current_health <= 0 then
											e.set_alive (false)
											model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
											output.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
										end
										if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board")
											end
										end
								    	output.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
								    																 model_access.m.print_state.rows[f.pos.f_r] +"," + p.out + "], dealing " + (f.damage - e.armour).out + " damage." )


								end


							elseif retrived_id = 0 and f.is_alive then

		                        --friendly_proj removed from the board
								-- S_current_health := health - max(freiendly_pro_damage - starfighter_armour, 0)
								model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
								f.set_alive (false)

								if model_access.m.starfighter.current_health < 0 then
									-- game over
								end
								-- current health below 0 after collition starfigher distroyed
								if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board" )
											end
								end
								output.append("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
								    														 model_access.m.print_state.rows[f.pos.f_r] +"," + p.out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )
								-- The projectile collides with <entity name>(id:<id>) at location [X,Y], dealing <projectile damage - entity armour> damage.
								if model_access.m.starfighter.current_health <= 0 then
															-- game over
																	model_access.m.set_in_game (false)
																	model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																	model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																	model_access.m.print_state.set_game_over
																	output.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																		model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
														end


							end
					end

					if f.is_alive then
						f.set_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)

						f.set_move_per_turn (( 2 * (f.move_per_turn)))
						if f.on_board then
							model_access.m.grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
							output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
						else
							output0.append("out of board" )
						end

					end

					model_access.m.print_state.set_friendly_projectile_section (output0)
					model_access.m.print_state.set_friendly_projectile_section (output)
				end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				if attached model_access.m.friendly_proj_collection.at (list_key[temp + 1]) as f  and then f.is_alive and then f.on_board and model_access.m.in_game then
					create output0.make_empty
					create output.make_empty
					model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
					output0.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] + "," + f.pos.f_c.out +"] -> ")
					k := f.pos.f_c
					across (k + 1) |..| (k + f.move_per_turn) is p
					loop

					retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r, p)

							if retrived_id < 0 and f.is_alive then
								if model_access.m.is_id_of_enemy_proj (retrived_id) then
									if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
										if (e_pro.damage > f.damage) then
											e_pro.set_damage (e_pro.damage - f.damage)
											f.set_alive (false)

										elseif (e_pro.damage < f.damage) then
											f.set_damage (f.damage - e_pro.damage)
											e_pro.set_alive(false)
											model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
										elseif (e_pro.damage = f.damage) then
											f.set_alive (false)
											e_pro.set_alive(false)
											model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
										end
										if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append ("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board.")
											end
										end
										output.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out +
													  ") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] + "," + p.out + "], negating damage.")

									end

								elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
									if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
										 f.set_damage (f.damage + f_pro.damage)
										 f_pro.set_alive (false)
										 model_access.m.grid.put("_", f_pro.pos.f_r, f.pos.f_c)

										 output.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
													   ") at location [" + model_access.m.print_state.rows[f_pro.pos.f_r] +"," + p.out + "], combining damage.")

									end

								end
							elseif retrived_id > 0 and f.is_alive then
								if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

										e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
										f.set_alive (false)
										if e.current_health <= 0 then
											e.set_alive (false)
											model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
											output.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
										end
										if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board")
											end
										end
								    	output.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
								    																 model_access.m.print_state.rows[f.pos.f_r] +"," + p.out + "], dealing " + (f.damage - e.armour).out + " damage." )


								end


							elseif retrived_id = 0 and f.is_alive then

		                        --friendly_proj removed from the board
								-- S_current_health := health - max(freiendly_pro_damage - starfighter_armour, 0)
								model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
								f.set_alive (false)

								if model_access.m.starfighter.current_health < 0 then
									-- game over
								end
								-- current health below 0 after collition starfigher distroyed
								if not f.is_alive then

											f.set_pos (f.pos.f_r, p)
											if f.on_board then
												output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
											else
												output0.append("out of board" )
											end
								end
								output.append("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
								    														 model_access.m.print_state.rows[f.pos.f_r] +"," + p.out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )
								-- The projectile collides with <entity name>(id:<id>) at location [X,Y], dealing <projectile damage - entity armour> damage.
									if model_access.m.starfighter.current_health <= 0 then
																-- game over
																		model_access.m.set_in_game (false)
																		model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																		model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																		model_access.m.print_state.set_game_over
																		output.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																			model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
															end

							end
					end

					if f.is_alive then
						f.set_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)

						f.set_move_per_turn ((2 * (f.move_per_turn)))
						if f.on_board then
							model_access.m.grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
							output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
						else
							output0.append("out of board" )
						end

					end

					model_access.m.print_state.set_friendly_projectile_section (output0)
					model_access.m.print_state.set_friendly_projectile_section (output)
				end


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




				temp := temp + 2
			end
		end

end
