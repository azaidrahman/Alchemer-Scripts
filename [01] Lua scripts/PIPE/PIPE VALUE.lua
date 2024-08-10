--Made by Zaid 2021 (azaidrahman@gmail.com)

--SETTINGS
PIPE_TYPE           = 0                  -- Refer to PIPE_TYPE below to use which code to pipe circumstance       
pipe_from_others    = true              -- Piping previous input from others into current question ( true / false )           
jump_if_only_one    = false              -- Autocode the answer if theres only one and jump into next question (if true enter the page id inside PAGES_ID) ( true / false )           
term_if_only_others = true               -- Terminate if theres only others answered ( true / false )

--FOR GRID QUESTIONS (CODE:1)
pipe_row            = true              -- If you are piping to target table and piping into rows
pipe_column         = false              -- If you are piping to target table and piping into columns
others_pos          = 5

--FOR GRID TO GRID (CODE:2)
requirement = 3
greaterThan = true

-- MCQ -> MCQ : 0 || MCQ -> grid : 1 || grid -> grid : 2 || grid -> MCQ : 3 || sandbox : 99

PAGES_ID = [[
    next 46
    current auto
    thankyou 2
    terminate 3 
]]

function main()    
    local source_id           = 3
    local target_id           = 12
    secondary_source_id       = 0

    from_grid = pipe_column and true or false --ternary operator for lua, basically meaning if pipe_column is true then this variable is true else false
    ------------------------------------------------------------
    
    pages = page_maker()
    
    current_question_types = question_type_func(pages["current"])
    
    if PIPE_TYPE == 0 then 
        pipe_mcq_to_mcq(source_id, target_id)
    elseif PIPE_TYPE == 1 then
        pipe_mcq_to_grid(source_id, target_id)
	elseif PIPE_TYPE == 2 then
        pipe_grid_to_grid(source_id,target_id)
    elseif PIPE_TYPE == 3 then
        pipe_grid_to_mcq(source_id,target_id)
    elseif PIPE_TYPE == 99 then
        sandbox(source_id,target_id)
    end

end

-- CONSTANTS
EXCLUDE_OPTIONS = {             
    ["others"] = '97',                              
    ["all"]    = '98',                              
    ["none"]   = '99'                               
}
MAIN_QUESTION_TYPES = {"CHECKBOX","RADIO","TABLE","RANK"}
others_text = "other"

------------------------------------

function sandbox(source_id,target_id)
    return
end

function pipe_mcq_to_mcq(source_id,target_id)

    if type(source_id) ~= 'number' or type(target_id) ~= 'number' then return end
    
    local source_type = type(getvalue(source_id))
    local source_answer = {}
    local target_options = getquestionoptions(target_id, "Reporting")
    if not pipe_from_others then local target_title = getquestionoptions(target_id, "Title") end
    
    local autocode_answers = {}
    local others_answer = nil
    local others_key = nil

    local hidden_value = 0
    
    --SEPARATE OTHERS TO RESOLVE EDGE CASE OF OTHERS BEING A NUMBER AND CONSIDERED AS REPORTING VALUE
    -- For checkbox
    if source_type == "table" then 
        source_answer = getvalue(source_id) or print("ERROR CODE 0.1")
        for k,v in pairs(source_answer)do
            -- IF SOURCE IS FROM A RAW OTHERS INPUT
            if string.find(k,others_text) then
                others_answer = v
                others_key = string.gsub(k,"-other","")
                source_answer[k] = nil --table.remove(source_answer,k)
            -- IF SOURCE IS FROM A PIPED OTHERS 
            elseif string.find(k,"id=") then
                others_answer = v
                source_answer[k] = nil
            --[[elseif  v == EXCLUDE_OPTIONS['others'] then
                source_answer[k] = nil]]--
            end
        end
    else -- For radiobutton
        local source_title = strip(getvaluelabel(source_id))  or print("ERROR CODE 0.2")
        if string.find(source_title,others_text) then
            others_answer = getvalue(source_id)
        end
        table.insert(source_answer, getvalue(source_id)) --IF ITS ONLY 1 OTHERS, TERMINATE_IF_ONLY_OTHERS ALREADY TAKES CARE OF THIS
    end

    -- print(source_answer)
    
    -- IF THERES ONLY 1 OTHERS FROM A RADIO BUTTON, THEN SEND TO TERMINATE IF SETTING "term_if_only_others" is true
    terminate_if_only_others(source_id, others_answer, source_answer)
    -- LOOP THROUGH ALL THE OPTIONS, ESSENTIALLY HIDE ALL OPTIONS AND UNHIDE IF PASS CONDITIONS

    for key,reporting_value in pairs(target_options)do 
        -- hideoption(target_id, reporting_value, false)
        if not(in_array(reporting_value, source_answer)) then
            hideoption(target_id, reporting_value, true)
            hidden_value = hidden_value + 1

            -- AUTOCODE THE ANSWERS BESIDE "NONE"
            if reporting_value ~= EXCLUDE_OPTIONS["none"] then
                if not(pipe_from_others) and reporting_value == EXCLUDE_OPTIONS["others"] then  
                end
            end
            -- break
        else
            autocode_answers[key] = reporting_value
        end

        -- In case of others
        if ( (pipe_from_others and reporting_value == EXCLUDE_OPTIONS["others"] and others_answer ~= nil) -- This case is if its piped from previous question
            or (not pipe_from_others and reporting_value == EXCLUDE_OPTIONS["others"])) then -- This case is if respondent needs to input the others
                hideoption(target_id, reporting_value, false)
        end

        if reporting_value == EXCLUDE_OPTIONS["none"] then hideoption(target_id, reporting_value, false) end
    end

    --JUMP WHEN THERES ONLY ONE
    --TODO: could probably turn this into a function
    if jump_if_only_one and count(autocode_answers) == 1 and not(from_grid) then
        if in_array(target_id,current_question_types["CHECKBOX"]) then -- if target_id is a checkbox
            setvalue(target_id,autocode_answers)
            jumptopage(pages["next"])
        else
            for k,v in pairs(autocode_answers)do -- if target_id is a radio button
                setvalue(target_id,v)
            end
            jumptopage(pages["next"])
        end
    end

    if hidden_value == count(target_options) then
        jumptopage(pages["next"])
    end
