local md={}
setmetatable(md,md)
local metatable={__index=md}
function md.__call(self)
  local self={}
  setmetatable(self,metatable)
end

local context=activity or service
assert(context,"Context Nil Error")
function md.load(a)
  dofile(context.getLuaDir().."/"..a..".lua")
end

function md.view(a)
  return require("/views/def/"..a)
end

function md.layout(a)
  return loadlayout(md.view(a))
end
--Only for Activity
function md.setContentView(a)
  assert(activity,"Only Activity Could Use!")
  local st,er=pcall(function()
    activity.setContentView(paths.layout(a))
  end)
  if !st then
    err="[01]创建布局时崩溃\n"..er
    md.error()
    return true
  end
  return false
end
function md.error()
  dofile(activity.getLuaDir().."/common/recover/r1.lua")
end
return md