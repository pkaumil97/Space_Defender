note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER

create
	make

feature
	model_access : ETF_MODEL_ACCESS
feature
	make
		do
			create projectile_pattern.make_empty
			create power.make_empty
			id := 0
			create symbole.make_from_string("S")
			create pos.default_create
			create name.make_from_string("Starfighter")

		end
feature
	score: INTEGER
--	weapon_health, armour_health, engine_health,
	total_health : INTEGER
	current_health : INTEGER
--	weapon_energy, armour_energy, engine_energy,
	total_energy : INTEGER
	current_energy : INTEGER
--	weapon_h_regen, armour_h_regen, engine_h_regen,
    total_h_regen : INTEGER
--	weapon_e_regen, armour_e_regen, engine_e_regen,
    total_e_regen : INTEGER
--	weapon_armour, armour_armour, engine_armour,
    total_armour : INTEGER
--	weapon_vision, armour_vision, engine_vision,
	total_vision : INTEGER
--	weapon_move, armour_move, engine_move, 	
    total_move : INTEGER
--	weapon_move_cost, armour_move_cost, engine_move_cost,
	total_move_cost : INTEGER

	projectile_pattern: STRING
	projectile_damage: INTEGER
	projectile_cost: INTEGER
	power: STRING
	id: INTEGER
	symbole: STRING
	cost_on_health : BOOLEAN
	pos: TUPLE[s_r: INTEGER; s_c: INTEGER]
	name: STRING


feature
	set_final_attribute

		do
