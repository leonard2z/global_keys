#Include, lib/scrollbar.ahk
#Include, lib/common.ahk
#Include, lib/explorer.ahk
#Include, lib/task_scheduler.ahk
#Include, lib/config.ahk
#Include, lib/regex.ahk


global firstCtrl:=False
global qMode:=False
global qharr:=0
global main_config:=get_config("global")
goto_somewhere("debug")

; run_as_admin_quit("start")
program_start:
    ;跳转到参数1代表的标签
    goto_somewhere(1)
    ;尝试跳转到debug
    ; goto_somewhere("debug")

    ; 开启快速输入模式
    Enable_qMode_forSomeTime()
    {
        SetValueForSomeTime(qMode,not qMode)
        }
    ; 关闭快速输入模式
    Disable_qMode()
    {
        qMode:=False
    }
    ; paht:=Log(A_ScriptFullPath)
    ; MsgBox, The current script is %A_ScriptName%
    
    ;双击开启qMode,一秒后关闭
~Ctrl::
    if (A_PriorHotKey = "~Ctrl" AND A_TimeSincePriorHotkey < 400)
    {
        Enable_qMode_forSomeTime()
        }
return

; Hotkey, KeyName [, Label, Options]
;当快速模式打开时的快捷操作
#if qMode
    ;当前日期时间
f:=main_config["time_format"]
;MsgBox,%f%
FormatTime, TimeString , ,%f%
    ; FormatTime, TimeString,R
Send,%TimeString%
Disable_qMode()
return

;退出程序
#if qMode
Esc::
ExitApp, 0
return

q::
     run "C:\Program Files\AutoHotkey\AutoHotkey.exe" "D:\Code\VSC\firstProgram\ahk\globalKeys\GlobalKeys.ahk" debug
    ExitApp, 0
return

#if qMode口吐莲花
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
if(qharr=0)
{
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
        start_with_config(GetFilePath("files/default.mp3"))
        ; run % GetFilePath("files/default.mp3")
        Sleep,15000
        send {Media_Next,5}
    }Catch e{
        ;MsgBox % e.what e.message e.extra e.file e.line
    }
return

#if qMode
    ;҉文҉字҉变҉花҉ aaddn
h::
    h:=get_selected_text()
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
    ;杀死进程 ,输入*杀死所有关键进程外的进程
k::

kill_task:
    debug:
    run_as_admin_quit("kill_task")
    Disable_qMode()
    InputBox, p ,输入, 输入需要杀死的进程名(输入*号代表杀死所有非关键进程)
    if(StrLen(p)==0)
        return

    search:=p
    if(p=="*")
        {
            search:=""
            ;MsgBox,iiiii
        }

    lines:=find_tasks(search)
    ; MsgBox % lines.Length()
    if(lines.Length()==0)
    {
        result:="没有需要杀死的的进程,本窗口会自动关闭:`n"
        ScrollBox(result ,"p2222")
    return
    }

    ; ScrollBox(print_table(lines),"P")
    ; lines:=split_to_lines(result)
    ; result:=""t
    if(p=="*")
    removed:=remove_whitelist(lines)

    result:=""
    result:=result "请确认无误后继续?`n`n即将杀死的进程:`n"
    result:=result print_table(lines)
    ; for k,line in result{
    ;     result:=result k ":" line "`n"
    ; }
    
    result:=result "`n`n被忽略的进程:`n" removed


    ret:=ScrollBox(result "","P b2")
    if(!ret)
        {
            return
        }

    for k,line in lines{

        pid:=line[2]
        ; MsgBox,pid:%pid%
        RunWait, taskkill /f /t /pid %pid%,,Hide
        Process, Close,%pid%
    }
    
    lines:=find_tasks(search)
    if(p=="*")
    remove_whitelist(lines)
    result:="未能杀死的的进程,本窗口会自动关闭:`n"
    result:=result print_table(lines)
    
    ScrollBox(result ,"p2222")
return

 

#if qMode
r::
;朗读选中文字
vi:=ComObjCreate("SAPI.SpVoice")
v:=vi.GetVoices().Item(0) ;0:zh 1:en 2:ja 3:unkonwn
vi.Voice:=v
vi.Speak(get_selected_text())
return

s::
    ; 将选中文件转化为录音后保存到本地
    ; 1: File Must Exist
    ; 2: Path Must Exist
    ; 8: Prompt to Create New File
    ; 16: Prompt to Overwrite File
    
    SAFT48kHz16BitStereo:= 39
    SSFMCreateForWrite := 3 ;;Creates file even if file exists and so destroys or overwrites the existing file
        
    text:=get_selected_text()
    
    vi:=ComObjCreate("SAPI.SpVoice")
    v:=vi.GetVoices().Item(0) ;0:zh 1:en 2:ja 3:unkonwn
    vi.Voice:=v
    
    files:=select_files_to_save("MS24",A_Desktop "\record.wav","","*.wav")  
    
    for k,file in files{
        ; FileSelectFile, path,S24,%A_Desktop%\record.wav,,*.wav
        try{
            
            oFileStream := ComObjCreate("SAPI.SpFileStream")
            oFileStream.Format.Type := SAFT48kHz16BitStereo
                oFileStream.Open(file, SSFMCreateForWrite)
            }
        Catch, e{
            MsgBox,未能打开文件,如果文件已存在请以管理员身份运行
            return
        }
        vi.AudioOutputStream := oFileStream
        vi.Speak(text)
        oFileStream.Close()
    }
    
    ; ComObjCreate("System.Speech.Synthesis.SpeechSynthesizer").Speak(get_selected_text())
return

$c::
create_task:
    run_as_admin_quit("create_task")
    ;创建定时计划,时间由文件名决定
    ; FileSelectFile, pathes,MS24,%A_Desktop%\,,
    sel:=split_to_lines(Explorer_GetSelected())
    ; MsgBox, %sel%
    for k,path in sel{
        if(!FileExist(path))
            Continue
        MsgBox, %path%
        SplitPath, path,OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
        time:=RegExReplace(OutNameNoExt, "\s+", ":")
        create_daily_clock_task(time,path)
    }
    MsgBox, 已添加的计划:`n%info%
    info:=""
    ts=%A_WinDir%\system32\taskschd.msc
    start(ts)
return

o::
    ; debug:
    ; FileAssociate()
    ; 从选中字符串提取链接并创建多个链接的单一快捷方式
    txt:=get_selected_text()
    lines:=split_to_lines(txt)
    program:=main_config["browser_location"]
    ; link:="""" main_config["browser_location"] """"
    
    ctt:=""
    ;创建bat
    for k,line in lines{
        ctt:=ctt "start" " """" """ line """`n"
    }
    
    MsgBox,创建脚本:`n%ctt%
    ; f=GetFilePath("temp/temp")
    f:=select_files_to_save("MS24",A_Desktop "\link.bat","","*.lnk")  
    ; MsgBox,file:`n%f%
    if(f.Length()==0)
        return
    fo:=FileOpen(f[1], "w")
    fo.Write(ctt)
    fo.Close()
    
return
return
