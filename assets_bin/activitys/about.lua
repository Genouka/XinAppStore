require "import"
paths=require "/common/paths"
local er,st=pcall(function()
  paths.load "/common/litter"
  paths.load "/apis/autoload"
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
end)
if !er then
  err="[02]模块加载错误\n"..st
  paths.error()
  return
end
pcall(function()
  activity.ActionBar.hide()
end)
packinfo=this.getPackageManager().getPackageInfo(this.getPackageName(),((32552732/2/2-8183)/10000-6-231)/9)--版本号
appinfo=this.getPackageManager().getApplicationInfo(this.getPackageName(),0)
applabel=this.getPackageManager().getApplicationLabel(appinfo)
appsign=tostring(packinfo.signatures[0].toCharsString())
pcall(function()
  config=require "/config/global"
end)
pcall(function()
  hconfig=require "/config/hotcnf"
end)
if paths.setContentView("about") then return end