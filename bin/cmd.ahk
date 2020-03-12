#Include, ./
#Include, ../lib/common.ahk


if(StrLen(%1%)!=0)
{
    p1:=%1%
    Switch p1
    {
        Case "send_key":
            send,{Home}
        return
    }
}

if(StrLen(%1%)!=0)
{
    p2:=%2%
    Switch p2{
        Case "start":
            start(p2)
        case "cmd":
            FileRead, cmd, %p2%
            run_result(cmd)
        return
    }
}