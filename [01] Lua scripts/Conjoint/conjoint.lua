all_para_id = 144
para_ranks_id = {137,138,139,140,141}
attr_id_original = {143,145,146,147,148,160,161,162,163,164,165,166,167,168,169,170}
price_id = 159
display_id = {152,153,154,155,156}

price_values = array_flip(getquestionoptions(price_id,"Reporting"))
price_titles = getquestionoptions(price_id,"Title")

para_prices_list = [[
1333
143
12
142
121
123
1222
221244
13
13322
144
1333
11
122
13
111
]]

display_arr = {
	{1,1,1,1,1},
	{1,2,1,2,1},
	{2,1,2,1,2},
	{1,1,1,2,2},
	{2,2,2,1,1}
}
	
price_count = {
	{0,0,0,0},
	{0,0,0,0},
	{0,0,0,0},
	{0,0,0,0},
	{0,0,0,0}
}

function main()
  
	--EXPLODE() starts from 0 so remember to add 1 to index
	para_prices_arr_original = explode("\n",para_prices_list)
	para_prices_arr = {}
	for i,price_string in pairs(para_prices_arr_original)do
		local price_number = tonumber(price_string)
		para_prices_arr[i+1] = price_number
	end
	
	para_ranks_value = {}
	
	for i,para_id in ipairs(para_ranks_id)do
		para_ranks_value[tonumber(getvalue(para_id))] = i
	end

	local display_idx = 1
  	local para_idx = 1
	
	attr_id_filtered = {}
	attr_id_flipped = {}
	
	for attr_idx,attr_id in ipairs(attr_id_original)do
		local attr_ans = array_flip(getvalue(attr_id))				
		attr_id_flipped[attr_id] = attr_idx
		if count(attr_ans) > 0 then 
			table.insert(attr_id_filtered,attr_id)
		end
	end
		
	
	for attr_idx,attr_id in ipairs(attr_id_filtered)do
	
		local attr_ans = array_flip(getvalue(attr_id))				
			
		local attr_values = getquestionoptions(attr_id,"Reporting")
		local attr_titles = getquestionoptions(attr_id,"Title")
		local attr_rank1_value = tonumber(attr_values[attr_ans[1]])
		local attr_rank2_value = tonumber(attr_values[attr_ans[2]])
	
		local para_id = para_ranks_id[para_ranks_value[attr_id_flipped[attr_id]]]
		local current_para_value = tonumber(getvalue(para_id))
		local current_para_values = array_flip(getquestionoptions(para_id,"Reporting"))
		local current_para_titles = getquestionoptions(para_id,"Title")
		local current_para_title = current_para_titles[current_para_values[current_para_value]]
		
		-- local current price = price_calcutor(price_count)
		local rank1_title = attr_titles[attr_ans[1]]
		local rank2_title = attr_titles[attr_ans[2]]
		
		local rank1_display = (para_idx)..'. '..current_para_title..'\n'..'<strong>'..rank1_title..'</strong>\n'
		local rank2_display = (para_idx)..'. '..current_para_title..'\n'..'<strong>'..rank2_title..'</strong>\n'
		
		
		for outer_display_i = 1,5 do
			for inner_display_i,current_rank in pairs(display_arr[outer_display_i])do
				if inner_display_i == attr_idx then
					local current_price_rank = 0
					local current_price_count = price_count[outer_display_i]
					local current_display_arr = display_arr[outer_display_i]
					
					if current_rank == 1 then current_price_rank = get_price_rank(current_para_value,attr_rank1_value)
					elseif current_rank == 2 then current_price_rank = get_price_rank(current_para_value,attr_rank2_value) end
					
					
					
					current_price_count[current_price_rank] = current_price_count[current_price_rank] + 1
					
					if current_rank == 1 then current_display_arr[inner_display_i] = rank1_display..' ^P'..current_price_rank
					elseif current_rank == 2 then current_display_arr[inner_display_i]  = rank2_display..' ^P'..current_price_rank
					end
										
					if inner_display_i == #current_display_arr then
						print(current_price_count)
						table.insert(current_display_arr,'Price: <strong>'..price_calculator(current_price_count)..'</strong>')
						table.insert(current_display_arr,'For Testing: 1-['..current_price_count[1]..'] 2-['..current_price_count[2]..'] 3-['..current_price_count[3]..'] 4-['..current_price_count[4]..']')
					end

					break
					
				end
			end
		end

		para_idx = para_idx + 1
		
		
	end
	
	for outer_display_i,display_id in ipairs(display_id)do
		local full_string = ""
		for inner_display_i,string in ipairs(display_arr[outer_display_i])do
			full_string = full_string..string..'\n'
		end
		setvalue(display_id,full_string)
		-- print(full_string)
	end
	
	-- print(display_arr)
	
end

function get_rank_from_digit(num, digit)
	-- print(substr(tostring(num),digit-1,1))
	return tonumber(substr(tostring(num),digit-1,1))
end

function get_price_rank(para_val,attr_rank)
	local inner_para_num = tonumber(para_prices_arr[para_val])
	-- print('inner para: '..inner_para_num)
	
	return get_rank_from_digit(inner_para_num,attr_rank)
end

function price_calculator(price_count_arr)	
	price_set = 0
  
	if price_count_arr[4] == 5 then
		price_set = 9
	elseif price_count_arr[4] >=3 and price_count_arr[4] <= 4 then
		price_set = 8
	elseif price_count_arr[4] == 2 or price_count_arr[3] == 5 then
		price_set = 7	
	elseif price_count_arr[4] == 1 or price_count_arr[3] >= 2 and price_count_arr[3] <= 4 then
		price_set = 6
	elseif price_count_arr[3] == 1 then
		price_set = 5
	elseif price_count_arr[2] == 5 then
		price_set = 4
	elseif price_count_arr[4] == 0 and price_count_arr[3] == 0 and price_count_arr[2] > price_count_arr[1] then
		price_set = 3
	elseif price_count_arr[4] == 0 and price_count_arr[3] == 0 and price_count_arr[1] > price_count_arr[2] then	
		price_set = 2
	elseif price_count_arr[1] == 5 then
		price_set = 1
	end
	
	return price_titles[price_values[price_set]]

end



main()
