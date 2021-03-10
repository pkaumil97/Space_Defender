note
	description: "Summary description for {ORBITAL_STRIKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORBITAL_STRIKE

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
			create selected_option.make_from_string( "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.")
			create {LINKED_LIST[like current]}option_select.make


		end
	special
		local
			output : STRING
			k :INTEGER
		do
			model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy - 100)
			model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:"+ model_access.m.starfighter.id.out +") uses special, unleashing a wave of energy.")
			create output.make_empty
			across
				model_access.m.enemy_collection is e
			loop

				k := 100 - e.armour
				e.set_current_health(e.current_health - (100 - e.armour))
				if e.current_health <= 0 then
					e.set_alive(false)
					model_access.m.grid.put ("_", e.pos.e_r, e.pos.e_c)
					output.append ("%N      The "+ e.name +" at location ["+model_access.m.print_state.rows[e.pos.e_r]+"," + e.pos.e_c.out +"] has been destroyed.")
				else
					output.append ("%N      A "+ e.name +"(id:"+e.id.out+") at location ["+model_access.m.print_state.rows[e.pos.e_r]+","+e.pos.e_c.out+"] takes "+ k.out+" damage.")
				end


			end
			model_access.m.print_state.set_starfighter_action(output)

		end
end
