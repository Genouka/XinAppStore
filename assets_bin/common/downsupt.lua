import "java.io.File"
--下载模块
import "com.liulishuo.okdownload.OkDownload";
import "com.liulishuo.okdownload.DownloadTask";
--import "com.liulishuo.okdownload.DownloadTask.Builder";
import "com.liulishuo.okdownload.core.listener.DownloadListener2";
import "com.liulishuo.okdownload.core.cause.EndCause";
import "com.liulishuo.okdownload.core.cause.ResumeFailedCause";
import "com.liulishuo.okdownload.core.breakpoint.BreakpointInfo";
import "com.liulishuo.okdownload.StatusUtil";

function downloadEx(url,call)
  local t=File(XConfig["downpath"])
  t.mkdirs()
  local task1=DownloadTask.Builder(url,t)
  --.setFilename(filename)
  --the minimal interval millisecond for callback progress
  .setMinIntervalMillisCallbackProcess(30)
  --do re-download even if the task has already been completed in the past.
  .setPassIfAlreadyCompleted(true)
  .build();
  task1.enqueue(luajava.override(DownloadListener2,{
    downloadFromBeginning=function(super,task,info,cause)
      --super.downloadFromBeginning(task,info,cause)
      call.onstart(task,info,cause)
    end,
    taskEnd=function(super,d,ec,ex)
      --super.taskEnd(d,ec,ex)
      if ec.toString()=="COMPLETED" then
        call.onsuccess(d.getFile().toString(),d,ec,ex)
       else
        call.onerror(d,ec,ex)
      end
    end,
    fetchProgress=function(super,task,blockIndex,increaseBytes)
      --super.fetchProgress(task,blockIndex,increaseBytes)
      call.onprogress(task,blockIndex,increaseBytes)
    end
  }));

end