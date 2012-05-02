module('kata', package.seeall)

local kata = {}

function kata.split(path, separator)
  local output = {}
  for x in string.gmatch(path, '[^' .. separator .. ']+') do
    table.insert(output, x)
  end
  return output
end

function kata.combinations(elements, length)
  local combos = {}

  for i=1, #elements do
    if length == 1 then
      return {{elements[i]}}
    else
      local subelements = {}
      for j=2, #elements do
        table.insert(subelements, elements[j])
      end
      for _, n in ipairs(kata.combinations(subelements, length-1)) do
        return {kata.merge_table({elements[i]}, n)}
      end
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
