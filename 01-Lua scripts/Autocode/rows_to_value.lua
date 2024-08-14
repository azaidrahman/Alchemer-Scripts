s = 117
t = {125,127}

sa = getvalue(s)
st = gettablequestionskus(s)

function rows_to_value(allowed)
    local ans = {}

    function flip(arr)
        local rst = {}
        for k,v in pairs(arr)do
            rst[v] = tonumber(k)+1
        end
        return rst
    end

    local stf = flip(st)

    for sku,tbl in pairs(sa)do
        local val = tbl[next(tbl)]
        if in_array(val,allowed) then
            ans[sku] = stf[sku]
        end
    end

    return ans
end

setvalue(t[1],rows_to_value({1,2,4}))
setvalue(t[2],rows_to_value({3,5}))
