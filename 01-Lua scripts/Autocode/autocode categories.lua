s = 78
t = 89

sa = getvalue(s)
cat_tbl = {
    {1},
    {2},
    {3,4},
    {5,6,7}
}

rst = {}

for k,v in pairs(sa) do
    for i, cats in pairs(cat_tbl) do
        if in_array(v,cats) then
            table.insert(rst,i)
        end
    end
end

setvalue(t,rst)