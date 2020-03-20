
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
            
            list.Push(line)
        }
    }
    return (list)
}

run_result(command)
{

    ; ScrollBox(command)
    ; MsgBox,%command%
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
    ; MsgBox,%output%
    return output
}

split_to_words(str){
    sign:="`n"
    line:=RegExReplace(str, "\s+" , sign)
   
    parts:=StrSplit(line, [sign])
    return parts
}

;根据名称找到非系统进程
find_tasks(str)
{
        ; MsgBox,%str%
    cmd=wmic process where "ExecutablePath is not null"  get name,ProcessID,ExecutablePath | findstr /v Windows 

    tasks:=[]
    ;  MsgBox, cmd:%cmd%
    if(StrLen(str)!=0)
        res:= run_result(cmd " | findstr /i """ str """ ")
    else
        res:=  run_result(cmd)

    lines:=split_to_lines(res)
    
    ; ScrollBox("res:" res "`n" print_table(lines))
    ;MsgBox, %res%
    if(StrLen(str)==0)
    {
        lines.Remove(1)
    }
    
    for k,line in split_to_lines(res){
        ; MsgBox, line=%line%
        pid:=SubStr(line,RegExMatch(line, "\d+(?=\s*)$" ))
        ; MsgBox, pid=%pid%
        line:=RegExReplace(line,"\s*\d+\s*$")
        ; RegExMatch(RegExReplace(line,"\s*\d+$"),"\w+$")
        ;  MsgBox, line=%line%
        line:=SubStr(line, RegExMatch(line,"\S+$"))
        ; line:=
        ;  MsgBox, line=%line%
        ; words:=split_to_words(line)
        
        tasks.Push([line,pid])
    }
    obj:=print_table(tasks)
    ;MsgBox, tasks=`n%obj%

    return tasks
}

print_arr(arr,len:=10)
{
    str:=""
    for k,v in arr{
        str:=str Format("{1:-" len "}",v)
    }
    str:=str "`n"
    return str
}
get_maxlen(arr)
{
    max:=0
    for k,v in arr{
        if(StrLen(v)>max)
        max:=StrLen(v)
    }
    return max
}
get_table_maxlen(table)
{
    max:=0
    for k,v in table{
        m:=get_maxlen(v)
        if(m>max)
        max:=m
    }
    return max
}
print_table(table)
{
    str:=""
    len:=get_table_maxlen(table)*2
    ;MsgBox,len=%len%
    for k,row in table{
        str:=str print_arr(row,len)
    }
    str:=str "`n"
    return str
}

remove_whitelist(tasks)
{
    ;MsgBox,enter
    keys_to_delete:=[]
    lines_to_delete:=[]
    ;  ret:=[]
    path:=GetFilePath("files\ignored.txt")
    Loop, read, %path%
    {
        ;MsgBox key process %A_LoopReadLine%
        for k,line in tasks{
            v:=line[1]
            ; MsgBox, v= %v%
            if(InStr(v,A_LoopReadLine))
            {
                keys_to_delete.Push(k)
                lines_to_delete.Push(line)
                ; lines_to_delete.Push(k)
            }
        }
    }

    ret:=print_table(lines_to_delete)

    for k,key in keys_to_delete{
        tasks.Delete(key)
    }
    
    return ret
    
}
