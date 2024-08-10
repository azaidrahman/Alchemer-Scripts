SOURCE = 192
TARGET = 321
CONDITION = 8
NONE = 9998
-- NEXTPAGE = 31

sa = getvalue(SOURCE)
st = gettablequestiontitles(SOURCE)
to = getquestionoptions(TARGET, "Reporting")

OPTIONS = {
    ["foodpanda"] = 44,
    ["GoTeddy"] = 183,
    ["Nham24"] = 190,
    ["Wish Box"] = 224,
    ["Grab (GrabMart)"] = 1055,
    ["Egets"] = 1136,
    ["delishop"] = 1137,
    ["grocerdel"] = 1139,
    ["Grocer Delivery Asia"] = 1140,
    ["Zaychin"] = 1309,
    ["Citymall Online"] = 1310,
    ["Shop.com.mm"] = 1311,
    ["gofresh"] = 1312,
    ["WOWNOW"] = 322,
    ["KBZPay Market"] = 1331,
    ["GoodToGo"] = 1358,
    ["Kokkok express"] = 1391,
    ["OneX"] = 1392,
    ["YesPls"] = 1393,
    ["SokxayAll"] = 1394
}

piped_options = {}
function main()
    NEW_OPTIONS = {}
    for k, v in pairs(OPTIONS) do NEW_OPTIONS[strip(k)] = v end
    for row_id, ans_arr in pairs(sa) do
        local title = strip(st[row_id])
        local ans = tonumber(ans_arr[next(ans_arr)])
        if ans < CONDITION then
            table.insert(piped_options, NEW_OPTIONS[title])
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