end

function pipe_mcq_to_grid(source_id,target_id)
    
    if (type(source_id) ~= 'number' or type(secondary_source_id) ~= 'number') and type(target_id) ~= 'number' then return end

    others_answered = false
    local target_options = array_flip(gettablequestiontitles(target_id)) or print("ERROR CODE 1.1")
    local target_options_skus = gettablequestionskus(target_id) or print("ERROR CODE 1.1")
    local src_ans, src_ans_label     = source(source_id)
    local sec_src_ans, sec_ans_label = source(secondary_source_id)
    local target_options_ordered = order_rows(target_options_skus)
  
    ------------------------------------------------------------------
    for row_title,row_id in pairs(target_options)do
        --TODO: make an array of id's of rows that passed 
        if pipe_row then
            -- row_title = strip(row_title) or print("ERROR CODE 1.4")
            -- hidequestion(row_id,true)
            -- if in_array(row_title,src_ans_label) or (others_answered and row_title:find(strip("option value")))  then
            --     hidequestion(row_id,false)
            -- end
            local current_val = target_options_ordered[row_id]
            if not(in_array(current_val,src_ans)) then 
                hidequestion(row_id,true)
            end
            
            if pipe_from_others and others_answered and current_val == others_pos then
                hidequestion(row_id,false)
            end

        end
        if pipe_column then
            if not(pipe_row) then
                pipe_mcq_to_mcq(source_id, row_id)
            else
                pipe_mcq_to_mcq(secondary_source_id, row_id)
            end
        end
    end
end

function pipe_grid_to_grid(source_id,target_id)
    local source_answer = getvalue(source_id) or print("ERROR CODE 2.1")
    local source_title = array_flip(gettablequestiontitles(source_id)) or print("ERROR CODE 2.2")
    local target_title = array_flip(gettablequestiontitles(target_id)) or print("ERROR CODE 2.3")


    for key,row_id in pairs(target_title)do
        sa_title = source_answer[source_title[key]] or print("ERROR CODE 2.4")
        hidequestion(row_id,true)
        if table_exists(sa_title) then
            for _,rval in pairs(sa_title)do
                rval = tonumber(rval) or print"ERROR CODE 2.5"
                if greaterThan and rval >= requirement then
                    hidequestion(row_id,false)
                elseif not(greaterThan) and rval <= requirement then
                    hidequestion(row_id,false)
                end
            end
        end
    end
end

function pipe_grid_to_mcq(source_id,target_id)
    local source_answer = getvalue(source_id) or print("ERROR CODE 2.1")
    local source_title = array_flip(gettablequestiontitles(source_id)) or print("ERROR CODE 2.2")
    local target_title = getquestionoptions(target_id,"Reporting") or print("ERROR CODE 2.3")


    for key,row_id in pairs(target_title)do
        sa_title = source_answer[source_title[key]] or print("ERROR CODE 2.4")
        hidequestion(row_id,true)
        if table_exists(sa_title) then
            for _,rval in pairs(sa_title)do
                rval = tonumber(rval) or print"ERROR CODE 2.5"
                if greaterThan and rval >= requirement then
                    hidequestion(row_id,false)
                elseif not(greaterThan) and rval <= requirement then
                    hidequestion(row_id,false)
                end
            end
        end
    end
end

--IF ITS ONLY OTHERS THEN SKIP TO TERMINATE (has to be an array)
function terminate_if_only_others(source_id,others_answer,source_answer)
    local c = false
    
    if not term_if_only_others or not others_answer then return end 
    
    -- THIS IS WHEN ITS A SINGLE ANSWER THEREFORE THE SOURCE ANSWER IS THE SAME AS OTHER ANSWER
    if source_answer == others_answer then c = true end

    if not(table_exists(source_answer)) and others_answer ~= nil then
        c = true
    end
 
    if c then jumptopage(pages["terminate"]) else return end
