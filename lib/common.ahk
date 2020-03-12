
; 获得选中的文本
get_selected_text()
{
    v:=Clipboard
    send ^c
    h:=Clipboard
    Clipboard:=v
    return h
}

;使得某个变量的值被改变一段时间
SetValueForSomeTime(ByRef var,value,mili_secs:=1000)
{
    ov:=var
    var:=value
    Sleep,%mili_secs%
    var:=ov
}
;从相对路径换成绝对路径
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
;重新运行当前脚本副本,成果返回1
run_as_admin(params="")
{
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
;以管理员运行当前程序,并重启
run_as_admin_quit(params="")
{
    if(run_as_admin(params))
        ExitApp, 0
}
;选择多个文件来保存
select_files_to_save( Options, RootDir, Prompt, Filter*)
{
    
    FileSelectFile OutputVar, %Options%, %RootDir%, %Prompt%, %Filter%
    
    OutputArray:=split_to_lines(OutputVar)
    
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
            ; MsgBox % dir
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
;跳转到某一个标签
goto_somewhere(somewhere)
{
    label:=%somewhere%
    ;跳转到某个标签
    len:=StrLen(label)
    ; MsgBox % "len:"len " jump_to:" label
    ; MsgBox % len
    if(len>0)
    {
        Gosub,%label%
    }
}
; //启动一个路径,如果不存在则不启动
start(path)
{
    try{
        
        if(FileExist(path))
            run % path
        return 0
        
        return 1 ;failed to start the file
        
    }Catch e{
        MsgBox % e.what e.message e.extra e.file e.line
    }
}
; //将字符串分成行,空行将被省略
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

run_result(command)
{
    tb:=GetFilePath("temp/temp.bat")
    tp:=GetFilePath("temp/temp.txt")
    
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

;根据名称找到进程
find_tasks(str)
{
    ; MsgBox,%str%
    return run_result("tasklist | findstr /i """ str """ ")
}

FileAssociate(Label,Ext,Cmd,Icon:="", batchMode:=0) {
; by Ħakito: https://autohotkey.com/boards/viewtopic.php?f=6&t=55638 
; modified by Marius Șucan to AHK v1.1

; Weeds out faulty extensions, which must start with a period, and contain more than 1 character
iF (SubStr(Ext,1,1)!="." || StrLen(Ext)<=1)
    Return 0

; Weeds out faulty labels such as ".exe" which is an extension and not a label
iF (SubStr(Label,1,1)=".")
    Return 0

If Label
    RegRead, CheckLabel, HKEY_CLASSES_ROOT\%Label%, FriendlyTypeName

; Do not allow the modification of some important registry labels
iF (Cmd!="" && CheckLabel)
    Return 0

regFile := "Windows Registry Editor Version 5.00`n`n"
; Note that "HKEY_CLASSES_ROOT" actually writes to "HKEY_LOCAL_MACHINE\SOFTWARE\Classes"
; If the command is just a simple path, then convert it into a proper run command
iF (SubStr(Cmd,2,2)=":\" && FileExist(Cmd))
    Cmd := """" Cmd """" A_Space """" "%1" """"
Else
    Return 0

Cmd := StrReplace(Cmd, "\", "\\")
Cmd := StrReplace(Cmd, """", "\""")
regFile .= "[HKEY_CLASSES_ROOT\" Ext "]`n@=" """" Label """" "`n"
regFile .= "`n[HKEY_CLASSES_ROOT\" Label "]`n@=" """" Label """" "`n"
regFile .= "`n[HKEY_CLASSES_ROOT\" Label "\Shell\Open\Command]`n@=" """" Cmd """" "`n"
regFile .= "`n[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" Ext "\UserChoice]`n""ProgId""=" """" Label """" "`n"
regFile .= "`n[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" Ext "\OpenWithProgids]`n"
regFile .= "`n[-HKEY_CLASSES_ROOT\" Ext "\OpenWithProgids]`n`n"

If Icon
    regFile .= "`n[HKEY_CLASSES_ROOT\" QPVslideshow "\DefaultIcon]`n@=" Icon "`n`n"

If !InStr(FileExist(mainCompiledPath "\regFiles"), "D")
{
    FileCreateDir, %mainCompiledPath%\regFiles
    Sleep, 1
}

iExt := StrReplace(Ext, ".")
FileDelete, %mainCompiledPath%\regFiles\RegFormat%iExt%.reg
    Sleep, 1
FileAppend, % regFile, %mainCompiledPath%\regFiles\RegFormat%iExt%.reg
    runTarget := "Reg Import """ mainCompiledPath "\regFiles\RegFormat" iExt ".reg" """" "`n"
If !InStr("|WIN_7|WIN_8|WIN_8.1|WIN_VISTA|WIN_2003|WIN_XP|WIN_2000|", "|" A_OSVersion "|")
    runTarget .= """" mainCompiledPath "\SetUserFTA.exe""" A_Space Ext A_Space Label "`n"
FileAppend, % runTarget, %mainCompiledPath%\regFiles\runThis.bat
If (batchMode!=1)
{
    Sleep, 1
    RunWait, *RunAs %mainCompiledPath%\regFiles\runThis.bat
    FileDelete, %mainCompiledPath%\regFiles\RegFormat%iExt%.reg
        FileDelete, %mainCompiledPath%\regFiles\runThis.bat
}

return 1
}