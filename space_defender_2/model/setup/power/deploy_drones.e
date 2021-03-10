note
	description: "Summary description for {DEPLOY_DRONES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEPLOY_DRONES

inherit
	POWER
	redefine
		make, special
	end
create
	make

feature
	make
		do
			create state_name.make_from_string ("power setup")
			create selected_option.make_from_string( "Deploy Drones (100 energy): Clear all projectiles.")
			create {LINKED_LIST[like current]}option_select.make


		end
	special
		local
			k : INTEGER
			output : STRING
		do
			model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy - 100)
			model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:"+model_access.m.starfighter.id.out+") uses special, clearing projectiles with drones.")
			create output.make_empty
			from
				k := -1
			until
				k = model_access.m.projectileid_counter
			loop


				if model_access.m.is_id_of_friendly_proj (k) then
					if attached model_access.m.friendly_proj_collection.at (k) as f_pro and then f_pro.is_alive and then f_pro.on_board then
						f_pro.set_alive(false)
						model_access.m.grid.put ("_", f_pro.pos.f_r, f_pro.pos.f_c)
						output.append ("%N      A projectile(id:"+k.out+") at location ["+ model_access.m.print_state.rows[f_pro.pos.f_r]+","+f_pro.pos.f_c.out+"] has been neutralized.")
					end

				elseif model_access.m.is_id_of_enemy_proj (k) then
					if attached model_access.m.enemy_proj_collection.at (k) as e_pro and then e_pro.is_alive and then e_pro.on_board then
					e_pro.set_alive(false)
					model_access.m.grid.put ("_", e_pro.pos.f_r, e_pro.pos.f_c)
					output.append ("%N      A projectile(id:"+k.out+") at location ["+ model_access.m.print_state.rows[e_pro.pos.f_r]+","+e_pro.pos.f_c.out+"] has been neutralized.")
					end

				end
				k := k - 1
			end
			model_access.m.print_state.set_starfighter_action(output)
		end
end
