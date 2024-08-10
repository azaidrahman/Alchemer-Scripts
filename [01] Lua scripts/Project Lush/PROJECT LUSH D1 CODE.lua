jsonID = 2423
json = json_decode(getvalue(jsonID))

d1 = 82

placeholder = {{2425,2427},{2433,2435},{2436,2437}}

if json == nil then jumptopage(d1) end

--sec1_1_encode[data_i] = num_val
json_i = 1
for data_i,num_val in orderedPairs(json)do
	setvalue(placeholder[json_i][1],num_val)
	setvalue(placeholder[json_i][2],data_i)
	json_i = json_i + 1
end


