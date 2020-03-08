#Include, lib/common.ahk
#Include, lib/config.ahk
global info:=""
global config:=get_config("task_scheduler")
;在windows的TaskScheduler中创建每日提醒,
;提醒时间从选择的文件名中取得,统一为MM SS
create_daily_clock_task(time,mpath,description=""){
    ; ;A constant that specifies a daily trigger.
    TriggerTypeDaily = 2
    ; ;A constant that specifies an executable action.
    ActionTypeExec = 0

    ;logon type https://docs.microsoft.com/en-us/windows/win32/taskschd/principal-logontype
    logontype:=config["logontype"]
    ;  MsgBox, %logontype%
    ; TASK_LOGON_SERVICE_ACCOUNT=5
    
    name:="ahk_" StrReplace(time, ":")

    service := ComObjCreate("Schedule.Service")
    service.Connect()
    
    ; ;Get a folder to create a task definition in. 
    rootFolder := service.GetFolder("\")
    
    ; ;The taskDefinition variable is the TaskDefinition object.
    taskDefinition := service.NewTask(0) 
    
    ; ;Set the registration info for the task by 
    regInfo:= taskDefinition.RegistrationInfo
    regInfo.Description:= "automatically created by ahk"
    regInfo.Author:= "collen"

    ;Set the Principal
    principal:=taskDefinition.Principal
    principal.RunLevel:=1 ;0:low 1:highest
    principal.LogonType:=logontype
    
    ;Set the task setting info for the Task Scheduler by
    settings:= taskDefinition.Settings
    settings.Enabled:= True
    settings.StartWhenAvailable:= True
    settings.Hidden:= False
    settings.WakeToRun:= True

    ;idle setting
    idleSetting:=settings.IdleSettings
    ; IdleSettings.IdleDuration:="PT10M"
    ; IdleSettings.WaitTimeout:="PT1H"

    ; ;Create a daily trigger. Note that the start boundary 
    triggers:= taskDefinition.Triggers
    trigger:= triggers.Create(TriggerTypeDaily)
    
    ;Trigger variables that define when the trigger is active 
    today:=A_Now
    FormatTime, Date, %today%, yyyy-MM-dd
    startTime:= Date "T" time 
    EnvAdd, today, 365, Days
    FormatTime, Date, %today%, yyyy-MM-dd
    endTime:= Date "T" time
    
    trigger.StartBoundary:= startTime
    trigger.EndBoundary:= endTime
    trigger.DaysInterval:= 1    ;'Task runs every day.
    
    trigger.Id:= name
    trigger.Enabled:= True

    repetitionPattern:= trigger.Repetition
    repetitionPattern.Duration:= "PT1M"
    repetitionPattern.Interval:= "PT1M"
    
    ;Add an action to the task to run notepad.exe.
    ;press a key a wake up the screen
    Action:= taskDefinition.Actions.Create( ActionTypeExec)
    Action.Path:="""" GetFilePath("bin\sendKey.exe") """"

    Action:= taskDefinition.Actions.Create( ActionTypeExec)
    SplitPath, mpath , OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive

    exe:=exe_to_ext[OutExtension]
    ;MsgBox,exe=%exe%
    ;如果在设置文件中该文件名后缀被指定了启动程序
    if(strlen(exe)!=0)
        Action.Path:="""" exe """"
    Else
        Action.Path:="""" GetFilePath("bin\start.exe") """"
    ; if ( ["mp1","mp2","mp3","mp4","wma","wmv","rm","rmvb","aac","mid","wav","vqf","avi","mpg","mpeg","cda"] Contains %OutExtension% )
    ; {
    ;     ;对于音乐文件,指定播放器为wmp
    ;     Action.Path:="""" A_ProgramFiles "\Windows Media Player\wmplayer.exe" """"
        
    ; }else{
    ;     Action.Path:="""" GetFilePath("bin\start.exe") """"
    ; }
    Action.Arguments:="""" mpath """"
    ;Register (create) the task.
    rootFolder.RegisterTaskDefinition(name, taskDefinition, 6, , , 3)

    info:= info "Task " name " submitted.`n[ext]" OutExtension "`n[cmd]" Action.Path " " Action.Arguments "`n`n" 
}
