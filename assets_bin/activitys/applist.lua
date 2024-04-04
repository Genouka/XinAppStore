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

a_type,a_content=...
--[[
a_type
 applist
 search
 category
]]

--ZCLOG(activityArgs)
item=paths.view("item")
assert(item)
data={}
data_title={
  img={
    ImageBitmap=decodeBitmapFromResource(R.drawable.ic_arrow_back_circle--[[,function(d,b)
      --[-[
      local filter = PorterDuffColorFilter(0xffffffff, PorterDuff.Mode.SRC_IN);
      local paint = Paint();
      paint.setColorFilter(filter);
      local canvas = Canvas(b);
      canvas.drawBitmap(b, 0, 0, paint);
      d.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
      d.draw(canvas);
]
      local canvas = Canvas(b);
      d.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
      d.draw(canvas);
      local width=b.getWidth();
      local height=b.getHeight();
      local newBmp=b.copy(b.getConfig(),true);
      for i=0,width-1 do
        --ttt=""
        for j=0,height-1 do
          --遍历原图的所有像素
          local srcColor=b.getPixel(i,j);
          --ttt=ttt..srcColor
          if srcColor~=0 then
            --print(srcColor)
            --非透明像素全部设置为指定配色
            newBmp.setPixel(i,j,0xffffff);
          end
        end
        --print(ttt)
      end
      return newBmp
    end);]]);
    --ImageTintList=ColorStateList.valueOf(Color.parseColor("#ffffff"));
  };
  title={
    text="应用列表";
    --textSize=30;
  };
  author="";
  specaction="back";
}
list_adapter=LuaAdapter(activity,item)
--list_adapter.setNotifyOnChange(false)
list.Adapter=list_adapter
list_adapter.add(data_title)
data[1]=data_title
function loadnewcmd(callback)
  --require "import"
  --paths=require "/common/paths"
  --paths.load "/common/litter"
  --paths.load "/apis/autoload"
  storeapi.from(XConfig["source"])
  local kapi="applist"
  if a_type=="search" then
    kapi="search"
   elseif a_type=="category" then
    kapi="applistByCategroy"
  end
  --print(kapi)
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
        --iit.ImageTintList=;--ColorStateList.valueOf(Color.parseColor("#00000000"))
        pcall(function()
          if i1i.icon==nil or i1i.icon=="" or i1i.icon=="none" then
            iit.ImageBitmap=getDrawableEx(R.drawable.ic_launcher);
           else
            iit.src=i1i.icon;
          end
        end)
        local ldata={
          img=iit,
          title={
            text=TextSpanBuilder.create(i1i.name or "[Error]")
            .append(i1i.version or "[Error]")
            .span(RoundBgColorSpan(0xff5dac81, 0xFFFFFFFF, 20))
            .build();
            --textSize=12;
            --ImageTintList=false;
          },
          --[[
          extra={
            text=TextSpanBuilder.create("来源")
            .span(RoundBgColorSpan(0xff5dac81, 0xFFFFFFFF, 20))
            .append(("用户上传"))
            .build()
            --""
          },
]]
          author=i1i.author or "[Error]",
          --仅用于传递数据
          intend=i1i,
        }
        --list_adapter.add(ldata)
        data[#data+1]=(ldata)
      end

      activity.runOnUiThread(function()
        --list_adapter.clear()
        list_adapter.remove(0)
        list_adapter.addAll(data)
        list_adapter.notifyDataSetChanged()
        --table.insert(data,1,data_title);
        if callback~=nil then callback() end
      end)
    end
  })

  if kapi=="applist" then
    storeapi.applist(callback1)
   elseif kapi=="search" then
    --print("搜索："..a_content)
    storeapi.search(a_content,callback1)
   elseif kapi=="applistByCategroy" then
    --print("搜索："..a_content)
    storeapi.applistByCategroy(a_content,callback1)
  end
end
list.onItemClick=function(p,v,i,s)
  local n=data[i+1]
  if n.specaction=="back" then
    activity.finish()
   else
    --修复图片替换无法打开
    n.img=nil
    activity.newActivity("activitys/detail",{n})
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
xpcall(function()
  loadnewcmd()
end
,function(e)
  print(e)
  activity.finish()
end)
--assert(nil)