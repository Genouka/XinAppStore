require "import"
import "android.app.AlertDialog"
local err=err or "无"
local a=AlertDialog.Builder()
a.title="致命错误"
a.message=[[应用发生了无法恢复的错误！

请尝试[环境修复]按钮，如果没有用请报告开发者GenOuka(QQ2980077544)

错误详情：
]]..err
a.setPositiveButton("环境修复",function()
print("正在修复，修复时应用可能闪退为正常现象")
Runtime.getRuntime().exec("pm clear "..activity.getPackageName())
end)
a.setNegativeButton("隐藏",nil)
a.create().show()