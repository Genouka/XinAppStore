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
  paths.load "/config/xconfig"
end)
if !er then
  err="[02]模块加载错误\n"..st
  paths.error()
  return
end
pcall(function()
  activity.ActionBar.hide()
end)
if paths.setContentView("layout") then return end
item=paths.view("item")
assert(item)
data={}
data[1]={
  img={
    ImageBitmap= getDrawableEx(R.drawable.ic_arrow_back_circle);
    --ImageTintList=ColorStateList.valueOf(Color.parseColor("#ffffff"));
  };
  title={
    text="分类";
    --textSize=30;
  };
  specaction="back";
}
function loadnewcmd(callback)
  --require "import"
  --paths=require "/common/paths"
  --paths.load "/common/litter"
  --paths.load "/apis/autoload"
  storeapi.from(XConfig["source"])
  local callback1=({
    onerror=function(code,msg)
      print("网络错误"..msg)
    end,
    onsuccess=function(info,i1)
      --ZCLOG(data)
      --local i1=data1
      --data1=nil
      --local df=SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
      --print(i1)
      --print("receive")
      for i=1,#i1 do
        local i1i=i1[i]
        --ZCLOG(i1i)
        local iit={}
        data[#data+1]={
          img=iit,
          title={
            text=i1i.name
          },
          --仅用于传递数据
          intend=i1i,
        }
      end

      activity.runOnUiThread(function()
        --list_adapter.clear()
        list_adapter.addAll(data)
        if callback~=nil then callback() end
      end)
    end
  })
  storeapi.category(callback1)
end
list_adapter=LuaAdapter(activity,item)
list.Adapter=list_adapter
list.onItemClick=function(p,v,i,s)
  local n=data[i+1]
  if n.specaction=="back" then
    activity.finish()
   else
    activity.newActivity("activitys/applist",Object{"category",tointeger(n.intend.category)})
  end
end
刷新.onLoadMore=function(v)
  --[[
  loadnewcmd(function()
    v.loadmoreFinish(0)
  end)
  ]]
  v.loadmoreFinish(2)
end
loadnewcmd()
--assert(nil)