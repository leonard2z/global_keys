URL_DONT_ESCAPE_EXTRA_INFO  = 0x02000000
URL_DONT_SIMPLIFY           = 0x08000000
    URL_ESCAPE_PERCENT          = 0x00001000
URL_ESCAPE_SEGMENT_ONLY     = 0x00002000
URL_ESCAPE_SPACES_ONLY      = 0x04000000
URL_ESCAPE_UNSAFE           = 0x20000000
URL_INTERNAL_PATH           = 0x00800000
URL_PARTFLAG_KEEPSCHEME     = 0x00000001
URL_PLUGGABLE_PROTOCOL      = 0x40000000
URL_UNESCAPE                = 0x10000000
URL_UNESCAPE_HIGH_ANSI_ONLY = 0x00400000
URL_UNESCAPE_INPLACE        = 0x00100000

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

#if qMode
    ;将文字翻译成文言文
:*:fw::
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    url=https://fanyi.baidu.com/v2transapi?from=zh&to=wyw
    data:="我喜欢你"
    flags:= URL_ESCAPE_SPACES_ONLY | URL_DONT_ESCAPE_EXTRA_INFO | URL_ESCAPE_UNSAFE
    data:=UrlEscape(data,flags)
    body:="from=zh&to=wyw&query=" data "&transtype=realtime&simple_means_flag=3&sign=668253.971116&token=50e2b3c23e81833ef1907b5c0d374479&domain=common"
    MsgBox % data
    whr.Open("GET", url, true)
    whr.SetRequestHeader("authority","fanyi.baidu.com")
    whr.SetRequestHeader("pragma","no-cache")
    whr.SetRequestHeader("cache-control","no-cache")
    whr.SetRequestHeader("accept","*/*")
    whr.SetRequestHeader("sec-fetch-dest","empty")
    whr.SetRequestHeader("x-requested-with","XMLHttpRequest")
    whr.SetRequestHeader("user-agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36")
    whr.SetRequestHeader("content-type","application/x-www-form-urlencoded; charset=UTF-8")
        whr.SetRequestHeader("origin","https://fanyi.baidu.com")
    whr.SetRequestHeader("sec-fetch-site","same-origin")
    whr.SetRequestHeader("sec-fetch-mode","cors")
    whr.SetRequestHeader("referer","https://fanyi.baidu.com/")
    whr.SetRequestHeader("accept-language","en,zh-CN;q=0.9,zh;q=0.8,ja;q=0.7")
    whr.SetRequestHeader("cookie","BAIDUID=F18887C3B89BFD0A2DA5ADFA3BBC831F:FG=1; BIDUPSID=F18887C3B89BFD0A2DA5ADFA3BBC831F; PSTM=1577891273; cflag=13%3A3; BDUSS=JjRVRXMFNPVEpGLWRvOVlSTjY4NW03RFYxZlR2UTVIUjBvY3M0fkdTQlRiM3RlSVFBQUFBJCQAAAAAAAAAAAEAAACR89oXYTc1NjM3MjQ4MQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFPiU15T4lNeVV; H_PS_PSSID=1449_21117_30839_30793_30823; ZD_ENTRY=google; Hm_lvt_64ecd82404c51e03dc91cb9e8c025574=1583402377; Hm_lpvt_64ecd82404c51e03dc91cb9e8c025574=1583402377; from_lang_often=%5B%7B%22value%22%3A%22en%22%2C%22text%22%3A%22%u82F1%u8BED%22%7D%2C%7B%22value%22%3A%22zh%22%2C%22text%22%3A%22%u4E2D%u6587%22%7D%5D; REALTIME_TRANS_SWITCH=1; FANYI_WORD_SWITCH=1; HISTORY_SWITCH=1; SOUND_SPD_SWITCH=1; SOUND_PREFER_SWITCH=1; __yjsv5_shitong=1.0_7_418fb3bc54c038b8e5a1a906ade13170ee56_300_1583402384087_42.49.20.185_7c7ced44; yjs_js_security_passport=b7da1bd10d92fe287a43f6bc6dab6be077f9521a_1583402384_js; to_lang_often=%5B%7B%22value%22%3A%22en%22%2C%22text%22%3A%22%u82F1%u8BED%22%7D%2C%7B%22value%22%3A%22zh%22%2C%22text%22%3A%22%u4E2D%u6587%22%7D%2C%7B%22value%22%3A%22wyw%22%2C%22text%22%3A%22%u6587%u8A00%u6587%22%7D%5D")
    whr.Send(body)
    whr.WaitForResponse()
        MsgBox % "text:" whr.ResponseText " status:" whr.Status
    
return

UrlEscape( url, flags ) {      ; www.msdn.microsoft.com/en-us/library/bb773774(VS.85).aspx
    VarSetCapacity( newUrl,500,0 ), pcche := 500
    DllCall( "shlwapi\UrlEscapeA", Str,url, Str,newUrl, UIntP,pcche, UInt,flags )
Return newUrl
}

UrlUnEscape( url, flags ) {    ; www.msdn.microsoft.com/en-us/library/bb773791(VS.85).aspx
    VarSetCapacity( newUrl,500,0 ), pcche := 500
    DllCall( "shlwapi\UrlUnescapeA", Str,url, Str,newUrl, UIntP,pcche, UInt,flags )
Return newUrl
}