note
	description: "Summary description for {SNIPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SNIPE

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
			create selected_option.make_from_string( "Snipe")
			create {LINKED_LIST[like current]}option_select.make
			health := 0
		    energy := 100
		    armour := 0
		    vision := 10
		    move := 3
		    move_cost := 0
		    projectile_damage := 1000
		    projectile_cost := 20
			create regen.default_create
			regen := [0, 5]

		end

	fire
		local
			p: FRIENDLY_PROJECTILE
			retrived_id : INTEGER
		do
		create p.make (model_access.m.projectileid_counter)
		p.set_pos(model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c + 1)

		p.set_move_per_turn (8)
		p.set_damage (projectile_damage)
			model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:" + model_access.m.starfighter.id.out + ") fires at location [" +
																model_access.m.print_state.rows[model_access.m.starfighter.pos.s_r] + "," +
																model_access.m.starfighter.pos.s_c.out +"]." + "%N      " +
      																"A friendly projectile(id:" + p.id.out + ") spawns at location " +
      																if p.on_board then
      																"[" + model_access.m.print_state.rows[p.pos.f_r]+ "," + p.pos.f_c.out+ "]."
      															else
      																"out of board."
      															end

																)

			retrived_id := model_access.m.retrive_id_by_pos (p.pos.f_r, p.pos.f_c)
							if retrived_id < 0 and p.is_alive then
								------
								if model_access.m.is_id_of_enemy_proj (retrived_id)  and p.is_alive then
									if attached model_access.m.enemy_proj_collection.at (retrived_id) as e_pro and then e_pro.is_alive and then e_pro.on_board  then
											if (e_pro.damage > p.damage) then
												e_pro.set_damage (e_pro.damage - p.damage)
												p.set_alive (false)
											elseif (e_pro.damage < p.damage) then
												p.set_damage (p.damage - e_pro.damage)
												e_pro.set_alive(false)
												model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
											elseif (e_pro.damage = p.damage) then
												p.set_alive (false)
												e_pro.set_alive(false)
												model_access.m.grid.put("_", e_pro.pos.f_r, e_pro.pos.f_c)
											end

											model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
																						") at location [" + model_access.m.print_state.rows[p.pos.f_r] +"," + p.pos.f_c.out + "], negating damage.")
									end

								elseif model_access.m.is_id_of_friendly_proj (retrived_id) and p.is_alive then
										if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board then
											 p.set_damage (p.damage + f_pro.damage)
											 f_pro.set_alive (false)
											 model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																						") at location [" + model_access.m.print_state.rows[p.pos.f_r] +"," + p.pos.f_c.out + "], combining damage.")
										end

								end
								-------
							elseif retrived_id > 0 and p.is_alive then
								if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then

											e.set_current_health (e.current_health - model_access.m.max (p.damage - e.armour, 0))
											p.set_alive (false)


									    	model_access.m.print_state.set_starfighter_action ("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
									    																 model_access.m.print_state.rows[p.pos.f_r] +"," + p.pos.f_c.out + "], dealing " + (p.damage - e.armour).out + " damage." )

											if e.current_health <= 0 then
											e.set_alive (false)
											model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
											model_access.m.print_state.set_starfighter_action ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
											end
								end
							end

							if  p.is_alive and p.on_board then
								model_access.m.grid.put (p.symbole, p.pos.f_r, p.pos.f_c)
							end


		model_access.m.friendly_proj_collection.put (p, p.id)
		model_access.m.update_projectileid


		end

	friendly_projectile_act
		local
			retrived_id : INTEGER
			temp : INTEGER
			output0 : STRING
			output : STRING
		do
			from
				temp := -1
			until
				temp = model_access.m.projectileid_counter - 1
			loop


					if attached model_access.m.friendly_proj_collection.at (temp) as f and then f.is_alive and then f.on_board and model_access.m.in_game then
						create output0.make_empty
						create output.make_empty
						model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
						output0.append("%N    A friendly projectile(id:" + f.id.out + ") moves: [" + model_access.m.print_state.rows[f.pos.f_r] +
																					"," + f.pos.f_c.out +"] -> ")

						retrived_id := model_access.m.retrive_id_by_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)

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

												f.set_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)
												if f.on_board then
													output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
												else
													output.append("out of board.")
												end
											end
											output.append("%N      The projectile collides with enemy projectile(id:"+ e_pro.id.out+
															") at location [" + model_access.m.print_state.rows[e_pro.pos.f_r] +"," + e_pro.pos.f_c.out + "], negating damage.")

										end

									elseif model_access.m.is_id_of_friendly_proj (retrived_id) and f.is_alive then
										if attached model_access.m.friendly_proj_collection.at (retrived_id) as f_pro and then f_pro.is_alive and then f_pro.on_board  then
											--f_pro removed prom the board	
											f.set_damage (f.damage + f_pro.damage)
											f_pro.set_alive (false)
											model_access.m.grid.put("_", f_pro.pos.f_r, f.pos.f_c)
											output.append("%N      The projectile collides with friendly projectile(id:"+ f_pro.id.out+
																										") at location [" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "], combining damage.")

										end

									end
								elseif retrived_id > 0 and f.is_alive then
									if attached model_access.m.enemy_collection.at (retrived_id) as e and then e.is_alive and then e.on_board then
										e.set_current_health (e.current_health - model_access.m.max (f.damage - e.armour, 0))
											f.set_alive (false)
											f.set_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)
											output.append("%N      The projectile collides with "+ e.name + "(id:" + e.id.out+ ") at location [" +
																			    				model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "], dealing " + (f.damage - e.armour).out + " damage." )
											if e.current_health <= 0 then
												e.set_alive (false)
												model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
												output.append ("%N      The "+ e.name+" at location ["+ model_access.m.print_state.rows[e.pos.e_r] + "," + e.pos.e_c.out +"] has been destroyed.")
											end
											if not f.is_alive then


												if f.on_board then
													output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
												else
													output0.append("out of board")
												end
											end
									     -- enemy <= 0 distroyed

									end


								elseif retrived_id = 0 and f.is_alive then

			                       	model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - model_access.m.max (f.damage - model_access.m.starfighter.total_armour, 0))
									f.set_alive (false)

									-- current health below 0 after collition starfigher distroyed
									if not f.is_alive then
												model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
												f.set_pos (f.pos.f_r , f.pos.f_c + f.move_per_turn)
												if f.on_board then
													output0.append("[" + model_access.m.print_state.rows[f.pos.f_r] +"," + f.pos.f_c.out + "]" )
												else
													output0.append("out of board" )
												end
									end
									output.append("%N      The projectile collides with "+ model_access.m.starfighter.name + "(id:" + model_access.m.starfighter.id.out + ") at location [" +
									    		model_access.m.print_state.rows[f.pos.f_r - 1] +"," + (f.pos.f_c + 1).out + "], dealing " + (f.damage - model_access.m.starfighter.total_armour).out + " damage." )

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
							if f.is_alive then
								model_access.m.grid.put ("_", f.pos.f_r, f.pos.f_c)
								f.set_pos (f.pos.f_r, f.pos.f_c + f.move_per_turn)

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



				temp := temp - 1
			end
		end

end
