source_id = 115
target_id = 116

source_answer = getvalue(source_id)
target_titles = getquestionoptions(target_id,"Title")

function main()
	local target_index = 1
	for id, title in orderedPairs(target_titles) do
		if not(in_array(tostring(target_index),source_answer)) then
			hideoption(target_id,title,true)
		end
		if in_array('97',source_answer) and title:match("option value") then 
			hideoption(target_id,title,false)
		end
		target_index = target_index + 1
	end
end

function orderedPairs(t)

    function cmp_multitype(op1, op2)
        local type1, type2 = type(op1), type(op2)
        if type1 ~= type2 then --cmp by type
            return type1 < type2
        elseif type1 == "number" or type1 == "string" then --type2 is equal to type1
            return op1 < op2 --comp by default
        elseif type1 == "boolean" then
            return op1 == true
        else
            return tostring(op1) < tostring(op2) --cmp by address
        end
    end
    
    function __genOrderedIndex( t )
        local orderedIndex = {}
        for key in pairs(t) do
            table.insert( orderedIndex, key )
        end
        table.sort( orderedIndex, cmp_multitype )
        return orderedIndex
    end
    
    function orderedNext(t, state)
        local key = nil
        --print("orderedNext: state = "..tostring(state) )
        if state == nil then
            -- the first time, generate the index
            t.__orderedIndex = __genOrderedIndex( t )
            key = t.__orderedIndex[1]
        else
            -- fetch the next value
            for i = 1,#t.__orderedIndex do
                if t.__orderedIndex[i] == state then
                    key = t.__orderedIndex[i+1]
                end
            end
        end
    
        if key then
            return key, t[key]
        end
    
        -- no more value to return, cleanup
        t.__orderedIndex = nil
        return
    end
    return orderedNext, t, nil
end

main()