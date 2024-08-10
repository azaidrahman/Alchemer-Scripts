a = 97
b = 197
c = 1297
  
function is_others_reporting_value(num)
	local val = tonumber(num)
  	if not(val) then return false end
  	
  	local val_string = tostring(num)
  	local rst = ""
  	if val_string:len() > 2 then
		rst = val_string:sub(val_string:len()-1)
	else
		rst = val_string
	end

	return tonumber(rst)
end

print(is_others_reporting_value(a))
print(is_others_reporting_value(b))
print(is_others_reporting_value(c))