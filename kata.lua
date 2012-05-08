module('kata', package.seeall)

local kata = {}

function kata.split(path, separator)
  local output = {}
  for x in string.gmatch(path, '[^' .. separator .. ']+') do
    table.insert(output, x)
  end
  return output
end

function kata.combine(elements, length)
  local combos = {}
  for i=1, #elements do
    if length == 1 then
      table.insert(combos, { elements[i] })
    else
      local copy = kata.append_table({}, elements, i+1)
      local head = elements[i]
      for _, combo in ipairs(kata.combine(copy, length-1)) do
        table.insert(combos, kata.append_table({head}, combo))
      end
    end
  end
  return combos
end

function kata.map(elements, func)
  local mapped = {}
  for _, x in ipairs(elements) do
    table.insert(mapped, func(x))
  end
  return mapped
end

function kata.combinations(elements)
  local all = {}
  for i=1, #elements do
    kata.append_table(all, kata.combine(elements, i))
  end
  return kata.map(all, function(x) return table.concat(x, '-') end)
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
