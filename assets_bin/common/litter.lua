--美名其曰垃圾堆代码
require "import"
--导入常用的代码包
import "com.androlua.Http"
import "android.os.Build"
import "android.content.res.ColorStateList"
import "android.graphics.Color"
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
import "android.app.AlertDialog"
import "android.content.Context"
import "android.content.Intent"
import "android.content.pm.PackageManager"
import "android.graphics.Bitmap"
import "android.Manifest"
import "android.net.Uri"
import "android.provider.Settings"
import "java.io.File"
import "java.io.FileOutputStream"
import "android.Manifest"
import "android.graphics.drawable.DrawableWrapper"
import "android.content.ComponentName"
import "android.support.v4.app.ActivityCompat"

json = require('cjson')

function ZCLOG(Lua_table)
  -- do
  --     return
  -- end
  local function define_print(_tab,str)
    str = str .. "  "
    for k,v in pairs(_tab) do
      if type(v) == "table" then
        if not tonumber(k) then
          print(str.. k .."{")
         else
          print(str .."{")
        end
        define_print(v,str)
        print( str.."}")
       else
        print(str .. tostring(k) .. " " .. tostring(v))
      end
    end
  end
  if type(Lua_table) == "table" then
    define_print(Lua_table," ")
   else
    print(tostring(Lua_table))
  end
end

function 打开程序(packageName)
  pcall(function()
    import "android.content.Intent"
    import "android.content.pm.PackageManager"
    local manager = activity.getPackageManager()
    local open = manager.getLaunchIntentForPackage(packageName)
    this.startActivity(open)
  end)
end

function 启动应用(名称)
  for jdpuk in each(this.packageManager.getInstalledApplications(0))do
    if 名称==this.packageManager.getApplicationLabel(jdpuk)then
      this.startActivity(this.packageManager.getLaunchIntentForPackage(jdpuk.packageName))
      return
    end
  end
end

function 打开网页(url)
  activity.runOnUiThread(function()
    import "android.content.Intent"
    import "android.net.Uri"
    local viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
    activity.startActivity(viewIntent)
  end)
end

--配置调用系统安装文件包方式
----------------------------------
function 调用系统安装文件包(file_path)
  import "android.webkit.MimeTypeMap"
  import "android.content.Intent"
  import "android.net.Uri"
  import "java.io.File"
  local FileName=tostring(File(file_path).Name)
  local ExtensionName=FileName:match(".+%.(%w+)$")
  local Mime=MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
  if Mime then
    local intent = Intent();
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.setAction(Intent.ACTION_VIEW);
    intent.setDataAndType(Uri.fromFile(File(file_path)), Mime);
    activity.startActivity(intent);
   else
    print("找不到可以用来打开此文件的程序")
  end
end

--配置选择跳转安装文件包方式
----------------------------------
function 安装应用(apk_path)
  if Build.VERSION.SDK_INT <=23 then
    调用系统安装文件包(apk_path)
   else
    xpcall(function()
      activity.installApk(apk_path)
    end,
    function(e)
      调用系统安装文件包(apk_path)
    end)
  end
end

function sha1(msg)
  local MessageDigest=import "java.security.MessageDigest";
  local b= MessageDigest.getInstance("SHA-256").digest(msg)
  local hs = "";
  local stmp = "";
  for n = 0,#b-1,1 do
    stmp = (Integer.toHexString(b[n] & 0XFF));
    if (#stmp == 1) then
      hs = hs .. "0" .. stmp;
     else
      hs = hs .. stmp;
    end
  end
  return hs
end

function copyfile(path1,path2)
  local file = File(tostring(path2))
  file.getParentFile().mkdirs()
  LuaUtil.copyDir(File(path1),file)
end

function ToStringEx(value)
  if type(value)=='table' then
    return TableToStr(value)
   elseif type(value)=='string' then
    return "\'"..value.."\'"
   else
    return tostring(value)
  end
end

--序列化支持器
function TableToStr(t)
  if t == nil then return "" end
  local retstr= "{"

  local i = 1
  for key,value in pairs(t) do
    local signal = ","
    if i==1 then
      signal = ""
    end

    if key == i then
      retstr = retstr..signal..ToStringEx(value)
     else
      if type(key)=='number' or type(key) == 'string' then
        retstr = retstr..signal..'['..ToStringEx(key).."]="..ToStringEx(value)
       else
        if type(key)=='userdata' then
          retstr = retstr..signal.."*s"..TableToStr(getmetatable(key)).."*e".."="..ToStringEx(value)
         else
          retstr = retstr..signal..key.."="..ToStringEx(value)
        end
      end
    end

    i = i+1
  end

  retstr = retstr.."}"
  return retstr
end

function StrToTable(str)
  if str == nil or type(str) ~= "string" then
    return
  end

  return loadstring("return " .. str)()
end

--测试结果
--[[
local t1 = {A=1, B={1, b="strBb", {x='strB2x', y=0.1} } }
print(t1.B[2].x)
-- strB2x

local str1 = TableToStr(t1)
print(str1)
-- {['A']=1,['B']={1,{['y']=0.1,['x']='strB2x'},['b']='strBb'}}

local t2 = StrToTable(str1)
print(t2['B'][2].x)
-- strB2x
]]

--时间戳转换为时间
function unix2Time(Unix)
  --从时间戳获取时间表
  local time_table = os.date("*t", Unix)
  --构造时间字符串
  local time = string.format("%02d-%02d %02d:%02d"--[[,time_table.year]], time_table.month, time_table.day,time_table.hour, time_table.min)
  --返回时间字符串
  return time
end

function 保存图片(name,bm)
  if bm then
    name=tostring(name)
    local f = File(name)
    local out = FileOutputStream(f)
    bm.compress(Bitmap.CompressFormat.PNG,90, out)
    out.flush()
    out.close()
    return true
   else
    return false
  end
end

function 禁止截图()
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE)
end

