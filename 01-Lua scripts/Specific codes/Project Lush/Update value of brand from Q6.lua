--PROJECT LUSH
--UPDATE VALUE OF BRAND IF SELECT NEVER IN Q6 

s = 865
t = 193

function main()
	sa = getvalue(s)
	st = gettablequestiontitles(s)
	to = getvaluelabel(t)
	new_sa = new_table(sa)
	new_to = {}
	
	i = 0
	for k,v in orderedPairs(to)do
		i = i+1
		new_to[i] = k
	end
	for k,tbl in ipairs(new_sa)do
		val = tonumber(solo_table(tbl))
		if val == 99 then
			to[new_to[k]]= nil
		end
	end
	
	new_to = array_flip(to)

	setvalue(t,new_to)
end

function new_table(arr)
	i = 0
	res = {}
	for k,v in orderedPairs(arr)do
		i = i + 1
		res[i] = v
  	end
	return res
end

function solo_table(arr)
	if count(arr) > 1 then return end
	for k,v in pairs(arr)do
		return v
	end
end

function multi_compare(c,...)
    rst = false
    ans = arg[1]
   
    if c == true then
        if ans >= arg[2] and ans <= arg[3] then
            -- print('ans:'..ans..' arg[2]:'..arg[2]..' arg[3]:'..arg[3])
            rst = true
        end
    else
        for i=2,(#arg+2) do
            if ans == arg[i] then
                -- print('ans:'..ans..' arg[2]:'..arg[2])
                rst = true
                break
            end
        end
    end

    -- if rst then print ('true') else print('false')end
    return rst
end

function cmp_multitype(op1, op2)
    type1, type2 = type(op1), type(op2)
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
    orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex, cmp_multitype )
    return orderedIndex
end

function orderedNext(t, state)
     key = nil
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

function orderedPairs(t)
    return orderedNext, t, nil
end

main()