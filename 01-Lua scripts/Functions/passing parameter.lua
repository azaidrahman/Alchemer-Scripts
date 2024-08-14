webhook_id = 7
webhook = getvalue(webhook_id)
nextp = 39

a= string.find(webhook,"{")
b = string.len(webhook)

bar = webhook:sub(a,b)

t = {["like"]=2,["coffee"]=3}


decoded = json_decode(bar)

for k,v in pairs(decoded["data"])do
	if t[k] then
  		val = tonumber(v)
    	setvalue(t[k],tostring(v))
	end
end

-- jumptopage(nextp)
