s = 68
t = 80

sa = getvalue(s)
to = getquestionoptions(t,"Reporting")

function hide_first_digit(val,comparison)
	local num = math.floor(tonumber(val)/100)
	if val == '97' or val == '99' then return false end
	if num ~= tonumber(comparison) then return true end
end

for k,v in pairs(to)do
	hideoption(t,v,hide_first_digit(v,sa))
end
