s = 303
t = {308,309,311,312,313}

sa = getvalue(s)
st = gettablequestiontitles(s) 

function strip(str)
    return string.gsub(string.lower(str), "%s+", "")
end

function strip_array(arr)
    local tmp = {}
    for k,v in pairs(arr)do
        local v = strip(v)
        if v ~= "" and not(tonumber(v)) then
            tmp[k] = v
        end
    end
    -- print'tmp:'
    -- print(tmp)
    return tmp
end

often_coding = {{},{},{},{},{}}
for source_id,table_answer in pairs(sa)do
    local ans = tonumber(table_answer[next(table_answer)]) -- 1-5
    local ans_title = strip(st[source_id])
    table.insert(often_coding[ans],ans_title)
end


for i,tbl in pairs(often_coding) do

    if count(tbl) > 0 then
        local current_question = t[i]
        -- print'current question:'
        -- print(current_question)
        local target_titles = strip_array(getquestionoptions(current_question,"Title")) -- table of brand list // [id] -> title
        local target_values = getquestionoptions(current_question,"Reporting") -- table of brand list // [id] -> reporting value
        -- title -> id -> reporting value
        local target_title_flip = array_flip(target_titles) -- [title] -> id
        -- [title] -> id
        -- [id] -> reporting value
        -- print('flip:')
        -- print(target_title_flip)
        local tmp_ans = {}
        for _,title in pairs(tbl)do
            -- print('title:')print(title)
            local QID = target_title_flip[title]
            local value = target_values[QID]
            table.insert(tmp_ans,value)
        end 
        -- print(tmp_ans)
        setvalue(current_question,tmp_ans)
    end
end
