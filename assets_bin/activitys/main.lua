require "import"
g__config=require "/config/global"
paths=require "/common/paths"
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
  --布局使用
  import "android.graphics.BitmapFactory"
  import "android.graphics.Typeface"
  --引入R
  paths.load "/common/packen"
  --storeapi
  paths.load "/apis/autoload"
  --
  paths.load "/config/xconfig"
  paths.load "/common/update"
end)
if !er then
  err="[02]模块加载错误\n"..st
  paths.error()
  return
end
pcall(function()
  activity.ActionBar.hide()
end)
if paths.setContentView("main") then
  return
end
--LuaBitmap.setCacheTime(1)
--"https://s1.imgbed.xyz/2023/02/25/IF5Lh.jpg"
--banner1.setBitmapImage(getDrawableEx())
imagelength=0
--do return end
function autoshowimages()
  pcall(function()
    task(3200,function()
      pcall(function()
        if activity==nil or banner1==nil then return end
        banner1.showPage((banner1.getCurrentItem()+1)%imagelength)
        autoshowimages()
      end)
    end)
  end)
end
--轮播图
xpcall(function()
  storeapi("edang_mirror").bannar({
    onerror=function(code,msg)
      print("["..code.."]网络错误")
    end,
    onsuccess=function(info,i1)
      --ZCLOG(data)
      --local i1=data1
      --data1=nil
      --local df=SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
      --ZCLOG(i1)
      local data={}
      for i=1,#i1 do
        local i1i=i1[i]
        --ZCLOG(i1i)
        local layout={
          LinearLayout;
          layout_height="25%h";
          layout_width="fill";
          orientation="vertical";
          {
            CardView;--卡片控件
            layout_margin='5%w';--卡片边距
            layout_gravity='center';--重力属性
            Elevation='0dp';--阴影属性
            layout_width='93%w';--卡片宽度
            layout_height='fill';--卡片高度
            radius='35';--卡片圆角
            id="cd1";
            {
              ImageView;
              scaleType="fitXY";
              src=tostring(i1i.image);
              layout_width="match_parent";
              layout_height="match_parent";
            };
          };
        };
        data[#data+1]=loadlayout(layout)
      end
      imagelength=#data
      --ZCLOG(data)
      activity.runOnUiThread(function()
        bannerparent.addView(loadlayout({
          PageView;
          --ViewPager;
          id="banner1";
          layout_width="fill";
          layout_height="wrap";
          pages=data;
        }))
        if XConfig['autolbt']!=false then
          autoshowimages()
        end
        --banner1.pages=data
      end)
      --loadbitmapAsync()
    end
  })
end,
function(e)
  print("发生偶发性错误：轮播图加载失败。\n您无需在意该错误，不影响使用。")
end)