function 截图(截图目录,截图文件名)
  local 截图控件=activity.getDecorView()
  截图控件.setDrawingCacheEnabled(false)
  截图控件.setDrawingCacheEnabled(true)
  截图控件.destroyDrawingCache()
  截图控件.buildDrawingCache()
  local drawingCache=截图控件.getDrawingCache()
  if drawingCache==nil then
    print("截图失败")
   else
    local bitmap=Bitmap.createBitmap(drawingCache)
    local directory=File(截图目录)
    if not directory.exists() then
      directory.mkdirs()
    end
    local file=File(截图目录,截图文件名)
    local fileOutputStream=FileOutputStream(file)
    bitmap.compress(Bitmap.CompressFormat.JPEG,100,fileOutputStream)
    local intent=Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
    intent.setData(Uri.fromFile(file))
    activity.sendBroadcast(intent)
    print("已保存到 "..截图目录.."/"..截图文件名)
  end
end

function 选择路径(StartPath,callback)
  --local File=luajava.bindClass("java.io.File")
  local lv=ListView(activity).setFastScrollEnabled(true)
  local cp=TextView(activity)
  local lay=LinearLayout(activity).setOrientation(1).addView(cp).addView(lv)
  local ls
  local ChoiceFile_dialog=AlertDialog.Builder(activity)
  .setTitle("选择路径")
  .setPositiveButton("确定",{
    onClick=function()
      callback(tostring(cp.Text))
  end})
  .setNegativeButton("取消",nil)
  .setView(lay)
  .show()
  local adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1)
  lv.setAdapter(adp)
  function SetItem(path)
    path=tostring(path)
    adp.clear()
    cp.Text=tostring(path)
    if path~="/" then
      adp.add("../")
    end
    ls=File(path).listFiles()
    if ls~=nil then
      ls=luajava.astable(File(path).listFiles())
      table.sort(ls,function(a,b)
        return (a.isDirectory()~=b.isDirectory() and a.isDirectory()) or ((a.isDirectory()==b.isDirectory()) and a.Name<b.Name)
      end)
     else
      ls={}
    end
    for index,c in ipairs(ls) do
      if c.isDirectory() then
        adp.add(c.Name.."/")
      end
    end
  end
  lv.onItemClick=function(l,v,p,s)
    local 项目=tostring(v.Text)
    local 路径
    if tostring(cp.Text)=="/" then
      路径=ls[p+1]
     else
      路径=ls[p]
    end

    if 项目=="../" then
      SetItem(File(cp.Text).getParentFile())
     elseif 路径.isDirectory() then
      SetItem(路径)
     elseif 路径.isFile() then
      callback(tostring(路径))
      ChoiceFile_dialog.hide()
    end
  end
  SetItem(StartPath)
end

function 检测键盘()
  local imm = activity.getSystemService(Context.INPUT_METHOD_SERVICE)
  local isOpen=imm.isActive()
  return isOpen==true or false
end
function 隐藏键盘()
  activity.getSystemService(INPUT_METHOD_SERVICE).hideSoftInputFromWindow(WidgetSearchActivity.this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS)
