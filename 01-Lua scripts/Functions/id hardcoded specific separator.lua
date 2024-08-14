COUNTRIES_ID = 225
TARGET = 56
OTHER = 9997
NONE = 9998

country = tonumber(getvalue(COUNTRIES_ID))
to = getquestionoptions(TARGET, "Reporting")
REF = {
    {44, 73, 190, 191, 322, 323, 324, 343}, {44, 73, 196, 224},
    {44, 183, 191, 362}
}

for k, v in pairs(to) do
    local num_val = tonumber(v)
    if num_val ~= OTHER or num_val ~= OTHER then
        if not (in_array(num_val, REF[country])) then
            hideoption(TARGET, v, true)
        end
    end
end

