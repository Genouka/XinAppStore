require "import"
paths=require "/common/paths"
if type(paths)!="table" then
  activity.recreate()
  return
end
local er,st=pcall(function()
  paths.load "/common/litter"
  --paths.load "bili/api/recommand"
  import "android.app.*"
  import "android.os.*"
  import "android.widget.*"
  import "android.view.*"
  import "java.text.SimpleDateFormat"
  import "java.util.Date"
  import "android.text.SpannableStringBuilder"
  import "java.lang.CharSequence"
  import "com.github.gzuliyujiang.toolkit.TextSpanBuilder"
  import "com.github.gzuliyujiang.span.*"
  --import "java.lang.Long"
  paths.load "/common/packen"
  paths.load "/common/downsupt"
  paths.load "/config/xconfig"
  paths.load "/common/install4"
end)
if !er then
  err="[02]模块加载错误\n"..st
  paths.error()
  return
end
pcall(function()
  activity.ActionBar.hide()
end)
arg1,arg2=...
assert(arg1)--arg1必须存在
if paths.setContentView("detail") then
  print("发生偶发性错误")
  activity.finish()
  return
end

loadbitmapAsync(icon,arg1.intend.icon)
loadbitmapAsync(imgcut,arg1.intend.cutphoto)
--imgcut.setImageBitmap(loadbitmap(arg1.intend.cutphoto))
content.text=(
TextSpanBuilder.create("详情：\n")
.append("名称")
.span(RoundBgColorSpan(0xff3a8fb7, 0xFFFFFFFF, 20))
.append((arg1.intend.name or "").."\n")
.append("开发者/上传者")
.span(RoundBgColorSpan(0xff3a8fb7, 0xFFFFFFFF, 20))
.append((arg1.intend.author or "").."\n")
.append("版本号")
.span(RoundBgColorSpan(0xff3a8fb7, 0xFFFFFFFF, 20))
.append((arg1.intend.version or "").."\n")
.append("描述")
.span(RoundBgColorSpan(0xff3a8fb7, 0xFFFFFFFF, 20))
.append((arg1.intend.description or "").."\n\n")
.append("注意")
.span(RoundBgColorSpan(0xffff0000, 0xFFFFFFFF, 20))
.append("大部分资源为用户上传，务必自行分辨应用的可用性和安全性~")
--[[
.click(luajava.override(ClickableSpan,{
  onClick=function(superCall,v)
    print("https://bilibili.com/"..arg1.bvid)
  end
}))
]]
--[[
.append("测试："..arg1.intend.icon)
--]]
.build()
) or "详情加载失败，可以返回重进再试"
isDownloadOk=false;--是否下载完成
filePath=nil;--下载完后的文件路径
function InstallByRareBox3_3(filepath)
  local i = Intent();
  local cn = ComponentName("com.yuanwow.adb",
  "com.yuanwow.adb.InstallerActivity");
  i.setComponent(cn);
  i.setAction("android.intent.action.VIEW");
  i.setData(Uri.parse(filepath))
  activity.startActivity(i)
end
function InstallByRareBox(filepath)
  xpcall(function() InstallByRareBox3_3(filepath) end,
  function(e)
    local AlertDialog=luajava.bindClass("android.app.AlertDialog")
    local ClipData=luajava.bindClass( "android.content.ClipData")
    local Context=luajava.bindClass( "android.content.Context")
    local Toast=luajava.bindClass( "android.widget.Toast")
    local cm = activity.getSystemService(Context.CLIPBOARD_SERVICE)
    local mClipData = ClipData.newPlainText("Label", filepath)
    cm.setPrimaryClip(mClipData)
    Toast.makeText(activity, "已将文件路径复制到剪贴板，请在RareBox中安装！", Toast.LENGTH_LONG).show()
    xpcall(function()
      local packageManager = activity.getPackageManager()
      local it = packageManager.getLaunchIntentForPackage("com.yuanwow.adb")
      activity.startActivity(it)
    end,
    function()
      local t=AlertDialog.Builder(activity)
      t.setTitle("警告")
      t.setMessage("您的手表未安装RareBox，请前往Rare计划官网获得软件：rare.genouka.rr.nu")
      t.setPositiveButton("确定",nil)
      t.create().show()
    end)
  end)
