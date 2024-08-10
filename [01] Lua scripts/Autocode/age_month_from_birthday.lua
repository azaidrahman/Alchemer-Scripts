s = 86  -- Text field Question ID
nextp = 29 -- Page ID to jump to if qualified to continue in survey
t = 117

birthdate = getvalue(s)

--print(birthdate)

--if not(birthdate) then setvalue(t,'99') jumptopage(3) return end

birthdate_unix = strtotime(birthdate) 

today = date("Y-m-d h:i:s A")
today_unix = strtotime(today) + 12*60*60

day1 = tonumber(date("d",birthdate_unix))
day2 = tonumber(date("d",today_unix))

diff = (date('Y',today_unix) - date('Y',birthdate_unix))*12 + (date('m',today_unix) - date('m', birthdate_unix))

--if today is 8th and birthday is 4th, then its a new month

if day2 < day1 then diff = diff - 1 end

months = tonumber(diff)

txt = [[
1 4
5 8
9 12
13 16
17 20
21 24
25 28
29 32
]]

ans = {}

idx = 2

for line in txt:gmatch("(.-)\n")do
	l = nil
  	r = nil
  	for token in line:gmatch("[^%s]+")do
    	if l == nil then
      		l = tonumber(token)
      	elseif r == nil then
      		r = tonumber(token)
    	end
  	end
  	ans[idx] = {l,r}
  	idx = idx + 1
end

print"--"

if months < 1 then
	setvalue(t,'1')
elseif months > 32 then
  	setvalue(t,'10')
else
	for k,tbl in pairs(ans)do
    	if months >= tbl[1] and months <= tbl[2] then
      		setvalue(t,tostring(k))
    	end
  	end
end
--jumptopage(nextp)