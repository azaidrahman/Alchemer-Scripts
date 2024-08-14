s = 109
t = 166

sa = getvalue(s)
st = gettablequestiontitles(s)


function main()
	
    first = nil
  
    for k,v in orderedPairs(st)do
        if not(first) then
            first = tonumber(k)
      	else
      		break
        end
    end
    
  	local passed = {}
  	for k,tbl in orderedPairs(sa)do
    	local v = tbl[next(tbl)]
   		local order = tonumber(k)-first+1
    	if tonumber(v) >= 9 then
      		table.insert(passed,order)
    	end
  	end
  
  	print(passed)
  	setvalue(t,passed)
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