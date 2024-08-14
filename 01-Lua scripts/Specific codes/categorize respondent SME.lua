SOURCE_ID = {
	[1] = 66, --q1
	[2] = 51, --q3
	[3] = 55  --q4
}

SOURCE_ANSWERS = {}
TARGET_ID = 56

for k,v in pairs(SOURCE_ID) do
	SOURCE_ANSWERS[k] = getvalue(v)
end

function categorizeRespondent(Q1, Q3, Q4)
	if (Q1 == 1 or Q4 == 1) then
		return 1
	elseif ( (Q3 == 11 and ( (Q1 == 2 or Q1 == 3) or (Q4 >= 2 and Q4 <= 6) )) or 
			 ((Q3 >= 1 and Q3 <= 16) and (Q1 == 2 or (Q4 >= 2 and Q4 <= 6))) ) then
		return 2
	elseif ( (Q3 == 11 and ( (Q1 >= 4 and Q1 <= 5) or (Q4 >= 7 and Q4 <= 10) )) or 
			 ((Q3 >= 1 and Q3 <= 16) and (Q1 == 3 or (Q4 >= 4 and Q4 <= 7))) ) then
		return 3
	else
		return 99 -- In case the provided answers don't match any category
	end
end

-- Getting the category for the respondent based on their answers
local category = categorizeRespondent(SOURCE_ANSWERS[1], SOURCE_ANSWERS[2], SOURCE_ANSWERS[3])

-- Assuming there's a function to set the value in your system, 
-- replace 'setvalue' with the actual function you use.
setvalue(TARGET_ID, category)