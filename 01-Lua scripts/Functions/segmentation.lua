s = 66
t = 57
  
sa = getvalue(s)

ref = {
  0,0,0
}

print(ref)

for _, tbl in pairs(sa) do
	local ans = tonumber(tbl[next(tbl)])
  	ref[ans] = ref[ans] + 1
end

if ref[1] == 5 then
	setvalue(t,1)
else
  	setvalue(t,2)
end