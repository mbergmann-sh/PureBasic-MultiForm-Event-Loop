;**********************************************************************************
;*  Copyright (c)2002-2020 Reel Media Productions                                 *
;*                                                                                *
;*  This Module is made available to Registered PureVision End Users to use       *
;*  Royalty Free in Private or Commercial Compiled Projects.                      *
;*  You are free to modify this Modules Source Code and/or add to it as you wish. *
;*                                                                                *
;*  The Source Code in this Module is only for Registered PureVision End Users    *
;*  and is not to be distributed publicly.                                        *
;**********************************************************************************





DeclareModule PVP
  Declare.i PV_PluginsInfo(Name.s,HiVersion.i,LoVersion.i,Info.s,Copyright.s)
  Declare   PV_PluginsWindowName(Name.s)
  Declare   PV_PluginsWindowTitle(Title.s)
  Declare   PV_PluginsWindowX(x.i)
  Declare   PV_PluginsWindowY(y.i)
  Declare   PV_PluginsWindowW(w.i)
  Declare   PV_PluginsWindowH(h.i)
  Declare   PV_PluginsWindowBGColor(BGColor.i)
  Declare   PV_PluginsWindowTabs(Tabs.i)
  Declare   PV_PluginsGadgetType(Type.s)
  Declare   PV_PluginsGadgetName(Name.s)
  Declare   PV_PluginsGadgetText(Text.s)
  Declare   PV_PluginsGadgetX(x.i)
  Declare   PV_PluginsGadgetY(y.i)
  Declare   PV_PluginsGadgetW(w.i)
  Declare   PV_PluginsGadgetH(h.i)
  Declare   PV_PluginsGadgetTabs(Tabs.i)
  Declare   PV_PluginsMenuItemName(Name.s)
  Declare   PV_PluginsMenuItemText(Text.s)
  Declare   PV_PluginsMenuItemPos(pos.i)
  Declare.i PV_Plugins(Cancel.i=0)
EndDeclareModule
  
  
Module PVP
  EnableExplicit

  Structure InitPlugin
    id.s
    name.s
    HiVersion.l
    LoVersion.l
    Info.s
    Copyright.s
    Param.s
  EndStructure
  
  Structure WindowPlugin
    FormName.s
    FormTitle.s
    x.l
    y.l
    w.l
    h.l
    bgcolor.l
    tabs.l
  EndStructure
  
  Structure GadgetPlugin
    UseGadget.s
    GadgetName.s
    GadgetText.s
    x.l
    y.l
    w.l
    h.l
    tabs.l
  EndStructure
  
  Structure MenuItemPlugin
    MenuItemName.s
    MenuItemText.s
    Cols.l
  EndStructure

  Global iPlug.InitPlugin
  Global wPlug.WindowPlugin
  Global NewList gPlug.GadgetPlugin()
  Global NewList mPlug.MenuItemPlugin()
  
      
  Procedure.i PV_PluginsInfo(Name.s,HiVersion.i,LoVersion.i,Info.s,Copyright.s);Assign Information to Plugin
    iPlug\id="PureVisionPlugin"
    iPlug\name=Name
    iPlug\HiVersion=HiVersion
    iPlug\LoVersion=LoVersion
    iPlug\Info=Info
    iPlug\Copyright=Copyright
    iplug\Param=ProgramParameter()
    If iplug\Param="Execute"
      ProcedureReturn 1
    EndIf
  EndProcedure

;---------------------------

  Procedure PV_PluginsWindowName(Name.s)
    wPlug\FormName=Name
  EndProcedure
  
  Procedure PV_PluginsWindowTitle(Title.s)
    wPlug\FormTitle=Title
  EndProcedure
  
  Procedure PV_PluginsWindowX(x.i)
    wPlug\x=x
  EndProcedure
  
  Procedure PV_PluginsWindowY(y.i)
    wPlug\y=y
  EndProcedure
  
  Procedure PV_PluginsWindowW(w.i)
    wPlug\w=w
  EndProcedure
  
  Procedure PV_PluginsWindowH(h.i)
    wPlug\h=h
  EndProcedure
  
  Procedure PV_PluginsWindowBGColor(BGColor.i)
    wPlug\bgcolor=BGColor
  EndProcedure
  
  Procedure PV_PluginsWindowTabs(Tabs.i)
    wPlug\tabs=Tabs
  EndProcedure
  
