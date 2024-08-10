segment = tonumber(getvalue(81))
source_id = {103,102}
source_answer = {}
target_id = {116,117}
data_id = {
    {107,108,109,110},
    {111,112,113,114,115}
}

--test
-- segment = 1

orders = {
    {
        {1,3,2,4},
        {4,2,3,1},
        {3,4,1,2},
        {2,1,4,3}
    },
    {
        {1,3,4,5,2},
        {1,3,4,5,2},
        {1,3,4,5,2},
        {4,2,5,1,3},
    }
}
 --assign the probabilities of Plano and Design, this will assume assigning for
 -- A only and B is the else
segment_probs = {
    {0.25,0.25,0.25,0.25}, --Single
    {0.25,0.25,0.25,0.25}, --Tweens
    {0.25,0.25,0.25,0.25} -- Moms w kids
}

--create the source_answer with the titles
for i,s_id in pairs(source_id) do
    local ta = getquestionoptions(s_id,"Title")
    local sa = getquestionoptions(s_id,"Reporting")
    source_answer[i] = {}
    for id,value in pairs(sa)do
        source_answer[i][tonumber(value)] = ta[id]
    end
end

--assignment of randomness to A/B for P and D according to segment
assignments = {}

function assigner(i)
    local random_number = math.random()
    local prob = segment_probs[segment]
    if random_number < prob[1] then
        assignments[i] = 1
    elseif random_number < prob[1]+prob[2] then
        assignments[i] = 2
    elseif random_number < prob[1]+prob[2]+prob[3] then
        assignments[i] = 3
    elseif random_number <= prob[1]+prob[2]+prob[3]+prob[4] then
        assignments[i] = 4
    end
end

assigner(1)
assigner(2)

-- print(assignments)

--autocode assignment
for i, id in pairs(target_id)do
    setvalue(id,assignments[i])
end

for i, data in pairs(data_id)do
    local current_order = orders[i][assignments[i]]
    for data_i,id in pairs(data)do
        setvalue(id,source_answer[i][current_order[data_i]])
        -- print("setting "..source_answer[i][current_order[data_i]].." to "..id)
    end
end