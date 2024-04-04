require "import"
paths=require "/common/paths"
local er,st=pcall(function()
  paths.load "/common/litter"
  paths.load "/apis/autoload"


  import "android.content.res.ColorStateList"
  import "android.graphics.Color"
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
item=paths.view("item1")
assert(item)
data={}
function refresh_list()
  data={
    {
      img={
        --ImageBitmap= getDrawableEx(R.drawable.ic_arrow_back_circle);
        --ImageTintList=ColorStateList.valueOf(Color.parseColor("#ffffff"));
      };
      title={
        text="< 设置";
        --textSize=30;
      };
      specaction="back";
    },
    {
      title="删除所有数据源缓存";
      author="默认缓存时间为10分钟";
      i=function()
        storeapi("edang").deleteCache()
        storeapi("rare").deleteCache()
        --os.remove(activity.getCacheDir().toString().."/applist.cache")
        print("已清理")
      end
    },

    {
      title="删除图片缓存";
      i=function()
        os.remove(activity.getExternalCacheDir().toString())
        print("已清理")

      end
    },
    {
      title="更换数据源";
      author=(function()
        local t=(XConfig["source"] or "edang")
        return "当前使用源："..t
      end)();
      i=function()
        local items={
          "🍀易档国外源(edang)","🔥易档镜像源(edang_mirror)","🌸Rare商店源(rare)","🌈莘应用新源(xin)"
        }
        AlertDialog.Builder(this)
        .setTitle("选择数据源")
        .setItems(items,{onClick=function(l,v)
            local tt
            switch(v)
             case 0 tt="edang"
             case 1 tt="edang_mirror"
             case 2 tt="rare"
             case 3
              print("打咩，这个源还暂不可用！")
              tt="edang_mirror"
             default tt="edang"
            end
            --print(tt)
            XConfig["source"]=tt
            XConfig.commit("source")
            refresh_list()
        end})
        .show()
      end
    },
    {
      title="设置安装方式";
      author=(function()
        local t=(XConfig["install"] or "1")
        return "当前安装方式编号："..t
      end)();
      i=function()
        local items={
          [[1.Android安装方式
(Android手表)]],
          [[2.RareBox安装方式
(WearOS2手表/华为手表)]],
          [[3.Amarket终端安装方式
(WearOS2/3/4手表)]],
          [[4.测试安装方式1
(特殊型号手表)]]
        }
        AlertDialog.Builder(this)
        .setTitle("设置安装方式")
        .setItems(items,{onClick=function(l,v)
            local tt
            switch(v)
             case 0 tt="1"
             case 1 tt="2"
             case 2 tt="3"
             case 3 tt="4"
             default tt="1"
            end
            --print(tt)
            XConfig["install"]=tt
            XConfig.commit("install")
            refresh_list()
        end})
        .show()
      end
    },
    {
      title="关于";
      i=function()
        activity.newActivity("activitys/about")
      end
    },
    {
      title="安装包储存路径";
      author=XConfig["downpath"];
      i=function()
        local items={
          [[修改]],
          [[恢复默认路径]]
        }
        AlertDialog.Builder(this)
        .setTitle("设置路径")
        .setItems(items,{onClick=function(l,v)
            local tt
            switch(v)
             case 0
              local File=luajava.bindClass("java.io.File")
              local path=XConfig["downpath"]
              if !File(path).exists() then path="/sdcard" end
              选择路径(path,function(p)
                print(p)
              end)
             case 1

            end
        end})
        .show()
        --refresh_list()
      end
    },
    {
      title="上传应用";
      author="将跳转至莘应用开发者平台";
      i=function()
        打开网页("https://rare.genouka.rr.nu/xindeveloper")
      end
    },
    {
      title="授予储存权限";
      author="储存权限用来保存下载的安装包";
      i=function()
        requestFilePermission()
      end
    },
    {
      title="授予安装未知应用权限";
      author="部分手表点击这个会导致系统假死，如果遇到了请重启！";
      i=function()
        弹出安装应用授权框(6)
      end
    },
    --[[
    {
      title="[调试]下载和安装功能";
      i=function()
        activity.newActivity("activitys/test")
      end
    },
]]
    --[[
    {
      title="[调试]破坏FMT机制";
      i=function()
        xpcall(function()
          paths.load "/private/password"
          broken_fmt()
        end,
        function()
          print("本功能仅调试版本可用")
        end)
      end
    },
]]
  }
  list_adapter=LuaAdapter(activity,data,item)
  list.Adapter=list_adapter

end
refresh_list()
list.onItemClick=function(p,v,i,s)
  local n=data[i+1]
  if n.specaction=="back" then
    activity.finish()
   else
    n.i()
    --activity.newActivity("activitys/detail",{n})
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
--assert(nil)