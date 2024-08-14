s = 66
sa = getvalue(s)
sr = getquestionoptions(s,"Reporting")
st = getquestionoptions(s,"Title")
sr_f = array_flip(sr)

flavor = {74,75}
ans = {}
for k,v in pairs(sa)do
  table.insert(ans,v)
end

function swap_value(t)
	if t[1] > t[2] then
    	t[1],t[2] = t[2],t[1]
  	end
  	return t
end

ans = swap_value(ans)

setvalue(flavor[1], st[sr_f[ tonumber(ans[1]) ] ])
setvalue(flavor[2], st[sr_f[ tonumber(ans[2]) ] ])
  
  