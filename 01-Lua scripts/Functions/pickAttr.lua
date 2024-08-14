s = {141,168,169}
st = {}
sr = {}
sa = {}
copy_sa = {}
t = {170,171,172}

function main()
	for i,qid in ipairs(s)do
		s_title = getquestionoptions(qid,"Title")
		s_rep = array_flip(getquestionoptions(qid,"Reporting"))
		table.insert(st,s_title)
		table.insert(sr,s_rep)
		
		ans = getvalue(qid)
		str_ans = tonumber(ans)
		table.insert(sa,s_title[s_rep[str_ans]])
	end
	
	for k,v in pairs(t)do
		pickAttr()
	end
end

function pickAttr()
    local i
    -- make a copy of the original table if we ran out of phrases
    if #copy_sa == 0 then
        for k,v in pairs(sa) do
            copy_sa[k] = v
        end
    end

    -- pick a random element from the copy  
    i = math.random(#copy_sa)
    phrase = copy_sa[i] 

    -- remove phrase from copy
    table.remove(copy_sa, i)

    return phrase
end

main()