end

--STANDARDIZE THE TEXT BY STRIPPING OFF SPACES AND TURNING INTO LOWER
function strip(str)
    return string.gsub(string.lower(str), "%s+", "")
end

--RETURN ARRAY OF SOURCE ANSWERS
function source(id)
    local source_type = type(getvalue(id))
    ans,label = {},{}
    --INITIALIZE THE SOURCE ANSWERS REGARDLESS IF PIPING TO ROW OR COLUMN
    if source_type == "table" then 
        ans = getvalue(id)
        label = getvaluelabel(id)
    else 
        table.insert(ans,getvalue(id))
        table.insert(label,getvaluelabel(id)) 
    end
	
	for k,v in pairs(ans) do
		if string.find(k,others_text) then
			for m,n in pairs(label)do
				if v == tostring(m) then
					label[m] = nil
				end
			end
		end
	end

    for key,value in pairs(label) do
        label[key] = strip(value)
        if string.find(label[key],others_text) then
			label[key] = nil
            others_answered = true
        end
    end

    return ans,label
end

-- INITIALIZE THE PAGES STRING INTO AN ARRAY
function page_maker()
    local pages = {}

    --TODO make text into array function
    for line in PAGES_ID:gmatch("(.-)\n") do
        page_title = nil
        page_id = nil
        for token in string.gmatch(line, "[^%s]+")do
            if page_title == nil then
                page_title = token
            elseif page_id == nil then
                page_id = tonumber(token)
            end
        end
        if page_title == "current" then pages[page_title] = currentpagesku()
        -- elseif page_title == "next" then pages[page_title] = 
        else pages[page_title] = page_id

        end
    end

    return pages
end

function question_type_func(pageid)
    local question_types = {}
    for _,types in pairs(MAIN_QUESTION_TYPES) do
        question_types[types] = allquestionsoftype(types,pageid)
    end
    return question_types
end

function round(num)
    return num + (2^52 + 2^51) - (2^52 + 2^51)
end

function between(num, a, b)
	if num >= a and num <= b then
		return true
	else
		return false
	end
end

function multi_compare(c,...)
    local rst = false
    local ans = arg[1]
   
    if c then
        if ans >= arg[2] and ans <= arg[3] then
            rst = true
        end
    else
        for i=2,(#arg+2) do
            if ans == arg[i] then
                rst = true
                break
            end
        end
    end

    return rst
end

function orderedPairs(t)

    function cmp_multitype(op1, op2)
        local type1, type2 = type(op1), type(op2)
        if type1 ~= type2 then --cmp by type
            return type1 < type2
        elseif type1 == "number" or type1 == "string" then --type2 is equal to type1
            return op1 < op2 --comp by default
        elseif type1 == "boolean" then
            return op1 == true
        else
            return tostring(op1) < tostring(op2) --cmp by address
        end
    end
    
    function __genOrderedIndex( t )
        local orderedIndex = {}
        for key in pairs(t) do
            table.insert( orderedIndex, key )
        end
        table.sort( orderedIndex, cmp_multitype )
        return orderedIndex
    end
    
    function orderedNext(t, state)
        local key = nil
        --print("orderedNext: state = "..tostring(state) )
        if state == nil then
            -- the first time, generate the index
            t.__orderedIndex = __genOrderedIndex( t )
            key = t.__orderedIndex[1]
        else
            -- fetch the next value
            for i = 1,#t.__orderedIndex do
                if t.__orderedIndex[i] == state then
                    key = t.__orderedIndex[i+1]
                end
            end
        end
    
        if key then
            return key, t[key]
        end
    
        -- no more value to return, cleanup
        t.__orderedIndex = nil
        return
    end
    return orderedNext, t, nil
end

function recurs_merge(...)
	local arr = {}
  	for i = 1, #arg do
    	arr = array_merge(arr,arg[i])
    end
  	return arr
end

function table_exists(arr)
    return arr[next(arr)] or nil
end

function manual_arr_flip(arr)
    local rst = {}
    for k,v in pairs(arr)do
        rst[v] = tonumber(k)+1
    end
    return rst
end

function order_rows(arr)
    local rst = {}
    local skus = {}
    local min,max
    for k,v in pairs(arr)do
        local qid = tonumber(v)	
        if not min or qid < min then
            min = qid
        end
        if not max or qid > max then
            max = qid
        end
        table.insert(skus,qid)
    end

    local ite = 1
    for i=min,max do
        if in_array(i,skus) then
            rst[i] = ite
            ite = ite + 1
        end
    end
    return rst
end

function is_others_reporting_value(num)
	local val = tonumber(num)
  	if not(val) then return false end
  	
  	local val_string = tostring(num)
  	local rst = ""
  	if val_string:len() > 2 then
		rst = val_string:sub(val_string:len()-1)
	else
		rst = val_string
	end

	return tonumber(rst)
end

main()