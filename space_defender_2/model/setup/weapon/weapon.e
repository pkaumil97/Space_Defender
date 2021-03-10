note
	description: "Summary description for {WEAPON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


class
	WEAPON


inherit
	STATES


create
	make
feature
	make
		do
			create state_name.make_from_string ("weapon setup")
			create {LINKED_LIST[like current]}option_select.make
			create regen.default_create
			option_Select.force (create {STANDARD}.make)
			option_Select.force (create {SPREAD}.make)
			option_Select.force (create {SNIPE}.make)
			option_Select.force (create {ROCKET}.make)
			option_Select.force (create {SPLITTER}.make)
			select_cursor := 1
			create selected_option.make_from_string( "Standard")

		end

feature
	health, energy, armour,vision, move, move_cost, projectile_damage, projectile_cost : INTEGER
	regen: TUPLE[h_regen :like health ; e_regen : like energy]




feature
	set_select_cursor (i : INTEGER)
		do
			select_cursor := i
		end

	set_options
		local
			op : STRING

		do
			create op.make_empty

			  op.append ("  1:Standard (A single projectile is fired in front)%N")
			  op.append ("    Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,%N")
			  op.append ("    Projectile Damage:70, Projectile Cost:5 (energy)%N")
			  op.append ("  2:Spread (Three projectiles are fired in front, two going diagonal)%N")
			  op.append ("    Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,%N")
			  op.append ("    Projectile Damage:50, Projectile Cost:10 (energy)%N")
			  op.append ("  3:Snipe (Fast and high damage projectile, but only travels via teleporting)%N")
			  op.append ("    Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,%N")
			  op.append ("    Projectile Damage:1000, Projectile Cost:20 (energy)%N")
			  op.append ("  4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)%N")
			  op.append ("    Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,%N")
			  op.append ("    Projectile Damage:100, Projectile Cost:10 (health)%N")
			  op.append ("  5:Splitter (A single mine projectile is placed in front of the Starfighter)%N")
			  op.append ("    Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,%N")
			  op.append ("    Projectile Damage:150, Projectile Cost:70 (energy)%N")
			  op.append ("  Weapon Selected:" + option_select[select_cursor].selected_option)

			model_access.m.print_state.set_options_string (op)
		end



feature
	fire
	do
		option_select[select_cursor].fire
	end

	friendly_projectile_act
	do
		option_select[select_cursor].friendly_projectile_act
	end
end
