function collaborators#list()
  let cwd = getcwd()
  return systemlist('git log | grep Author: | sort | uniq | cut -c 9-')
endfunction

lua << END
local cmp = require'cmp'

local source = { }

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.collabCache = vim.fn['collaborators#list']()
  return self
end

function source:complete(params, callback)
  if string.find(vim.fn.getline('.'), 'author') then
    local res = {}
    for k,v in pairs(self.collabCache) do
      res[k] = { label = v }
    end
    callback(res)
  else
    callback({ { label = 'co-authored-by: ' } })
  end
end

cmp.register_source('collaborators', source.new())
END
