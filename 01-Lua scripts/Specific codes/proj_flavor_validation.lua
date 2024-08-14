SOURCE = 59
SOURCE_ANSWER = getvalue(SOURCE) 
CATEGORIES = {
    {274,275,179}, -- food
    {321,322,323} -- grocery
}

t = 

function all_answered(tbl)
    for k,v in pairs(tbl)do
        local did_answer = getvalue(v)
        if did_answer == nil then return false
    end
    return true
end

ans = {}

if in_array('1',SOURCE_ANSWER) and not(all_answered[CATEGORIES[1]]) then
    table.insert(ans,'F')
end 

if in_array('2',SOURCE_ANSWER) and not(all_answered[CATEGORIES[2]]) then
    table.insert(ans,'G')
end

if count(ans) == 0 then table.insert(ans,99) end

setvalue(t,ans)
