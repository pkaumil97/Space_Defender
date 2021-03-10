note
	description: "Summary description for {SPREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPREAD

inherit
	WEAPON
	redefine
		make, fire, friendly_projectile_act
	end
create
	make

feature
	make
		do
			create state_name.make_from_string ("weapon setup")
			create selected_option.make_from_string( "Spread")
			create {LINKED_LIST[like current]}option_select.make
			health := 0
		    energy := 60
		    armour := 1
		    vision := 0
		    move := 0
		    move_cost := 2
		    projectile_damage := 50
		    projectile_cost := 10
			create regen.default_create
			regen := [0, 2]

		end

	fire
		local
			p1: FRIENDLY_PROJECTILE
			p2: FRIENDLY_PROJECTILE
			p3: FRIENDLY_PROJECTILE
			retrived_id : INTEGER
		do
			create p1.make (model_access.m.projectileid_counter)
			p1.set_pos(model_access.m.starfighter.pos.s_r - 1, model_access.m.starfighter.pos.s_c + 1)
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
							if retrived_id < 0 and p1.is_alive  then
								------
								if model_access.m.is_id_of_enemy_proj (retrived_id)  and p1.is_alive then
									if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board then
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

											model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																						") at location [" + model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], negating damage.")
									end

								elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p1.is_alive then
										if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
											 p1.set_damage (p1.damage + f_pro.damage)
											 f_pro.set_alive (false)
											 model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																						") at location [" + model_access.m.print_state.rows[p1.pos.f_r] +"," + p1.pos.f_c.out + "], combining damage.")
										end

								end
								-------
							elseif retrived_id > 0 and p1.is_alive then
								if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

											e.set_current_health (e.current_health - model_access.m.max (p1.damage - e.armour, 0))
											p1.set_alive (false)


									    	model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
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
			p2.set_pos(model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c + 1)
			p2.set_move_per_turn (1)
			p2.set_damage (projectile_damage)
			model_access.m.print_state.set_starfighter_action ("%N      " +
      																"A friendly projectile(id:" + p2.id.out + ") spawns at location " +
      															if p2.on_board then
      																"[" + model_access.m.print_state.rows[p2.pos.f_r]+ "," + p2.pos.f_c.out+ "]."
      															else
      																"out of board."
      															end


																)

				retrived_id := model_access.m.retrive_id_by_pos (p2.pos.f_r, p2.pos.f_c)
								if retrived_id < 0 and p2.is_alive  then
									------
									if model_access.m.is_id_of_enemy_proj (retrived_id)  and p2.is_alive then
										if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board  then
												if (e_pro.damage > p2.damage) then
													e_pro.set_damage (e_pro.damage - p2.damage)
													p2.set_alive (false)
												elseif (e_pro.damage < p2.damage) then
													p2.set_damage (p2.damage - e_pro.damage)
													e_pro.set_alive(false)
													model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
												elseif (e_pro.damage = p2.damage) then
													p2.set_alive (false)
													e_pro.set_alive(false)
													model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
												end

												model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																							") at location [" + model_access.m.print_state.rows[p2.pos.f_r] +"," + p2.pos.f_c.out + "], negating damage.")
										end

									elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p2.is_alive then
											if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
												 p2.set_damage (p2.damage + f_pro.damage)
												 f_pro.set_alive (false)
												 model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																							") at location [" + model_access.m.print_state.rows[p2.pos.f_r] +"," + p2.pos.f_c.out + "], combining damage.")
											end

									end
									-------
								elseif retrived_id > 0 and p2.is_alive then
									if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

												e.set_current_health (e.current_health - model_access.m.max (p2.damage - e.armour, 0))
												p2.set_alive (false)


										    	model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
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

			create p3.make (model_access.m.projectileid_counter)
			p3.set_pos(model_access.m.starfighter.pos.s_r + 1, model_access.m.starfighter.pos.s_c + 1)
			p3.set_move_per_turn (1)
			p3.set_damage (projectile_damage)
			model_access.m.print_state.set_starfighter_action ("%N      " +
      																"A friendly projectile(id:" + p3.id.out + ") spawns at location " +
      																	if p3.on_board then
      																"[" + model_access.m.print_state.rows[p3.pos.f_r]+ "," + p3.pos.f_c.out+ "]."
      															else
      																"out of board."
      															end


																)

					retrived_id := model_access.m.retrive_id_by_pos (p3.pos.f_r, p3.pos.f_c)
									if retrived_id < 0 and p3.is_alive  then
										------
										if model_access.m.is_id_of_enemy_proj (retrived_id)  and p3.is_alive then
											if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive  then
													if (e_pro.damage > p3.damage) then
														e_pro.set_damage (e_pro.damage - p3.damage)
														p3.set_alive (false)
													elseif (e_pro.damage < p3.damage) then
														p3.set_damage (p3.damage - e_pro.damage)
														e_pro.set_alive(false)
														model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
													elseif (e_pro.damage = p3.damage) then
														p3.set_alive (false)
														e_pro.set_alive(false)
														model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
													end

													model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																								") at location [" + model_access.m.print_state.rows[p3.pos.f_r] +"," + p3.pos.f_c.out + "], negating damage.")
											end

										elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p3.is_alive then
												if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive then
													 p3.set_damage (p3.damage + f_pro.damage)
													 f_pro.set_alive (false)
													 model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																								") at location [" + model_access.m.print_state.rows[p3.pos.f_r] +"," + p3.pos.f_c.out + "], combining damage.")
												end

										end
										-------
									elseif retrived_id > 0 then
										if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive then

													e.set_current_health (e.current_health - model_access.m.max (p3.damage - e.armour, 0))
													p3.set_alive (false)


											    	model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
											    																 model_access.m.print_state.rows[p3.pos.f_r] +"," + p3.pos.f_c.out + "], dealing " + (p3.damage - e.armour).out + " damage." )

													if e.current_health <= 0 then
													e.set_alive (false)
													model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
													model_access.m.print_state.set_starfighter_action ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
													end
										end
									end

									if  p3.is_alive and p3.on_board then
										model_access.m.grid.put (p3.symbole, p3.pos.f_r, p3.pos.f_c)
									end


			model_access.m.friendly_proj_collection.put (p3, p3.id)
			model_access.m.update_projectileid


		end

	friendly_projectile_act

		local
			retrived_id : INTEGER
			temp : INTEGER
			list_key: ARRAY[INTEGER]
			output01, output02, output03 : STRING
			output1, output2, output3 : STRING

		do

			create list_key.make_from_array (model_access.m.friendly_proj_collection.current_keys)
			from
				temp := 1
			until
				temp > list_key.count
			loop

			if attached model_access.m.friendly_proj_collection.at (list_key[temp]) as f and then f.is_alive and then f.on_board and model_access.m.in_game then
				create output01.make_empty
				create output1.make_empty
				model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
				output01.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] +
																			"," + f.pos.f_c.out +"] -> ")

				retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r - 1, f.pos.f_c + 1)

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

										f.set_pos (f.pos.f_r - 1, f.pos.f_c + 1)
										if f.on_board then
											 output01.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output01.append("out of board.")
										end
									end
									output1.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																				") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] +"," + e_pro.pos.f_c.out + "], negating damage.")

								end

							elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
								if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
									--f_pro removed prom the board	
									f.set_damage (f.damage + f_pro.damage)
									f_pro.set_alive (false)
									model_access.m.grid.put("_", f_pro.pos.f_r, f.pos.f_c)

									output1.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
															") at location [" + model_access.m.print_state.rows[f_pro.pos.f_r] +"," + f_pro.pos.f_c.out + "], combining damage.")

								end

							end
						elseif retrived_id > 0 and f.is_alive  then
							if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
									e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
									f.set_alive (false)
									output1.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
							    																 model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], dealing " + (f.damage - e.armour).out + " damage." )

									if e.current_health <= 0 then
										e.set_alive (false)
										model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
										output1.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
									end
									if not f.is_alive then

										f.set_pos (f.pos.f_r - 1, f.pos.f_c + 1)
										if f.on_board then
											output01.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output01.append("out of board")
										end
									end

							end


						elseif retrived_id = 0 and f.is_alive then

	                       	model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
							f.set_alive (false)
							-- current health below 0 after collition starfigher distroyed
							if not f.is_alive then
										model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
										f.set_pos (f.pos.f_r - 1, f.pos.f_c + 1)
										if f.on_board then
											output01.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output01.append("out of board" )
										end
							end
							output1.append ("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
							    														 model_access.m.print_state.rows[f.pos.f_r] +"," + (f.pos.f_c).out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )

							if model_access.m.starfighter.current_health <= 0 then
														-- game over
										model_access.m.set_in_game (false)
										model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
										model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
										model_access.m.print_state.set_game_over
										output1.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
											model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
							end

						end
					if f.is_alive then

						f.set_pos (f.pos.f_r - 1, f.pos.f_c + 1)

						if f.on_board then
							model_access.m.grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
							output01.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
						else
							output01.append("out of board" )
						end

					end

					model_access.m.print_state.set_friendly_projectile_section (output01)
					model_access.m.print_state.set_friendly_projectile_section (output1)

				end
