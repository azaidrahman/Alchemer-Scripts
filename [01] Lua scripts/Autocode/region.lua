s = 56
t = 57
  
sa = tostring(getvalue(s))

ref = [[
1,2,3,4
5,6,8
7,9,10
11,12,13
14,15
]]

ref_array = explode("\n",ref)


for i = 0, #ref_array do
  	tbl = ref_array[i]
  	nums = explode(",",tbl)
  
	if in_array(sa,nums) then
    	setvalue(t,i+1) --need to add 1 because explode starts index from 0
  	end
end