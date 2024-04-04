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
if paths.setContentView("search") then return end

function nextbtn.onClick()
  activity.newActivity("activitys/applist",Object{"search",String(keytext.text)})
end