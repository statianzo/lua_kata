module('kata', package.seeall)

local kata = {}

function kata.build_tree(path, existing)
  path = path or ""

  existing = existing or {}
  local last = existing
  for w in string.gmatch(path, '%a+') do
      last[w] = {}
      last = last[w]
  end
  return existing
end

return kata
