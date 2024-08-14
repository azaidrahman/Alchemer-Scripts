s = 120
t = 139
  
sa = getvalue(s)
to = getquestionoptions(t,"Reporting")
tt = getquestionoptions(t,"Title")
to_f = array_flip(to)
allowed = {}

flavor = {141,142}

for k,v in pairs(to) do
	if not(in_array(v,sa)) and v ~= '99' then
  		table.insert(allowed,v)
  	end
end
  
ans = {}
flavors = {}

if count(allowed) > 1 then
  for i=1,2 do
      local min = nil
      local idx = math.random( count(allowed) )
      local val = allowed[idx]
      local num = tonumber(val)
      table.insert(ans, val)
      table.remove(allowed,idx) 
  end
else
  f1 = tt[to_f[ ans[next(ans)] ]]
end

function swap_value(t)
	if t[1] > t[2] then
    	t[1],t[2] = t[2],t[1]
  	end
  	return t
end
ans = swap_value(ans)

setvalue(flavor[1], tt[to_f[ tonumber(ans[1]) ] ])
setvalue(flavor[2], tt[to_f[ tonumber(ans[2]) ] ])

setvalue(t,ans)

  
  