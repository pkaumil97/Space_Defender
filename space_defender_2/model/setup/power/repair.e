note
	description: "Summary description for {REPAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPAIR
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
			create selected_option.make_from_string( "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.")
			create {LINKED_LIST[like current]}option_select.make



		end


	special
		do
			model_access.m.starfighter.set_current_energy (model_access.m.starfighter.current_energy - 50)
			model_access.m.starfighter.repairing_health (50)
			model_access.m.print_state.set_starfighter_action ( "%N    The Starfighter(id:" + model_access.m.starfighter.id.out +") uses special, gaining 50 health.")
		end

end
