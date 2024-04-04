--require "/common/init"
--require("./paths")
local md={}
setmetatable(md,md)
local metatable={__index=md}
function md.__call(self)
  local self={}
  setmetatable(self,metatable)
end
require("/common/paths")
return md
--print(app.view("hi)h"))