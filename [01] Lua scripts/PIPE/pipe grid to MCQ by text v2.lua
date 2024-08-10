SOURCE = 147
TARGET = 292
CONDITION = 8
NONE = 9998
NEXTPAGE = 54
ANSWER_COUNT = 295
NEXT_QUESTION_ID = 159

sa = getvalue(SOURCE)
st = gettablequestiontitles(SOURCE)
to = getquestionoptions(TARGET, "Reporting")

OPTIONS = {
    'Hypermarket / supermarket', 'Small grocery store', 'Convenience store',
    'Fresh market', 'Online shopping', 'Co-ops'
}

piped_options = {}
function main()
    NEW_OPTIONS = {}
    for i, option in pairs(OPTIONS) do NEW_OPTIONS[i] = strip(option) end
    function outlet_value_search(str)
        for i, outlet in pairs(NEW_OPTIONS) do
            -- print(str)
            -- print(outlet)
            local position = strpos(str, outlet)
            if position then return i end
        end
        return false
    end

    for row_id, ans_arr in pairs(sa) do
        local title = strip(st[row_id])
        local ans = tonumber(ans_arr[next(ans_arr)])
        if ans < CONDITION then
            table.insert(piped_options, outlet_value_search(title))
        end
    end

    -- print(piped_options)

    if count(piped_options) == 0 then jumptopage(NEXTPAGE) end
    for key, value in pairs(to) do
        local v = tonumber(value)
        if not (in_array(v, piped_options)) then
            hideoption(TARGET, value, true)
        end
        if v == NONE then hideoption(TARGET, value, false) end
    end

    if count(piped_options) > 0 then
        setvalue(ANSWER_COUNT, count(piped_options))
        setvalue(TARGET, piped_options)
        if count(piped_options) == 1 then
            setvalue(NEXT_QUESTION_ID, piped_options[next(piped_options)])
        end
    end

end

function strip(str) return string.gsub(string.lower(str), "%s+", "") end

main()
