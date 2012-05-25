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

  local nodes = kata.split(path, '/')
  if #nodes == 0 then
    return existing
  end

  local head = table.remove(nodes, 1)
  local tail = table.concat(nodes, '/')

  local conodes = kata.split(head, '|')
  local combos = kata.combinations(conodes)
  for _, x in ipairs(combos) do
    existing[x] = existing[x] or {}
    kata.build_tree(tail, existing[x])
  end

  return existing
end

function kata.collapse_tree(tree, path)
  path = path or ''

  local keys = kata.table_keys(tree)
  table.sort(keys, function(k1, k2) return #k1 < #k2 end)
  local largest = keys[#keys]
  if largest == nil then
    return path
  end

  local uniques = kata.split(largest, '-')

  local child = kata.collapse_tree(tree[keys[1]], path)

  path = '/' .. table.concat(uniques, '|') .. child

  return path
end

function kata.table_keys(t)
  local result = {}
  for k,_ in pairs(t) do
    table.insert(result, k)
  end

  return result
end

function kata.find_synonym(tree, target_path)
  local target_tree = kata.subtree(tree, target_path)

  local synonyms = {}
  kata.traverse_tree(tree, function(t, t_path)
    if kata.compare_trees(target_tree, t) and target_path ~= t_path then
      table.insert(synonyms, t_path)
    end
  end)

  return synonyms
end


function kata.subtree(tree, path)
  local segments = kata.split(path, '/')
  local current = tree
  for _,seg in ipairs(segments) do
    current = current[seg]
  end

  return current
end

function kata.traverse_tree(tree, fn, path)
  fn(tree, path or '/')
  path = path or ''
  for key, child in pairs(tree) do
    kata.traverse_tree(child, fn, path .. '/' .. key)
  end
end

function kata.compare_trees(t1, t2)
  if not #t1 == #t2 then
    return false
  end

  for key,sub in pairs(t1) do
    if not t2[key] then
      return false
    elseif not kata.compare_trees(sub, t2[key]) then
      return false
    end
  end

  return true
end

return kata
