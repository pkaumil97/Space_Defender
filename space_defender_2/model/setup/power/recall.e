note
	description: "Summary description for {RECALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECALL


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
			create selected_option.make_from_string( "Recall (50 energy): Teleport back to spawn.")
			create {LINKED_LIST[like current]}option_select.make


		end

	special
		do
			model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy - 50)
			model_access.m.grid.put ("_", model_access.m.starfighter.pos.s_r,model_access.m. starfighter.pos.s_c)
			-- check collition
			model_access.m.starfighter.set_pos ((model_access.m.grid.height/2).ceiling_real_64.truncated_to_integer,1)
			model_access.m.grid.put (model_access.m.starfighter.symbole, model_access.m.starfighter.pos.s_r, model_access.m.starfighter.pos.s_c)
			model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:" + model_access.m.starfighter.id.out +") uses special, teleporting to: [" +
													model_access.m.print_state.rows[model_access.m.starfighter.pos.s_r] + "," + model_access.m.starfighter.pos.s_c.out + "]")
		end
end
