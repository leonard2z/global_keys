
par= %1%

; MsgBox % len
if(StrLen(par)>0)
{
  start(par)
}

start(path){
    try{
        run % path
    }Catch e{
        MsgBox % e.what e.message e.extra e.file e.line
    }
}

