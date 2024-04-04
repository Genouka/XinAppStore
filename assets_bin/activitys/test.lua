require "import"
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
  import "java.io.File"
  import "com.github.gzuliyujiang.toolkit.TextSpanBuilder"
  import "com.github.gzuliyujiang.span.*"
  --布局使用
  import "android.graphics.BitmapFactory"

  --下载模块
  import "com.liulishuo.okdownload.OkDownload";
  import "com.liulishuo.okdownload.DownloadTask";
  --import "com.liulishuo.okdownload.DownloadTask.Builder";
  import "com.liulishuo.okdownload.DownloadListener";
  import "com.liulishuo.okdownload.core.cause.EndCause";
  import "com.liulishuo.okdownload.core.cause.ResumeFailedCause";
  import "com.liulishuo.okdownload.core.breakpoint.BreakpointInfo";
  import "com.liulishuo.okdownload.StatusUtil";

  --引入R
  paths.load "/common/packen"
  --import "java.lang.Long"
end)
if !er then
  err="[02]模块加载错误\n"..st
  paths.error()
  return
end
pcall(function()
  activity.ActionBar.hide()
end)
if paths.setContentView("test") then return end
--[[
I. Task Start and Cancel

1. Start a task

task = new DownloadTask.Builder(url, parentFile)
         .setFilename(filename)
         // the minimal interval millisecond for callback progress
         .setMinIntervalMillisCallbackProcess(30)
         // do re-download even if the task has already been completed in the past.
         .setPassIfAlreadyCompleted(false)
         .build();

task.enqueue(listener);

// cancel
task.cancel();

// execute task synchronized
task.execute(listener);

2. Start tasks

// This method is optimize specially for bunch of tasks
DownloadTask.enqueue(tasks, listener);

// cancel, this method is also optmize specially for bunch of tasks
DownloadTask.cancel(tasks);

II. Queue Build, Start and Stop
DownloadContext.Builder builder = new DownloadContext.QueueSet()
        .setParentPathFile(parentFile)
        .setMinIntervalMillisCallbackProcess(150)
        .commit();
builder.bind(url1);
builder.bind(url2).addTag(key, value);
builder.bind(url3).setTag(tag);
builder.setListener(contextListener);

DownloadTask task = new DownloadTask.Builder(url4, parentFile)
        .setPriority(10).build();
builder.bindSetTask(task);

DownloadContext context = builder.build();

context.startOnParallel(listener);

// stop
context.stop();
III. Get State and Info
Normally you can get state and info on DownloadListener.

1. Get download state beyond listener
Status status = StatusUtil.getStatus(task)

status = StatusUtil.getStatus(url, parentPath, null);
status = StatusUtil.getStatus(url, parentPath, filename);

boolean isCompleted = StatusUtil.isCompleted(task);
isCompleted = StatusUtil.isCompleted(url, parentPath, null);
isCompleted = StatusUtil.isCompleted(url, parentPath, filename);

Status completedOrUnknown = StatusUtil.isCompletedOrUnknown(task);

// If you set tag, so just get tag
task.getTag();
task.getTag(xxx);
2. Get BreakpointInfo beyond listener
// Note: the info will be deleted since task is completed download for data health lifecycle
BreakpointInfo info = OkDownload.with().breakpointStore().get(id);

info = StatusUtil.getCurrentInfo(url, parentPath, null);
info = StatusUtil.getCurrentInfo(url, parentPath, filename);

// Since okdownload v1.0.1-SNAPSHOT
// the info reference will be cached on the task refrence even if the task is completed download.
info = task.getInfo();
IV. Listener

]]
local t="http://mobvoi-search-public.mobvoi.com/mobvoi-apk/awch/wear.android.files_31_wear_x86_64,x86,armeabi-v7a,arm64-v8a_16b29cf1636d8680ae956af1da05346a.apk"
task1=DownloadTask.Builder(t, File("/sdcard/Download/"))
.setFilename(filename)
--the minimal interval millisecond for callback progress
.setMinIntervalMillisCallbackProcess(30)
--do re-download even if the task has already been completed in the past.
.setPassIfAlreadyCompleted(true)
.build();
function download.onClick()
  task1.enqueue(DownloadListener{
    taskEnd=function(d,ec,ex)
      pro.text=ec.toString()
      if ec.toString()=="COMPLETED" then
        pro.text=d.getFile().toString()
      end
    end,
    fetchProgress=function(d,p,p1)
      pro.text=p.."/"..p1
    end
  });

end
function ins.onClick()
  安装应用(task1.getFile().toString())
end
function onPause()
  local isCompleted = StatusUtil.getStatus(task1);
  print("onPuase:"..tostring(isCompleted))

  --task1.cancel()
end