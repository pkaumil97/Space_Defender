note
	description: "Summary description for {OVERCHARGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OVERCHARGE

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
			create selected_option.make_from_string( "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.")
			create {LINKED_LIST[like current]}option_select.make


		end


	special
		do
				if model_access.m.starfighter.current_health <= 50 then
					model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:" + model_access.m.starfighter.id.out +") uses special, gaining "
																		+ ((model_access.m.starfighter.current_health - 1) * 2).out
																		+" energy at the expense of "+ (model_access.m.starfighter.current_health - 1).out+" health.")
					model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy  + ((model_access.m.starfighter.current_health - 1) * 2) )
					model_access.m.starfighter.set_current_health (1)
				else
					model_access.m.starfighter.set_current_health (model_access.m.starfighter.current_health - 50)
					model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy  + 100)
					model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:0) uses special, gaining 100 energy at the expense of 50 health.")
				end


		end
end
