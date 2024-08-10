sourceID = 78

source_answer = getvalue(sourceID)

categories = {
[3]={1,8},
[2]={9,21},
[16]={22},
[17]={22},
[10]={23,28},
[11]={29,34},
[12]={35,36},
[13]={37,40},
[14]={41,50},
[15]={51,58},
[4]={59,79},
[5]={80,96},
[6]={97,117},
[7]={118,134},
[8]={135,139},
[9]={140,159}
}

datas = {193,194,195,196,850,851}

encoderID = 2423
sec1_1_values = {6,7,8,9,13}
sec1_1_encode = {}

function main()
	
	data_i = 1
	-- print(source_answer)
	for key,source_value in orderedPairs(source_answer) do
		num_val = tonumber(source_value)
		set_answer = {}
		tbl_answer = categories[num_val]
		
		--SECTION1.1 init
		if in_array(num_val,sec1_1_values) then
			sec1_1_encode[num_val] = data_i
		end
		
		
		if count(tbl_answer) == 2 then
			tbl_min,tbl_max = tbl_answer[1],tbl_answer[2]
			for i=tbl_min,tbl_max do
				table.insert(set_answer,i)
			end
			-- print(set_answer)
			setvalue(datas[data_i],set_answer)
		else
			setvalue(datas[data_i],{22})
		end
		data_i = data_i + 1
	end
	
	setvalue(encoderID,json_encode(sec1_1_encode))
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