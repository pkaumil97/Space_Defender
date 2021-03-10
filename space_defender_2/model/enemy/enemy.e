note
	description: "Summary description for {ENEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMY
feature
	model_access : ETF_MODEL_ACCESS
	pos: TUPLE[e_r: INTEGER; e_c: INTEGER]
	current_health: INTEGER
	total_health: INTEGER
	regen: INTEGER
	armour: INTEGER
	vision: INTEGER
	seen_by_starfighter: BOOLEAN
	can_see_starfighter: BOOLEAN
	id: INTEGER
	symbole: STRING
	name: STRING
	is_alive: BOOLEAN
	on_board: BOOLEAN
	end_turn: BOOLEAN

feature
	set_pos(row: INTEGER; column: INTEGER) deferred end
	set_seen_by_starfighter deferred end
	set_can_see_starfighter deferred end
	preemptive_action deferred end
	set_current_health (curr_health : INTEGER) deferred end
	set_total_health (tot_health : INTEGER) deferred end
	set_on_board deferred end
	set_alive (alive: BOOLEAN) deferred end
	set_end_turn (ending_turn : BOOLEAN) deferred end
	action deferred end
	health_regen deferred end
	

end