;---------------------------

  Procedure PV_PluginsGadgetType(Type.s)
    AddElement(gPlug())
    gPlug()\UseGadget=Type
  EndProcedure
  
  Procedure PV_PluginsGadgetName(Name.s)
    LastElement(gPlug())
    gPlug()\GadgetName=Name
  EndProcedure
  
  Procedure PV_PluginsGadgetText(Text.s)
    LastElement(gPlug())
    gPlug()\GadgetText=Text
  EndProcedure
  
  Procedure PV_PluginsGadgetX(x.i)
    LastElement(gPlug())
    gPlug()\x=x
  EndProcedure
  
  Procedure PV_PluginsGadgetY(y.i)
    LastElement(gPlug())
    gPlug()\y=y
  EndProcedure
  
  Procedure PV_PluginsGadgetW(w.i)
    LastElement(gPlug())
    gPlug()\w=w
  EndProcedure
  
  Procedure PV_PluginsGadgetH(h.i)
    LastElement(gPlug())
    gPlug()\h=h
  EndProcedure
  
  Procedure PV_PluginsGadgetTabs(Tabs.i)
    LastElement(gPlug())
    gPlug()\tabs=Tabs
  EndProcedure  
   
;---------------------------

  Procedure PV_PluginsMenuItemName(Name.s)
    AddElement(mPlug())
    If UCase(name)="<BREAK>"
      name=Chr(159)+"---"
      mPlug()\MenuItemText="-----" 
    EndIf
    mPlug()\MenuItemName=Name
  EndProcedure
  
  Procedure PV_PluginsMenuItemText(Text.s)
    LastElement(mPlug())
    mPlug()\MenuItemText=Text
  EndProcedure
  
  Procedure PV_PluginsMenuItemPos(pos.i) ;0=Main, 1=Sub
    LastElement(mPlug())
    If pos<0:pos=0:EndIf
    If pos>2:pos=2:EndIf
    mPlug()\cols=pos
  EndProcedure

;---------------------------
  
  Procedure.i PV_Plugins(Cancel.i=0);Link Plugin to PureVision
    Protected exepath.s,tmp.i
    If Cancel=0
      If iplug\Param="Info" Or iplug\Param="Execute"
        exepath=Space(512)
        GetModuleFileName_(0,@exepath,512)
        exepath=GetPathPart(exepath)
        If Right(exepath,1)<>"\":exepath+"\":EndIf
        
        If CreatePreferences(exepath+"Plugin.pvx")
          PreferenceGroup("InitPlug")
          WritePreferenceString("id",iPlug.InitPlugin\id)
          WritePreferenceString("Name",iPlug\name)
          WritePreferenceLong("HiVersion",iPlug\HiVersion)
          WritePreferenceLong("LoVersion",iPlug\LoVersion)
          WritePreferenceString("Info",iPlug\Info)
          WritePreferenceString("Copyright",iPlug\Copyright)
          
          If iplug\Param="Execute"
            PreferenceGroup("WindowPlug")
            WritePreferenceLong("Gadgets",ListSize(gPlug()))
            WritePreferenceLong("MenuItems",ListSize(mPlug()))
            WritePreferenceString("FormName",wPlug\FormName)
            WritePreferenceString("FormTitle",wPlug\FormTitle)
            WritePreferenceLong("X",wPlug\x)
            WritePreferenceLong("Y",wPlug\y)
            WritePreferenceLong("W",wPlug\w)
            WritePreferenceLong("H",wPlug\h)
            WritePreferenceLong("BGColor",wPlug\bgcolor)
            WritePreferenceLong("Tabs",wPlug\tabs)
            
            tmp=0
            ForEach gPlug() 
              tmp+1
              PreferenceGroup("GadgetPlug_"+Str(tmp))
              WritePreferenceString("UseGadget",gPlug()\UseGadget)
              WritePreferenceString("GadgetName",gPlug()\GadgetName)
              WritePreferenceString("GadgetText",gPlug()\GadgetText)
              WritePreferenceLong("X",gPlug()\x)
              WritePreferenceLong("Y",gPlug()\y)
              WritePreferenceLong("W",gPlug()\w)
              WritePreferenceLong("H",gPlug()\h)
              WritePreferenceLong("Tabs",gPlug()\tabs)           
            Next
    
            tmp=0
            ForEach mPlug() 
              tmp+1
              PreferenceGroup("MenuItemPlug_"+Str(tmp))
              WritePreferenceString("MenuItemName",mPlug()\MenuItemName)
              WritePreferenceString("MenuItemText",mPlug()\MenuItemText)
              WritePreferenceLong("Cols",mPlug()\cols)           
            Next
          EndIf
        EndIf
        
        ClosePreferences()
        ProcedureReturn 1
      EndIf
    EndIf
  EndProcedure  
  
EndModule


UseModule PVP









; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 88
; FirstLine = 45
; Folding = DBAA9
; Optimizer
; EnableXP
; CompileSourceDirectory