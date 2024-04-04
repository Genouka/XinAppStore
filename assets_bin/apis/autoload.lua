require "import"
import "okhttp3.*"
paths=require "/common/paths"

--缓存器
--[[
Genouka
写入
XCache["key"]="a"
XCache.commit("key")
读取
print(XCache["key"])
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
--Unit Test
--XCache["aa"]=11
--XCache["aa"]=2
--print(XCache["aa"])
if storeapi==nil then
  storeapi={}
  do--会被dofile,这里进行作用域隔离
    local sai={}

    local meta={
      __index=function(tab,key)
        return sai[key]
      end,
      __call=function(tab,args)
        if args!=nil then
          return require("/apis/"..args.."/"..args)
         else
          return require("/apis/comfig")
        end
      end
    }
    --切换数据源（比如edang）
    function sai.from(name)
      --local temp=storeapi.from
      --storeapi=require("/apis/"..name.."/"..name)
      --storeapi.from=temp
      storeapi=setmetatable(require("/apis/"..name.."/"..name),meta)
    end
    --内部公用发送数据类
    --[[
method 方法 str get/post/put/post/download/onlyheader
url 网址 str
data 数据 str/nil
callback 回调 table
cookie Cookie数据 str/nil
r1 Okhttp加工器 func
]]
    function sai.innerpb(method,url,data,callback,cookie,r1)
      local requestBody
      if data~=nil then
        local updata=json.encode(data)
        --print(url..updata)
        requestBody = RequestBody.create(MediaType.parse("application/json; charset=utf-8"), updata);
      end
      --请求辅助类
      local request = Request.Builder()
      .url(url)
      if method=="put" then
        request=request.put(requestBody)
      end
      if method=="post" then
        request=request.post(requestBody)
      end
      request=request.build();

      --异步请求
      local okhttp = OkHttpClient().newBuilder()
      if r1~=nil then
        okhttp=r1(okhttp)
      end
      local okhttp=okhttp.build();
      local callx = okhttp.newCall(request);

      callx.enqueue(Callback{
        onFailure=function(call,e)
          --activity.runOnUiThread(function()
          callback.onerror(call,e)
          --end)
        end,

        onResponse=function(call,response)
          local code=response.code()
          local header=response.headers()
          local body
          if method=="download" then
            body=response.body().bytes()
           else
            if method=="onlyheader" then
             else
              body=response.body().string()
            end
          end
          --print(code..body)
          --activity.runOnUiThread(function()
          callback.onsuccess(code,header,body)
          --end)
        end
      })
    end
    --[[
比较常用的网络请求封装
例子：
--第一层封装
CACHE_KEY="cache111"
function a(callback)
  storeapi.pb_apidata(callback,CACHE_KEY,"http://url/api.json",
    function(info,data)
      callback.onsuccess(info,json.decode(data))
    end,100)
end
--调用层
a({
    onerror=function(code,msg)
      print("网络错误")
    end,
    onsuccess=function(info,i1)
      for i=1,#i1 do
        local i1i=i1[i]
        --ZCLOG(i1i)
        local iit={}
        pcall(function()
          if i1i.icon==nil or i1i.icon=="" or i1i.icon=="none" then
            iit.ImageBitmap=getDrawableEx(R.drawable.ic_launcher);
           else
            iit.src=i1i.icon;
          end
        end)
        data[#data+1]={
          img=iit,
          title={
            text=TextSpanBuilder.create(i1i.name)
            .append(i1i.version)
            .span(RoundBgColorSpan(0xff5dac81, 0xFFFFFFFF, 20))
            .build()
          },
          author=i1i.author,
          intend=i1i,
        }
      end

      activity.runOnUiThread(function()
        list_adapter.addAll(data)
        if callback!=nil then callback() end
      end)
    end
  })
注意：
cachekey是缓存键
url是请求地址
rrdata是返回结果预处理函数
CACHE_CONFIG_TIME是缓存时间的配置
cachetime缓存时间（单位：秒）
特别地：
nil 表示使用默认时间600s(10分钟)
0 表示每次都请求并缓存，会影响缓存间隔时间的判断
-1 表示每次都请求但不缓存，不影响缓存间隔时间的判断
视具体情况使用，为了方便可以二次封装！
]]
    function sai.pb_apidata(callback,cachekey,url,rrdata,CACHE_CONFIG_TIME,cachetime)
      --print(edang.applist_cache)
      xpcall(function()
        assert(url)
        assert(rrdata)
        assert(cachetime or cachekey)
        assert(callback)
        CACHE_CONFIG_TIME=CACHE_CONFIG_TIME or "storeapi_cache_time_config"
        local function rdata(info,data)--持久化数据转table并回调
          xpcall(function()
            rrdata(info,data)
          end,
          function(e)
            callback.onerror(-2,tostring(e))
          end)
          --callback.onsuccess(info,json.decode(data).applist)
        end
        local cc=(cachetime or 600)
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
                assert(type(cc)=="number")
                if cc>=0 then
                  assert(cachekey)
                  XCache[cachekey]=body
                  XCache.commit(cachekey)
                end
                rdata({},body)
                return
              end
              callback.onerror(code,body)
            end
          }
          --print("net")
          --ZCLOG(storeapi)
          storeapi.innerpb("get",url,nil,temp)
         else
          --print("使用缓存")
          assert(cachekey)
          rdata({spec="cache"},XCache[cachekey])
        end
      end,
      function(e)
        callback.onerror(-3,tostring(e))
      end)
    end
    storeapi=setmetatable(storeapi,meta)

  end
end
--[[
规范：
--应用列表
storeapi.applist(callback)
callback={
onsuccess=function() end
onerror=function() end
}
--轮播图
storeapi.banner(callback)
callback={
onsuccess=function() end
onerror=function() end
}
--删除缓存
storeapi.deleteCache()
]]