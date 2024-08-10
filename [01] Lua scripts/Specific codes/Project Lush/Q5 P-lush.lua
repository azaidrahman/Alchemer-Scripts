s = 821
  
sa = getvalue(s)
st = gettablequestiontitles(s)

occasions = {"Before Breakfast",
"Breakfast at Home",
"Breakfast (on-the-go/ at school)",
"Mid morning","Lunch","Mid Afternoon",
"Before Afternoon nap",
"After afternoon nap",
"Dinner","Before Sleep",
"Family/ friends gathering",
"While playing games",
"Before class","During class",
"After class","Recess/ break",
"While watching dramas/ movies/ videos"
}
function main()
	ite = 0
	ans = {}
	for key,arr in orderedPairs(sa)do
		ite = ite + 1
		category = st[key]
		for id, reportingVal in pairs(arr)do
			reportingVal = tonumber(reportingVal)
			combine = category .. ' - ' .. occasions[reportingVal]
			table.insert(ans,combine)
		end
	end
	
	print(ans)
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