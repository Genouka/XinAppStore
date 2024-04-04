--简单的操作缓存，自动从文件读写，无需考虑内部实现细节

--[[
By @Genouka 评论区留言后授权使用

这个东西是从我的项目抽离出来的小玩意。
请注意只能存取字符串，如果要存table请先json.encode(table)

🌸基本使用方法：
1.写入
XCache["key"]="a"
XCache.commit("key")

2.批量写入
XCache["key1"]="b"
XCache["key2"]="c"
XCache.commit()

3.读取
print(XCache["key"])

🌸更高级的用法：
例子：设置缓存时间
CACHE_CONFIG_TIME="cache_configtime1"
cachekey="cache_app_used1"
local cc=(600)
      if cc<0
        or XCache[cachekey]==nil
        or XCache[cachekey]==""
        or XCache[CACHE_CONFIG_TIME]==nil
        or os.time()-XCache[CACHE_CONFIG_TIME]>=cc--默认10分钟缓存
        then
        --print("使用网络")
        if cc>=0 then--当缓存时间大于等于0时建立缓存
          XCache[CACHE_CONFIG_TIME]=os.time()
          XCache.commit(CACHE_CONFIG_TIME)
        end
        ...--在这里写没有缓存时的逻辑
        XCache[cachekey]=body
        XCache.commit(cachekey)
        return body
      else
        return XCache[cachekey]
      end
]]
if XCache==nil then
  XCache={}
  do--作用域隔离
    local function loadCache(key)
      local e
      pcall(function()
        local test = io.open(activity.getCacheDir().toString().."/"..key..".xcache", "rb")
        e=test:read("*a");
        test:close()
      end)
      return e
    end
    local function writeCache(key,data)
      pcall(function()
        local test = assert(io.open(activity.getCacheDir().toString().."/"..key..".xcache","wb"))
        test:write(data)
        test:close()
      end)
    end
    local function clearCache(key)
      pcall(function()
        os.remove(activity.getCacheDir().toString().."/"..key..".xcache")
      end)
    end
    local meta={
      __index=function(tab,key)
        local t=loadCache(key)
        rawset(tab,key,t)
        return t
      end;
      __newindex=function(tab,key,value)
        rawset(tab,key,value)
      end;
    }
    XCache=setmetatable({
      commit = function(key)
        --print("Cache saved")
        if key==nil then
          for k, v in ipairs(XCache) do
            --保留关键字
            if k=="commit"||k=="delete" then
             else
              writeCache(k,v)
            end
          end
         else
          writeCache(key,XCache[key])
        end
      end,
      delete = function(key)
        if key==nil then error("不能删除没有键的缓存") end
        clearCache(key)
      end
    },meta)
  end
end


print("这是个工具库喵，不能直接运行的！请放到你自己的项目使用")