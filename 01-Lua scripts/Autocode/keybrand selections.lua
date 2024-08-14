s = 86
t = 99
is_key_brand = 207
hiddens = {101,102,103}
  
sa = getvalue(s)
st = getquestionoptions(s,"Title")
saf = array_flip(sa)

  
key_brands = {
  16,5,14,19,21,22
}

key_brand_selected = {}
nonkey_brand_selected = {}
key_brand_count = 0

for k,v in pairs(sa)do
	val = tonumber(v)
  	if in_array(val,key_brands)then
    	key_brand_count = key_brand_count + 1
    	table.insert(key_brand_selected,val)
	else
		table.insert(nonkey_brand_selected,val)
  	end
end

function choose_three (arr)
	if count(arr) > 3 then
		while count(arr) > 3 do
			arr[math.random(1,count(arr))] = nil
		end
	end
	return arr
end

if key_brand_count > 0 then
	ans = choose_three(key_brand_selected)
	setvalue(is_key_brand,'1')
else
	ans = choose_three(nonkey_brand_selected)
	setvalue(is_key_brand,'2')
end

setvalue(t,ans)

-- for i,v in pairs(ans)do
--   	local title = st[saf[v]]
--   	print(title)
-- 	setvalue(hiddens[i],title)
-- end