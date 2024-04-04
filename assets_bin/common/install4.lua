--GenOuka 2024.02.23
function compiler(path,savepath,callback)
  xpcall(function()
    local ApkSigner=luajava.bindClass("com.android.apksig.ApkSigner")
    local signcat=luajava.bindClass("com.genouka.storet.signcat")
    local ks=signcat.getks(File(activity.getLuaDir().."/keys/keystore.ks"),String("").toCharArray())
    local pr=signcat.getkey(ks,"CERT",String("android").toCharArray())
    local pub=signcat.getcer(ks,"CERT")
    signcat.pre(pr,pub)
    signcat.cat(
    activity,
    File(path),
    File(savepath),
    -1,
    signcat.Callback{
      callback=callback.onsuccess,
      error=callback.onerror
    })
  end,
  function(e)
    callback.onerror(-3,e)
  end)
end