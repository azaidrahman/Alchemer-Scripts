COUNTRY = tonumber(getvalue(225))
--F100/G90 - 1
--F110/G100 - 2
s = {
  {279,323},
  {275,322}
}
t = {331,332}
sa = {}

TOP3_BRANDS = {
  {{44, 190, 73}, {44, 73, 224}, {44, 191, 183}},
  {{44, 190, 1055}, {44, 1055, 1311}, {44, 183, 1391}}
}


function remove_select(arr, val)
    for k, v in pairs(arr) do
        local num = tonumber(v)
        if num == val then table.remove(arr, k) end
    end
end

for i1, id_arr in ipairs(s) do
  for i2,id in ipairs(id_arr) do
    local selected = getvalue(id)
    if count(selected) > 0 then sa[i1][i2] = selected end
  end
end

ref = {73, 1055}

ref_truth_table = {[73] = false, [1055] = false}

for i1, level in pairs(sa) do
  for i2, 
  for k, v in pairs(selected_arr) do
        local select_num = tonumber(v)
        if in_array(select_num, ref) then ref_truth_table[select_num] = true end
    end
end

if ref_truth_table[1] and ref_truth_table[2] then
  remove_selected(sa[1],ref[1])
  remove_selected(sa[2],ref[2])
  table.insert()
end

