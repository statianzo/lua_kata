module('kata', package.seeall)

local kata = {}

function kata.split(path, separator)
  local output = {}
  for x in string.gmatch(path, '[^' .. separator .. ']+') do
    table.insert(output, x)
  end
  return output
end

function kata.combine2(elements, length)
  local combos = {}
  for i=1, #elements do
    if length == 1 then
      table.insert(combos, { elements[i] })
    else
      local copy = kata.append_table({}, elements, i+1)
      local head = elements[i]
      for _, combo in ipairs(kata.combine2(copy, length-1)) do
        table.insert(combos, kata.append_table({head}, combo))
      end
    end
  end
  return combos
end

function kata.combine(elements, length)
  local combos = {}
  local indices = {}
  for j = 1, length do
    -- initialize indices to first i indices of elements
    table.insert(indices, j)
  end

  -- loop until the indices can't be advanced
  while true do
    local combo = {}
    for k = 1, #indices do
      table.insert(combo, elements[indices[k]])
    end

    table.insert(combos, table.concat(combo, '-'))

    local index_advanced = false
    -- advance indices in reverse order
    for k = #indices, 1, -1 do
      if indices[k] ~= #elements and indices[k] + 1 ~= indices[k + 1] then
        indices[k] = indices[k] + 1
        -- reset subsequent indices to immediately follow changed index
        for l = k + 1, #indices do
          indices[l] = indices[k] + l - k
        end

        index_advanced = true
        break -- only advance one index at a time
      end
    end

    -- no index could be advanced
    if not index_advanced then break end
  end

  return combos
end

function kata.combinations(elements)
  local all = {}
  for i=1, #elements do
    kata.append_table(all, kata.combine(elements, i))
  end
  return all
end

function kata.append_table(t1, t2, start)
  start = start or 1
  for i=start, #t2 do
    table.insert(t1, t2[i])
  end
  return t1
end

function kata.build_tree(path, existing)
  path = path or ""

  existing = existing or {}
  local last = existing
  local nodes = kata.split(path, '/')
  for _, w in ipairs(nodes) do
    local conodes = kata.split(w, '|')
    for _, x in ipairs(conodes) do
      last[x] = {}
    end
    last = last[w]
  end
  return existing
end

return kata
