#Include, lib/common.ahk

global CFG_FILE_PATH:= GetFilePath("files\config.ini")
global exe_to_ext:=get_config("exe_to_ext")
;MsgBox % "exe_to_ext[mp3]=" exe_to_ext["mp3"]
; MsgBox % exe_to_ext["wmv"]
get_config(section,key*){
    ; MsgBox, %CFG_FILE_PATH%
    IniRead, OutputVar, %CFG_FILE_PATH%, %section%, %key%

    ;如果是section则返回字典
    if(strlen(key)=0)
    {
        dict:={}
        lines:=split_to_lines(OutputVar)
        for k,line in lines{
            
            parts:=StrSplit(line, "=")
            key:=parts[1]
            value:=parts[2]
            ; MsgBox line=%line% key=%key% value=%value%
            dict[key]:=value
        }
        return dict
    }
    return OutputVar
}
set_config(section,key,Value*){
    IniWrite, Value, %CFG_FILE_PATH%, %Section%, %Key%
}
delete_config(section,key*){
    IniDelete, %CFG_FILE_PATH%, %Section%,%key%
}
start_with_config(path)
{
    SplitPath, path , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
    exe:=exe_to_ext[OutExtension]
    ;MsgBox ,exe=%exe%
    if(strlen(exe)!=0)
    {
        ;如果在设置文件中该文件名后缀被指定了启动程序
        ;MsgBox,%exe% %path%
        run,%exe% %path%
    }
    Else
    {
            start(path)
    }
}


