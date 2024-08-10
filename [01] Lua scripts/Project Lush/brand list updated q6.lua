--PROJECT LUSH Update brand list - skip Q7-Q9 - milk type init

s = 865 -- Q6
t = 193 -- C+B DATA
js_skip = 1033 --javascript skip 

pageID = 94 --final data group
gate = 96  --Q10
skip = {59,96}
skip_bool = false

upcomingpage = 71 --Q8
plantval = {51,58}
plant_bool = false
plantgate = 163
nextp_updater = 2551
plantqid = 2621

function main()
	sa = getvalue(s)
	st = gettablequestiontitles(s)
	to = getvaluelabel(t)

	--Objective is to filter out the options that are more than 3 months ago (val: >3) and update the DATA
  
  	--make it into a new table that lists all the values, instead of nested arrays
	new_sa = new_table(sa)
	new_to = {}
	
  	--TODO make a hidden check if its all hidden just go to next category
  	--calls the label values of the brand DATA and makes new array of new_to: [order] = val
	i = 0
  	hidden = 0
	for k,v in orderedPairs(to)do
		i = i+1
		new_to[i] = k
	end
  
  	--check if any of the values from the new table, is more than 3 than remove them
	for k,tbl in ipairs(new_sa)do
		local val = tonumber(solo_table(tbl))
		if val > 3 then
			to[new_to[k]]= nil
      		hidden = hidden + 1
		end
	end
	
	--update to new_to: [title] = val; so that it can update its setvalue
	new_to = array_flip(to)
  
	--check if it should skip Q7-Q9
  	for k,v in pairs(new_to)do
    	local val = tonumber(v)
    	if val >= skip[1] and val <= skip[2] then
      		skip_bool = true
			break
      	elseif val >= plantval[1] and val <= plantval[2] then
      		plant_bool = true
      		break
    	end
  	end
  
  	setvalue(t,new_to)

  	--if its supposed to skip q7-q9 then set final data group to the current answers so that it comes out in q10-q11
  	if skip_bool then 
		pagemap = pagemap()
		pages = pagemap[pageID]
		
		overall_i = 1
		for newtitle,newval in pairs(new_to)do
			page_i = 1
			for currid,pagetype in orderedPairs(pages)do
				if page_i == overall_i then 
					setvalue(currid,newtitle)
					break
				else
					page_i = page_i + 1
				end
			end
			overall_i = overall_i + 1
		end
		jumptopage(gate)
    elseif plant_bool then
    	--set the milk type DATA question ID with the current target so that it can put it in the corresponding rows
		setvalue(plantqid,t)
		--set the upcoming page hidden value so its dynamic regardless of category position
    	setvalue(nextp_updater,upcomingpage)
    	jumptopage(plantgate)
		
  	else
		hidequestion(js_skip,false)
	end

  
  	
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