end
function InstallByAmarket(filepath)
  local AlertDialog=luajava.bindClass("android.app.AlertDialog")
  local ClipData=luajava.bindClass( "android.content.ClipData")
  local Context=luajava.bindClass( "android.content.Context")
  local Toast=luajava.bindClass( "android.widget.Toast")
  local cm = activity.getSystemService(Context.CLIPBOARD_SERVICE)
  local mClipData = ClipData.newPlainText("Label", filepath)
  cm.setPrimaryClip(mClipData)
  Toast.makeText(activity, "已将命令复制到剪贴板，请在Amarket终端中安装！", Toast.LENGTH_LONG).show()
  xpcall(function()
    local packageManager = activity.getPackageManager()
    local it = packageManager.getLaunchIntentForPackage("com.github.wearmex.amarket")
    activity.startActivity(it)
  end,
  function()
    local t=AlertDialog.Builder(activity)
    t.setTitle("警告")
    t.setMessage("您的手表未安装Amarket，请更换安装方式")
    t.setPositiveButton("确定",nil)
    t.create().show()
  end)
end
function InstallForHwchild(filepath)
  local AlertDialog=luajava.bindClass("android.app.AlertDialog")
  local ClipData=luajava.bindClass( "android.content.ClipData")
  local Context=luajava.bindClass( "android.content.Context")
  local Toast=luajava.bindClass( "android.widget.Toast")
  compiler(filepath,filepath..".xinstore_signed.apk",{
    onsuccess=function(a,b)
      activity.runOnUiThread(function()
        local t=AlertDialog.Builder(activity)
        t.setTitle("成功")
        t.setMessage("签名成功，已保存至"..filepath..".xinstore_signed.apk")
        t.setPositiveButton("确定",nil)
        t.create().show()
        授权安装应用(filepath..".xinstore_signed.apk")
      end)
    end,
    onerror=function(a,b)
      activity.runOnUiThread(function()
        local t=AlertDialog.Builder(activity)
        t.setTitle("错误")
        t.setMessage("签名失败\n原因："..b)
        t.setPositiveButton("确定",nil)
        t.create().show()
      end)
    end
  })
end
function installapp(f)
  local t=XConfig["install"] or "1"
  if t=="1" then
    授权安装应用(f)
   elseif t=="2" then
    InstallByRareBox(f)
   elseif t=="3" then
    InstallByAmarket(f)
   elseif t=="4" then
    InstallForHwchild(f)
  end
end

progressbar.setMax(100)
function updateProgress(a,b)
  progressbar.post(function()
    progressbar.setProgress(tointeger(a*100//b))
  end)
end
function install.onClick(v)
  if !checkReadWritePermissions() then
    requestFilePermission()
    return
  end
  if !isDownloadOk then
    v.Enabled=false
    v.text="正在连接服务器"
    --downloadEx
    --ZCLOG(arg1)

    local gp2=0
    local gpl=0
    downloadEx(arg1.intend.url,{
      onstart=function(task,info,cause)
        gpl=info.getTotalLength()

      end,
      onsuccess=function(f,d,ec,ex)
        filePath=f
        isDownloadOk=true
        v.Enabled=true
        v.text="安装"
        installapp(f,666)
      end,
      onerror=function(d,ec,dx)
        v.text="下载失败！点击重试\n"..tostring(dx)
        v.Enabled=true
      end,
      onprogress=function (d,p1,p2)
        gp2=gp2+p2
        v.text="正在下载:"..gp2.."/"..gpl
        updateProgress(gp2,gpl)
      end
    })
   else
    installapp(filePath)
  end
end
--test.text=""..arg1.bvid