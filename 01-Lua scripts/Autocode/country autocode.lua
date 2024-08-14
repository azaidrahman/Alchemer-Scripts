code = '[url("country")]'
t = 71
country_text = evaluatemergecodes(code)
test = true

country_tbl = {
  ['VT']=1,['ID']=2
}

country_id = country_tbl[country_text]

if country_id then
	setvalue(t,country_id)
else
  	if test then hidequestion(t,false) return end
  	setvalue(t,99)
end