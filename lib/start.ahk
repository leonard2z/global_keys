par= %1%

; MsgBox % len
if(StrLen(par)>0)
{
  start(par)
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

