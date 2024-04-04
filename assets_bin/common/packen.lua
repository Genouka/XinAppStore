--GenOuka 2024.02.02
R=nil
pcall(function()
  import "com.genouka.rarestoret.R"
end)
import "android.graphics.Bitmap"
import "android.graphics.BitmapFactory"
import "android.graphics.Canvas"
import "android.graphics.Paint"
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"
function decodeBitmapFromResource(drawableId,func)
  --local Bitmap=luajava.bindClass("android.graphics.Bitmap")
  --local BitmapFactory=luajava.bindClass("android.graphics.BitmapFactory")
  --local Canvas=luajava.bindClass( "android.graphics.Canvas")
  if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) then
    return BitmapFactory.decodeResource(activity.getResources(), drawableId);
  end
  local drawable = activity.getResources().getDrawable(drawableId);
  local bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
  local canvas;
  if func~=nil then
    bitmap=func(drawable,bitmap)
   else
    canvas=Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
    drawable.draw(canvas);
  end

  return bitmap;
end


function getDrawableEx(t)
  local rep
  xpcall(function()
    --local Bitmap=luajava.bindClass("android.graphics.Bitmap")
    --local BitmapFactory=luajava.bindClass("android.graphics.BitmapFactory")
    local n=activity.getResources().getDrawable(t)
    if n==nil then return nil end
    rep= n.getBitmap();
  end,
  function()
    --备用加载器
    rep=decodeBitmapFromResource(t)
  end)
  return rep
end
-- Resource URI
function loadbitmapAsync(img,url)
  activity.newTask(function(url)
    require "import"
    local a=nil
    pcall(function() a=loadbitmap(url) end)
    this.update(a)
  end,
  function(e)
    --activity.runOnUiThread(function()
    pcall(function() img.setImageBitmap(e) end)
    --end)
  end,function() end).execute({url})
end