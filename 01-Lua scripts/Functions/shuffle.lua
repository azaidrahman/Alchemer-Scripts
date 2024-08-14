function shuffle(tbl)
    local n = #tbl  -- Get the size of the table
    for i = n, 2, -1 do  -- Iterate from the last element to the second
      local j = math.random(i)  -- Generate a random index between 1 and i
      tbl[i], tbl[j] = tbl[j], tbl[i]  -- Swap the elements at i and j
    end
    return tbl  -- Return the shuffled table
  end