require "import"

--if !json then json=require("cjson") end
local edang={}
local edang_inner={}

local CACHE_APPLIST="edang_cache_applist"
local CACHE_BANNER="edang_cache_banner"
local CACHE_CATEGORY="edang_cache_category"
local CACHE_CONFIG_TIME="edang_cache_config"
--[[
if edang.applist_cache==nil then
  edang.applist_cache=loadCache(CACHE_KEY)
end
if edang.banner_cache==nil then
  edang.banner_cache=loadCache(CACHE_KEY.."1")
end
]]
function edang.deleteCache()
  XCache.delete(CACHE_APPLIST)
  XCache.delete(CACHE_BANNER)
  XCache.delete(CACHE_CATEGORY)
  XCache.delete(CACHE_CONFIG_TIME)
end
--[[
edang.pb_apidata=function(callback,cachekey,url,rrdata)
  --print(url)
  storeapi.pb_apidata(callback,cachekey,url,rrdata,CACHE_CONFIG_TIME)
end
]]
edang_inner.pb_apidata=function(callback,cachekey,url,rrdata)
  --print(url)
  storeapi.pb_apidata(callback,cachekey,url,rrdata,CACHE_CONFIG_TIME)
end
--assert(edang_inner.pb_apidata)
function edang.applist(callback)
  edang_inner.pb_apidata(callback,CACHE_APPLIST,"https://gitee.com/genouka/edang-mirror/raw/main/server/app-list.json",
  function(info,data)
    --print(data)
    callback.onsuccess(info,json.decode(data).applist)
  end)
end
function edang.bannar(callback)
  edang_inner.pb_apidata(callback,CACHE_BANNER,"https://gitee.com/genouka/edang-mirror/raw/main/server/lbt.json",
  function(info,data)
    callback.onsuccess(info,json.decode(data))
  end)
end
function edang.category(callback)
  edang_inner.pb_apidata(callback,CACHE_CATEGORY,"https://gitee.com/genouka/edang-mirror/raw/main/server/Classification/category.json",
  function(info,data)
    callback.onsuccess(info,json.decode(data).categorylist)
  end)
end
function edang.search(keyword,callback)
  local function kIn(tbl, key)
    if tbl == nil then
      return {}
    end
    local rtbl={}
    for k, v in pairs(tbl) do
      local slist=luajava.astable(String(key).split(" "))
      for k1,v1 in pairs(slist) do
        if v1~=nil and v1~="" and string.find(v.name,".*"..v1..".*")~=nil then
          table.insert(rtbl,v)
          break
        end
      end
    end
    return rtbl
  end
  edang.applist({
    onerror=callback.onerror,
    onsuccess=function(info,i1)
      callback.onsuccess(info,kIn(i1,keyword))
    end
  })
end
--[[
function edang.search(callback)
  edang_inner.pb_apidata(callback,CACHE_CATEGORY,"https://gitee.com/genouka/edang-mirror/raw/main/server/Classification/category.json",
  function(info,data)
    callback.onsuccess(info,json.decode(data).categorylist)
  end)
end
]]
function edang.applistByCategroy(cid,callback)
  local function kIn(tbl, key)
    if tbl == nil then
      return {}
    end
    local rtbl={}
    for k, v in pairs(tbl) do
      if v.category==key then
        table.insert(rtbl,v)
      end
    end
    return rtbl
  end
  edang.applist({
    onerror=callback.onerror,
    onsuccess=function(info,i1)
      callback.onsuccess(info,kIn(i1,cid))
    end
  })
end
--[[
function edang.applist(callback)
  --print(edang.applist_cache)
  local function rdata(info,data)--持久化数据转table并回调
    callback.onsuccess(info,json.decode(data).applist)
  end
  if XCache[CACHE_APPLIST]==nil or XCache[CACHE_APPLIST]=="" then
    local temp
    temp={
      onerror=function(call,e)
        callback.onerror(-1,tostring(e))
      end,
      onsuccess=function(code,header,body)
        --local code,header,body=...
        --print(body)
        if code==200 then
          --edang.applist_cache=body
          XCache[CACHE_APPLIST]=body
          XCache.commit(CACHE_APPLIST)

          rdata({},body)
          return
        end
        callback.onerror(code,body)
      end
    }
    --print("net")
    --ZCLOG(storeapi)
    storeapi.innerpb("get","https://wannianqingshi.github.io/WatchAppStore/server/app-list.json",nil,temp)
   else
    --print("使用缓存")
    rdata({spec="cache"},XCache[CACHE_APPLIST])
  end
end
]]
--[[
function edang.banner(callback)
  --print(edang.applist_cache)
  if XCache[CACHE_BANNER]==nil or XCache[CACHE_BANNER]=="" then
    local temp=callback.onsuccess
    callback.onsuccess=function(code,header,body)
      --local code,header,body=...
      if code==200 then
        --edang.banner_cache=body
        XCache[CACHE_BANNER]=body
        XCache.commit(CACHE_BANNER)
      end
      temp(code,header,body)
    end
    storeapi.innerpb("get","https://wannianqingshi.github.io/WatchAppStore/server/lbt.json",nil,callback)
   else
    --print("使用缓存")
    callback.onsuccess(200,{spec="cache"},XCache[CACHE_BANNER])
  end
end
]]
return edang
--[[
附录：
@数据结构

应用列表：
{
  "applist": [
     {
      "name": "坚果天气",
      "url": "https://fel.forxhr.top:2022/down.php/b676a21d4d041b8b0e40ad1c9b767362.apk",
      "icon": "https://fel.forxhr.top:2022/view.php/ffc9bc9a46fa3d9a8d9df427463a153d.png",
      "version": "2.6",
      "author": "老豆荚团队",
      "description": "是由老豆荚应用分享团队开发的锤子天气第三方客户端原锤子天气官方外发版本现已停止服务为了让其他安卓用户能够继续体验到锤子天气我们开发了这款客户端",
      "cutphoto": "https://fel.forxhr.top:2022/view.php/aa05b2a24b189b469e107eb42e33cac3.png",
      "category": 6
    },
     {
      "name": "密匣",
      "url": "https://fel.forxhr.top:2022/down.php/0422180a72227a079b45cd1e1ffae54d.apk",
      "icon": "https://fel.forxhr.top:2022/view.php/ad58e5bcaea84a342bc784464ed8776c.jpg",
      "version": "1.0",
      "author": "小趣团队",
      "description": "通过悬浮窗权限覆盖手表UI退出锁定模式需要连续数次长按屏幕可用特定页面覆盖手表UI使手表无法进行操作从而应付各种场景",
      "cutphoto": "https://fel.forxhr.top:2022/view.php/2920ef46a7c8e4e4fcae0ed6f2772ed4.jpg",
      "category": 1
    },

轮播图：
[
  {
    "image": "https://fel.forxhr.top:2022/view.php/568315dc6b534cd5776c6b3ed32d6f26.png",
    "alt": "广告1"
  },
   {
    "image": "https://fel.forxhr.top:2022/view.php/b491c2810b0cbb11768e38ebbdeabac1.png",
    "alt": "广告2"
  },

分类：
{
  "categorylist": [
    {
      "name": "工具",
      "category": 1
    },
    {
      "name": "游戏",
      "category": 2
    },
]]