--------------------------------------------------------------------------------------------------------------------
			if attached model_access.m.friendly_proj_collection.at (list_key[temp + 1]) as f and then f.is_alive and then f.on_board and model_access.m.in_game then
				create output02.make_empty
				create output2.make_empty
				model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
				output02.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] +
																			"," + f.pos.f_c.out +"] -> ")

				retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r, f.pos.f_c + 1)

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

										f.set_pos (f.pos.f_r, f.pos.f_c + 1)
										if f.on_board then
											output02.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output02.append("out of board.")
										end
									end
									output2.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																				") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] +"," + e_pro.pos.f_c.out + "], negating damage.")

								end

							elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
								if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro then
									--f_pro removed prom the board	
									f.set_damage (f.damage + f_pro.damage)
									f_pro.set_alive (false)

									output2.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
													") at location [" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "], combining damage.")

								end

							end
						elseif retrived_id > 0 and f.is_alive then
							if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
								e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
									f.set_alive (false)
									output2.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
							    							model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], dealing " + (f.damage - e.armour).out + " damage." )

									if e.current_health <= 0 then
										e.set_alive (false)
										model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
										output2.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
									end
									if not f.is_alive then

										f.set_pos (f.pos.f_r , f.pos.f_c + 1)
										if f.on_board then
											output02.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output02.append("out of board")
										end
									end

							end


						elseif retrived_id = 0 and f.is_alive then

	                       	model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
							f.set_alive (false)

							if model_access.m.starfighter.current_health < 0 then
								-- game over
							end
							-- current health below 0 after collition starfigher distroyed
							if not f.is_alive then

										f.set_pos (f.pos.f_r , f.pos.f_c + 1)
										if f.on_board then
											output02.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
										else
											output02.append("out of board" )
										end
							end
							output2.append("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
							    														 model_access.m.print_state.rows[f.pos.f_r] +"," + (f.pos.f_c).out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )

							if model_access.m.starfighter.current_health <= 0 then
														-- game over
																model_access.m.set_in_game (false)
																model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
																model_access.m.print_state.set_game_over
																output2.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																	model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
													end

						end
					if f.is_alive then

						f.set_pos (f.pos.f_r, f.pos.f_c + 1)

						if f.on_board then
							model_access.m.grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
							output02.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
						else
							output02.append("out of board" )
						end

					end

					model_access.m.print_state.set_friendly_projectile_section (output02)
					model_access.m.print_state.set_friendly_projectile_section (output2)

				end
	-----------------------------------------------------------------------------------------------------------------------------------------

	if attached model_access.m.friendly_proj_collection.at (list_key[temp + 2]) as f and then f.is_alive and then f.on_board and model_access.m.in_game then
		create output03.make_empty
		create output3.make_empty
		model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
		output03.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] +
																	"," + f.pos.f_c.out +"] -> ")

		retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r + 1, f.pos.f_c + 1)

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

								f.set_pos (f.pos.f_r + 1, f.pos.f_c + 1)
								if f.on_board then
									output03.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
								else
									output03.append("out of board.")
								end
							end
							output3.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
														") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] +"," + e_pro.pos.f_c.out + "], negating damage.")

						end

					elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
						if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
							--f_pro removed prom the board	
							f.set_damage (f.damage + f_pro.damage)
							f_pro.set_alive (false)
						    model_access.m.grid.put("_", f_pro.pos.f_r, f.pos.f_c)

							output3.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
												") at location [" + model_access.m.print_state.rows[f_pro.pos.f_r] +"," + f_pro.pos.f_c.out + "], combining damage.")

						end

					end
				elseif retrived_id > 0 and f.is_alive then
					if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
						e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
							f.set_alive (false)

							if not f.is_alive then

								f.set_pos (f.pos.f_r + 1, f.pos.f_c + 1)
								if f.on_board then
									output03.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
								else
									output03.append("out of board")
								end
							end
					    	output3.append ("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
    										model_access.m.print_state.rows[e.pos.e_r] +"," + e.pos.e_c.out + "], dealing " + (f.damage - e.armour).out + " damage." )
								if e.current_health <= 0 then
															e.set_alive (false)
															model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
															output3.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
														end
					end


				elseif retrived_id = 0 and f.is_alive then

                       	model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
					f.set_alive (false)

					if model_access.m.starfighter.current_health < 0 then
						-- game over
					end
					-- current health below 0 after collition starfigher distroyed
					if not f.is_alive then

								f.set_pos (f.pos.f_r + 1, f.pos.f_c + 1)
								if f.on_board then
									output03.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
								else
									output03.append("out of board" )
								end
					end
					output3.append("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
					    														 model_access.m.print_state.rows[f.pos.f_r] +"," + (f.pos.f_c).out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )

					if model_access.m.starfighter.current_health <= 0 then
												-- game over
														model_access.m.set_in_game (false)
														model_access.m.starfighter.set_pos (model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
														model_access.m.grid.put ("X", model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
														model_access.m.print_state.set_game_over
														output3.append ("%N      The "+ model_access.m.starfighter.name +" at location [" +model_access.m. print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
															model_access.m.starfighter.pos.s_c.out + "] has been destroyed.")
											end

				end
			if f.is_alive then
				model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
				f.set_pos (f.pos.f_r + 1, f.pos.f_c + 1)

				if f.on_board then
					model_access.m.grid.put (f.symbole, f.pos.f_r, f.pos.f_c)
					output03.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
				else
					output03.append("out of board" )
				end

			end

			model_access.m.print_state.set_friendly_projectile_section (output03)
			model_access.m.print_state.set_friendly_projectile_section (output3)

		end

	--------------------------------------------------------------------------------------------------------------------------------------		
				temp := temp + 3
			end
		end


end
