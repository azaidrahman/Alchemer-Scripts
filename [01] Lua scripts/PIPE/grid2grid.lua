s = 221
t = 233
nextp = 81

sa = getvalue(s)
st = array_flip(gettablequestiontitles(s))
tt = array_flip(gettablequestiontitles(t))

hidden = 0
for k,v in pairs(tt)do
	satitle = sa[st[k]]

  	if count(satitle) > 0 then
		for a,b in pairs(satitle)do
			val = tonumber(b)
			--you can change the value here according to your need
			if val > 1 then
			  hidequestion(v,true)
        	  hidden = hidden + 1
      		end
		end
	else
		hidequestion(v,true)
    	hidden = hidden + 1
	end
end

if hidden == count(st) then jumptopage(nextp) end