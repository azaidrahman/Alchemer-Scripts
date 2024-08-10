SOURCE = 91
TARGET = 275
CONDITION = 8
NONE = 9998
NEXTPAGE = 33
COUNTRY = tonumber(getvalue(225))
-- COUNTRY = 1

sa = getvalue(SOURCE)
st = gettablequestiontitles(SOURCE)
to = getquestionoptions(TARGET, "Reporting")

OPTIONS = {
    ["foodpanda"] = 44,
    ["Grab (GrabFood)"] = 73,
    ["GoTeddy"] = 183,
    ["Nham24"] = 190,
    ["E-gets"] = 191,
    ["Mandalay Door2Door"] = 196,
    ["Wish Box"] = 224,
    ["WOWNOW"] = 322,
    ["BLOC"] = 323,
    ["WingMall"] = 324,
    ["GoodToGo"] = 343,
    ["Ningnong"] = 362
}

TOP3_BRANDS = {{44, 190, 191}, {44, 73, 224}, {44, 183, 191}}

piped_options = {}
function main()
    NEW_OPTIONS = {}
    for k, v in pairs(OPTIONS) do NEW_OPTIONS[strip(k)] = v end
    for row_id, ans_arr in pairs(sa) do
        local title = strip(st[row_id])
        local ans = tonumber(ans_arr[next(ans_arr)])
        local brand = NEW_OPTIONS[title]
        if ans < CONDITION and in_array(brand, TOP3_BRANDS[COUNTRY]) then
            table.insert(piped_options, brand)
        end
    end

    if count(piped_options) == 0 then setvalue(TARGET, NONE) end

    for key, value in pairs(to) do
        local v = tonumber(value)
        if not (in_array(v, piped_options)) then
            hideoption(TARGET, value, true)
        end
        if v == NONE then hideoption(TARGET, value, false) end
    end

    if count(piped_options) > 0 then setvalue(TARGET, piped_options) end

end

function strip(str) return string.gsub(string.lower(str), "%s+", "") end

main()
