note
	description: "Summary description for {STATES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STATES

feature
	model_access : ETF_MODEL_ACCESS
	state_name: STRING
	option_select : LIST[like current]
	select_cursor : INTEGER
	selected_option : STRING



feature
	set_options
	deferred
	end

	set_select_cursor (i : INTEGER)
	deferred
	end


end