end
function 显示键盘(id)
  activity.getSystemService(INPUT_METHOD_SERVICE).showSoftInput(id, 0)
end

function checkReadWritePermissions()
  --local Intent=luajava.bindClass "android.content.Intent"
  --local PackageManager=luajava.bindClass "android.content.pm.PackageManager"
  local writePermission = "android.permission.WRITE_EXTERNAL_STORAGE"
  local readPermission = "android.permission.READ_EXTERNAL_STORAGE"
  local writeGranted = activity.checkSelfPermission(writePermission)
  local readGranted = activity.checkSelfPermission(readPermission)
  return writeGranted == PackageManager.PERMISSION_GRANTED and readGranted == PackageManager.PERMISSION_GRANTED
end

function requestFilePermission()
  if checkReadWritePermissions() then return end
  --local ActivityCompat=luajava.bindClass "android.support.v4.app.ActivityCompat"
  --local Manifest=luajava.bindClass "android.Manifest"
  local requestCode = 50000 -- 你可以定义其他值，确保唯一性
  print("未授予储存权限!如果没有弹出授权框请前往系统设置启用!")
  ActivityCompat.requestPermissions(activity, {
    Manifest.permission.WRITE_EXTERNAL_STORAGE,
    Manifest.permission.READ_EXTERNAL_STORAGE
  }, requestCode)
end
function buildButtonEx(name,color,func)
  return {
    CardView;
    layout_width='fill';--卡片宽度
    layout_height='48dp';--卡片高度
    cardBackgroundColor=color or '#d7c4bb';--卡片颜色
    layout_marginTop='5dp';--布局顶距
    layout_marginLeft='15dp';--布局左距
    layout_marginRight='15dp';--布局左距
    layout_margin='0dp';--卡片边距
    cardElevation='0dp';--卡片阴影
    radius='15dp';--卡片圆角
    onClick=func;
    {
      FrameLayout;
      layout_width='fill';--控件宽度
      layout_height='fill';--控件高度
      {
        TextView;--文本控件
        layout_width='fill';--控件宽度
        layout_height='fill';--控件高度
        text=name;--显示文字
        textSize='24sp';--文字大小
        textColor='#000000';--文字颜色
        --Typeface=Typeface.DEFAULT;--字体
        gravity='center';--重力
        layout_marginTop="3dp";
      };
      {
        TextView;--文本控件
        layout_width='fill';--控件宽度
        layout_height='fill';--控件高度
        text=name;--显示文字
        textSize='24sp';--文字大小
        textColor='#ffffff';--文字颜色
        --Typeface=Typeface.DEFAULT;--字体
        gravity='center';--重力
      };
    };
  };
end

function md5(data)
  import "java.security.MessageDigest"
  local md=MessageDigest.getInstance("MD5")
  local bytes=md.digest(String(data).getBytes())
  local result=""
  for i=0,#bytes-1 do
    local temp = string.format("%02x",(bytes[i]&0xff))
    result=result..temp
  end
  return result
end

function nonilset(a,func)
  if a!=nil then func(a) end
end

function 打开应用(id)
  local packageName=id
  import "android.content.Intent"
  import "android.content.pm.PackageManager"
  local manager = activity.getPackageManager()
  local open = manager.getLaunchIntentForPackage(packageName)
  activity.startActivity(open)
end

function 卸载应用(packagename)
  import "android.net.Uri"
  import "android.content.Intent"
  local 包名=packagename
  local uri = Uri.parse("package:"..包名)
  local intent = Intent(Intent.ACTION_DELETE,uri)
  activity.startActivity(intent)
end
function 弹出安装应用授权框(code)
  pcall(function()
    import "android.content.Intent"
    import "android.provider.Settings"
    import "android.net.Uri"
    local intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES);
    intent.setData(Uri.parse("package:" .. activity.getPackageName()));
    activity.startActivityForResult(intent, code or 0);
  end)
end
function 授权安装应用(path,code)
  import "android.content.Intent"
  import "android.os.Build"

  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) then
    if (!activity.getPackageManager().canRequestPackageInstalls()) then
      -- 弹出系统对话框，询问用户是否允许安装应用权限
      xpcall(function()
        弹出安装应用授权框(code)
      end,
      function(e)
        print("[警告]未知来源未启用，可能无法正常安装。\n如果没有遇到此问题请忽略")
        安装应用(path);
      end)
     else
      -- 已经有安装应用权限，可以直接安装应用
      安装应用(path);
    end
   else
    -- 安装应用权限不需要申请，可以直接安装应用
    安装应用(path);
  end
end