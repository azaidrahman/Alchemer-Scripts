s = 120
t = 132

sa = getvalue(s)
tbl = gettablequestiontitles(t)

for k,v in pairs(tbl)do
	if not(in_array('97',sa)) then
    	hideoption(k,'97',true)
  	end
end