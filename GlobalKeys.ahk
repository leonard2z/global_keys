
;快速输入模式
global firstCtrl:=False
global qMode:=False
global qharr:=0

; 开启快速输入模式
Enable_qMode_forSomeTime(){
    SetValueForSomeTime(qMode,not qMode)
    }
; 关闭快速输入模式
Disable_qMode(){
    qMode:=False
}

;使得某个变量的值被改变一段时间
SetValueForSomeTime(ByRef var,value,mili_secs:=1000){
    ov:=var
var:=value
Sleep,%mili_secs%
var:=ov
}

GetFilePath(rp)
{
    if(A_IsCompiled)
    {
        return rp
    }
    else
    {
        return "D:\Code\VSC\firstProgram\ahk\globalKeys\"+rp
    }
}

;双击开启qMode,一秒后关闭
~Ctrl::
    if (A_PriorHotKey = "~Ctrl" AND A_TimeSincePriorHotkey < 400)
    {
        Enable_qMode_forSomeTime()
        }
return

;当快速模式打开时的快捷操作
#if qMode
    ;当前日期时间
t::
    FormatTime, TimeString,R
        Send,%TimeString%
    Disable_qMode()
return

;退出程序
#if qMode
Esc::
ExitApp, 0
return

#if qMode
    ;口吐莲花
z::
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    url=https://nmsl.shadiao.app/api.php?level=min&lang=zh_cn
    whr.Open("GET", url, true)
    whr.Send()
    whr.WaitForResponse()
        send % whr.ResponseText
return

;口吐情话
#if qMode
l::
;如果没有读取文件则读取文件
if(qharr=0){
    FileEncoding, utf-8
    fn:=GetFilePath("files\LoveTalk.txt")
    
    FileRead, data, %fn%
    
    FileRead, OutputVar, Filename
    qharr:=StrSplit(data, "<n>")
}

mi:=qharr.Length() 
Random,rand, 0 , mi
res:=Trim(qharr[rand]," `t`r`n")

send % res
Return 

#if qMode
    ;打开音乐并播放音乐(测试网易云)
p::
    try{
        run % GetFilePath("files/default.mp3")
        Sleep,15000
        send {Media_Next,5}
    }Catch e{
        MsgBox % e.what e.message e.extra e.file e.line
    }
return

#if qMode
    ;҉文҉字҉变҉花҉
h::
    
    v:=Clipboard
    send ^c
    h:=Clipboard
    Clipboard:=v

    arr:=StrSplit(h,"")
 
    res:=""

    For k,v In arr
    {
        res=%res%҉%v%
    }
    res=%res%҉

    send %res%
return