--		across model_access.m.states is st
--		loop
--			check attached {WEAPON} st as state then end
--		end
			check attached {WEAPON} model_access.m.states[1] as w then total_health := total_health + w.option_select[w.select_cursor].health end
			check attached {ARMOUR} model_access.m.states[2] as a then total_health := total_health + a.option_select[a.select_cursor].health end
			check attached {ENGINE} model_access.m.states[3] as e then total_health := total_health + e.option_select[e.select_cursor].health end

			check attached {WEAPON} model_access.m.states[1] as w then total_energy := total_energy + w.option_select[w.select_cursor].energy end
			check attached {ARMOUR} model_access.m.states[2] as a then total_energy := total_energy + a.option_select[a.select_cursor].energy end
			check attached {ENGINE} model_access.m.states[3] as e then total_energy := total_energy + e.option_select[e.select_cursor].energy end


			check attached {WEAPON} model_access.m.states[1] as w then total_h_regen := total_h_regen + w.option_select[w.select_cursor].regen.h_regen end
			check attached {ARMOUR} model_access.m.states[2] as a then total_h_regen := total_h_regen + a.option_select[a.select_cursor].regen.h_regen end
			check attached {ENGINE} model_access.m.states[3] as e then total_h_regen := total_h_regen + e.option_select[e.select_cursor].regen.h_regen end

			check attached {WEAPON} model_access.m.states[1] as w then total_e_regen := total_e_regen + w.option_select[w.select_cursor].regen.e_regen end
			check attached {ARMOUR} model_access.m.states[2] as a then total_e_regen := total_e_regen + a.option_select[a.select_cursor].regen.e_regen end
			check attached {ENGINE} model_access.m.states[3] as e then total_e_regen := total_e_regen + e.option_select[e.select_cursor].regen.e_regen end


			check attached {WEAPON} model_access.m.states[1] as w then total_armour := total_armour + w.option_select[w.select_cursor].armour end
			check attached {ARMOUR} model_access.m.states[2] as a then total_armour := total_armour + a.option_select[a.select_cursor].armour end
			check attached {ENGINE} model_access.m.states[3] as e then total_armour := total_armour + e.option_select[e.select_cursor].armour end

			check attached {WEAPON} model_access.m.states[1] as w then total_vision := total_vision + w.option_select[w.select_cursor].vision end
			check attached {ARMOUR} model_access.m.states[2] as a then total_vision := total_vision + a.option_select[a.select_cursor].vision end
			check attached {ENGINE} model_access.m.states[3] as e then total_vision := total_vision + e.option_select[e.select_cursor].vision end

			check attached {WEAPON} model_access.m.states[1] as w then total_move := total_move + w.option_select[w.select_cursor].move end
			check attached {ARMOUR} model_access.m.states[2] as a then total_move := total_move + a.option_select[a.select_cursor].move end
			check attached {ENGINE} model_access.m.states[3] as e then total_move := total_move + e.option_select[e.select_cursor].move end

			check attached {WEAPON} model_access.m.states[1] as w then total_move_cost := total_move_cost + w.option_select[w.select_cursor].move_cost end
			check attached {ARMOUR} model_access.m.states[2] as a then total_move_cost := total_move_cost + a.option_select[a.select_cursor].move_cost end
			check attached {ENGINE} model_access.m.states[3] as e then total_move_cost := total_move_cost + e.option_select[e.select_cursor].move_cost end

			check attached {WEAPON} model_access.m.states[1] as w then projectile_pattern := w.option_select[w.select_cursor].selected_option end
			check attached {WEAPON} model_access.m.states[1] as w then projectile_damage := w.option_select[w.select_cursor].projectile_damage end
			check attached {WEAPON} model_access.m.states[1] as w then
								projectile_cost := w.option_select[w.select_cursor].projectile_cost
								if w.select_cursor = 4 then
									 cost_on_health :=  true
								end

			end

			check attached {POWER} model_access.m.states[4] as p then power := p.option_select[p.select_cursor].selected_option end

			current_health := total_health
			current_energy := total_energy
		end

	show
		local
			str: STRING
		do
			create str.make_empty
			str.append ("  Starfighter:%N")
			str.append ("    ")
			str.append ("[" + id.out + "," + symbole + "]")
			str.append ("->")
			str.append ("health:" + current_health.out + "/" + total_health.out + ", ")
			str.append ("energy:" + current_energy.out + "/" + total_energy.out + ", ")
			str.append ("Regen:" + total_h_regen.out + "/" + total_e_regen.out + ", ")
			str.append ("Armour:" + total_armour.out + ", ")
			str.append ("Vision:" + total_vision.out + ", ")
			str.append ("Move:" + total_move.out + ", ")
			str.append ("Move Cost:" + total_move_cost.out + ", ")
			str.append ("location:[" + model_access.m.print_state.rows[pos.s_r] + "," + pos.s_c.out + "]" )
			str.append ("%N")
			str.append ("      ")
			str.append ("Projectile Pattern:" + projectile_pattern + ", ")
			str.append ("Projectile Damage:" + projectile_damage.out + ", ")
			str.append ("Projectile Cost:" + projectile_cost.out)
				if cost_on_health then
					str.append (" (health)")
				else
					str.append (" (energy)")
				end
			str.append ("%N")
			str.append ("      ")
			str.append ("Power:" + power)
			str.append ("%N")
			str.append ("      ")
			str.append ("score:" + model_access.m.score.get_score.out)
			model_access.m.print_state.set_starfighter_section (str)

		end

	set_pos( row: INTEGER; column:INTEGER)
		do
			pos.s_r := row
			pos.s_c := column

		end

	can_seen_by_s (row: INTEGER; column: INTEGER): BOOLEAN
		local
			r,c :INTEGER
		do
			r := row - pos.s_r
			c := column - pos.s_c
			Result := (r.abs + c.abs) <= total_vision
		end

	health_regen
		do
			if current_health < total_health then
				current_health := current_health + total_h_regen
				if current_health > total_health then
					current_health := total_health
				end
			end
		end

	energy_regen
		do
			if current_energy < total_energy then
				current_energy := current_energy + total_e_regen
				if current_energy > total_energy then
					current_energy := total_energy
				end
			end
		end
	substract_energycost (no_of_moves : INTEGER)
		do
			current_energy := current_energy - (total_move_cost * no_of_moves)
		end

	substract_cost_of_firing
		do


--				check attached {WEAPON} model_access.m.states[1] as w then
--					if w.select_cursor = 4 then
--						current_health := current_health - w.option_select[w.select_cursor].projectile_cost
--					else
--						current_energy := current_energy - w.option_select[w.select_cursor].projectile_cost
--					end

--				end
				if cost_on_health = true then
					current_health := current_health - projectile_cost
				else
					current_energy := current_energy - projectile_cost
				end

		end

	repairing_health(repair_health : INTEGER)
		do
			current_health := current_health + repair_health
		end

	set_current_energy (curr_energy: INTEGER)
		do
			current_energy := curr_energy
		end

	set_current_health (curr_health : INTEGER)
		do

			current_health := curr_health

			if
				current_health <= 0
			then
				current_health := 0
			end
		end
	set_total_health (tot_health : INTEGER)
		do
			total_health := tot_health
		end
end
