
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
    MsgBox % OutputVar
    OutputArray:=StrSplit(OutputVar,["`r`n","`n","`n`r"])

    len:=OutputArray.Length()
    MsgBox, %len%
    pathes:=[]
    if(len>0)
    {
        if("M" in Options)
        {
            MsgBox, "M" in Options
            ;有多选
            dir:=OutputArray[1]

            for k,v in OutputArray{
                if(k=1)
                Continue
                path:=dir "\" v
                pathes.Push(path)
                MsgBox,%path%
            }
        }
    }
    return pathes

}