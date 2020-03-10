
; 获得选中的文本
get_selected_text(){
    v:=Clipboard
    send ^c
    h:=Clipboard
    Clipboard:=v
return h
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

run_as_admin(params=""){
    full_command_line := DllCall("GetCommandLine", "str")

    if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
    {
        try
        {
            
            if A_IsCompiled
                 cmd = "%A_ScriptFullPath%" /restart %params%
            else
                 cmd = "%A_AhkPath%" /restart "%A_ScriptFullPath%" %params%

            Run *RunAs %cmd%
        }
        return 1 ;scripted has been run
    }

    return 0
    
    ;MsgBox A_IsAdmin: %A_IsAdmin%`nCommand line: %full_command_line%
}

run_as_admin_quit(params=""){
    if(run_as_admin(params))
     ExitApp, 0
}
select_files_to_save(   Options, RootDir, Prompt, Filter*){
    
    FileSelectFile OutputVar, %Options%, %RootDir%, %Prompt%, %Filter%
    ;MsgBox % OutputVar
    OutputArray:=StrSplit(OutputVar,["`r`n","`n","`n`r"])

    len:=OutputArray.Length()
    ;MsgBox, %len%
    pathes:=[]
    if(len>0)
    {
        if("M" in Options)
        {
            ;MsgBox, "M" in Options
            ;有多选
            dir:=OutputArray[1]

            for k,v in OutputArray{
                if(k=1)
                Continue
                path:=dir "\" v
                pathes.Push(path)
                ;MsgBox,%path%
            }
        }
    }
    return pathes

}

goto_somewhere(somewhere){
    label:=%somewhere%
    ;跳转到某个标签
    len:=StrLen(label)
    ; MsgBox % "len:"len " jump_to:" label
    ; MsgBox % len
    if(len>0)
    {
        Gosub,%label%
    }#SingleInstance, Force
    #KeyHistory, 0
    SetBatchLines, -1
    ListLines, Off
    SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
    SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
    SetWorkingDir, %A_ScriptDir%
    SplitPath, A_ScriptName, , , , thisscriptname
    #MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
    ; DetectHiddenWindows, On
    ; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
    ; SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
    ; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag   
}

start(path){
    try{
        
        if(FileExist(path))
            run % path
            return 0
        
        return 1 ;failed to start the file
        
    }Catch e{
        MsgBox % e.what e.message e.extra e.file e.line
    }
}

split_to_lines(str)
{
    SC:=":#$"
    str:=RegExReplace(str, "\s*\n\s*",SC)
    lines:=StrSplit(str, [SC])
    StrSplit(String, [Delimiters, OmitChars])
    list:=[]
    for l,line in lines{
        ; MsgBox,%line%
        if(StrLen(line)!=0)
            {
                ; MsgBox,added:%line%
                list.Push(line)
            }
    }
    return (list)
}

run_result(command){
tb:=GetFilePath("folder/temp.bat")
tp:=GetFilePath("folder/temp.txt")

f:=FileOpen(tb, "w")
cmd=%command% >> %tp%
; MsgBox,%cmd%
f.Write(cmd)
f.Close()
RunWait, %tb% , , Hide, 
FileRead, output, %tp%
FileDelete, %tp%
return output
}

find_tasks(str){
    ; MsgBox,%str%
    return run_result("tasklist | findstr /i """ str """ ")
}