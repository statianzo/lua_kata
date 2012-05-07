module('kata', package.seeall)

local kata = {}

function kata.split(path, separator)
  local output = {}
  for x in string.gmatch(path, '[^' .. separator .. ']+') do
    table.insert(output, x)
  end
  return output
end

function kata.combinations(elements)
  local combos = {}

  -- outer loop is sample size
  for i = 1, #elements do
    -- indices to retrieve from elements
    local indices = {}
    for j = 1, i do
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
  end

  return combos
end


function kata.merge_table(t1, t2)
  for k,v in pairs(t2) do
    table.insert(t1, k, v)
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
