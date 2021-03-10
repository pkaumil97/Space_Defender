note
	description: "Summary description for {DIAMOND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIAMOND

inherit
	FOCUS

create
	make

feature-- Initialization

	make

			-- Initialization for `Current'.
		do
			create array.make_empty
			max_size := 4
			array.force(create {GOLD}.make, 1)
--			array.force(void, 1)
--			array.force(void, 1)
--			array.force(void, 1)

		end

feature	-- attributes
	max_size: INTEGER


feature -- queries


	is_full: BOOLEAN
	do
		if array.count < 4 then
			result := false
		elseif array.count = 4 and not (attached {FOCUS} array[4]) then
			result := true
		else
			if attached{FOCUS} array[4] as f_obj then
				result := f_obj.is_full
			end
		end
	end

	add(orbment : ORBMENT)
	do
		if not attached {FOCUS} array[array.count] then
			array.force (orbment, array.count + 1)
		elseif attached {FOCUS} array[array.count] as f_obj and then not(f_obj.is_full) then
			f_obj.add (orbment)
		else
			array.force (orbment, array.count + 1)

		end
	end

	get_score : INTEGER
	do
		across
			array is o
		loop
			if attached o as o_d then
				result := result + o_d.get_score
			end

		end
		if array.count = 4 then
			result := result*3
		end
	end



end
