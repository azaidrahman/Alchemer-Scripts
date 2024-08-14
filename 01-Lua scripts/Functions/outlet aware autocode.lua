OUTLET_AWARE_ID = 292
PRIMARY_OUTLET_ID = 159
NONE = 9998
TARGET = 298

OUTLET_AWARE = getvalue(OUTLET_AWARE_ID)
PRIMARY_OUTLET = tonumber(getvalue(PRIMARY_OUTLET_ID))

outlet_set = {}

function main()
    if count(OUTLET_AWARE) > 1 then
        if PRIMARY_OUTLET == NONE then
            setvalue(TARGET, randomly_choose(OUTLET_AWARE, 2))
        elseif PRIMARY_OUTLET ~= NONE then
            table.insert(outlet_set, PRIMARY_OUTLET)
            table.insert(outlet_set, randomly_choose(OUTLET_AWARE, 1)[1])
            -- print"outletset"
            -- print(outlet_set)
            setvalue(TARGET, outlet_set)
        end
    else
        setvalue(TARGET, OUTLET_AWARE[next(OUTLET_AWARE)])
    end
end

function randomly_choose(arr, n)
    tmp = {}
    for k, v in pairs(arr) do table.insert(tmp, v) end
    rst = {}

    while count(rst) < n do
        local i = math.random(count(tmp))
        local rand = tmp[i]
        if not (in_array(rand, outlet_set)) then
            table.remove(tmp, i)
            table.insert(rst, rand)
        end
    end
    -- print(rst)
    return rst
end

main()

