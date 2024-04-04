if XConfig==nil then
  XConfig={}
  do--作用域隔离
    local function loadCache(key)
      local e
      pcall(function()
        local test = io.open(activity.getFilesDir().toString().."/"..key..".xconfig", "rb")
        e=test:read("*a");
        test:close()
      end)
      return e
    end
    local function writeCache(key,data)
      pcall(function()
        local test = assert(io.open(activity.getFilesDir().toString().."/"..key..".xconfig","wb"))
        test:write(data)
        test:close()
      end)
    end
    local function clearCache(key)
      pcall(function()
        os.remove(activity.getFilesDir().toString().."/"..key..".xconfig")
      end)
    end
    local meta={
      __index=function(tab,key)
        local t=loadCache(key)
        if t==nil then
          pcall(function()
            t=(require "config/default")[key]
          end)
        end
        rawset(tab,key,t)
        return t
      end;
      __newindex=function(tab,key,value)
        rawset(tab,key,value)
      end;
    }
    XConfig=setmetatable({
      commit = function(key)
        --print("Cache saved")
        if key==nil then
          for k, v in ipairs(XConfig) do
            --保留关键字
            if k=="commit"||k=="delete" then
             else
              writeCache(k,v)
            end
          end
         else
          writeCache(key,XConfig[key])
        end
      end,
      delete = function(key)
        if key==nil then error("不能删除没有键的缓存") end
        clearCache(key)
      end
    },meta)
  end
end