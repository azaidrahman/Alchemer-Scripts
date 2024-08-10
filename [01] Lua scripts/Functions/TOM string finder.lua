TOM_id = 88
other_brands_id = 89

TOM = getvalue(TOM_id)
other_brands = getvalue(other_brands_id)

target_id = 90

brands_ref = {
	{"MAXIS"},
	{"CELCOM"},
	{"DIGI"},
	{"U-MOBILE"},
	{"YES"},
	{"TIME"},
	{"UNIFI","TM"}
}

final_ans = {}

function main()
	set_hide(find_brand(TOM))
	for _,brand in pairs(other_brands)do
		set_hide(find_brand(brand))
	end
	setvalue(target_id,final_ans)
end

function set_hide(ans)
	table.insert(final_ans,ans)
	hideoption(target_id,ans,true)
end

function find_brand(str)
	str = strip(str):upper()
	for k,tbl in pairs(brands_ref)do
		local matched = false
		for _,brand in pairs(tbl)do
			local dist = string.lev(str,brand)
			if dist <= math.floor(#brand/2) then matched = true end
		end
		if matched then
			return k
		end
	end
end
function strip(str)
	return str:gsub('[%p%c%s]', '')
end

function string.lev(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
	
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
	
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
	
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end
			
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end
	
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end
      
main()