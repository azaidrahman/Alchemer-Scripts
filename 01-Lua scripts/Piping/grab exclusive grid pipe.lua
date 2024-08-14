s = {392, 393}
sa = {}
t = {331, 332}

function main()
    for i, id in pairs(s) do
        local selected = getvalue(id)
        if count(selected) > 0 then sa[i] = selected end
    end

    for i, selected in pairs(sa) do
        if in_array(73, selected) and in_array(1055, selected) then
            remove_selected(sa[i], 73)
            remove_selected(sa[i], 1055)
            table.insert(sa[i], 731055)
        end
        setvalue(t[i], selected)
    end

end

function remove_select(arr, val)
    for k, v in pairs(arr) do
        local num = tonumber(v)
        if num == val then table.remove(arr, k) end
    end
end

main()
