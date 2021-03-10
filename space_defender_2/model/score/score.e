note
	description: "Summary description for {SCORE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCORE


create
	make

feature
	make
		do
			create arr_of_orbments.make_empty
		end

feature -- attributes

	score: INTEGER
	arr_of_orbments: ARRAY[ORBMENT]

feature -- commands

	add(orbment : ORBMENT)
	do
			if arr_of_orbments.is_empty then
				arr_of_orbments.force (orbment, arr_of_orbments.count + 1)

			elseif attached {FOCUS} arr_of_orbments[arr_of_orbments.count] as f_obj and then not(f_obj.is_full)  then -- and then f_obj not full

 				f_obj.add (orbment)
 			else

				arr_of_orbments.force (orbment, arr_of_orbments.count + 1)
			end
	end

	get_score : INTEGER
	do
		across
			arr_of_orbments is o
		loop
			if attached o as o_d then
				result := result + o_d.get_score
			end
		end
	end



end
