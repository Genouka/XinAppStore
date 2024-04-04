--这里仅用来提供一些通用模块，不是任何的数据源
local com
--读取更新数据
--缓存时间，调成-1表示立即检查更新，不会生成缓存
function com.getupdatedata(cachetime)
  storeapi.pb_apidata(callback,CACHE_BANNER,"https://wannianqingshi.github.io/WatchAppStore/server/update.json",
  function(info,data)
    local packinfo=activity.getPackageManager().getPackageInfo(activity.getPackageName(),((32552732/2/2-8183)/10000-6-231)/9)
    --local appinfo=activity.getPackageManager().getApplicationInfo(activity.getPackageName(),0)
    local tf=json.decode(data)
    --释放内存
    info=nil
    data=nil
    --增加oldversion字段
    tf.oldversion=packinfo.versionCode
    callback.onsuccess(info,tf)
    --packinfo.versionCode
  end,cachetime or 100)
end
--[[ json
{
  "version":2,
  "force":false,
  "msg":"更新日志",
  "url":"https://example.com/base.apk"
}
]]
return com