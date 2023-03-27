;/ Created with PureVision64 v6.01 x64
;/ Mon, 27 Mar 2023 09:32:13
;/ by Michael Bergmann                




XIncludeFile "multiform_Constants.pb"




Procedure.i Window_FormSplash()
  If OpenWindow(#Window_FormSplash,0,0,937,646,"Splash!",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible,WindowID(#Window_FormMAIN))
      ImageGadget(#Gadget_FormSplash_Image,10,25,99,140,ImageID(#Image_FormSplash_Image))
      ImageGadget(#Gadget_FormSplash_Image3,100,5,827,570,ImageID(#Image_FormSplash_Image3))
      ButtonGadget(#Gadget_FormSplash_ButtonEXIT,415,590,170,45,"Schließen",#PB_Button_Default)
      HideWindow(#Window_FormSplash,#False)
    ProcedureReturn WindowID(#Window_FormSplash)
  EndIf
EndProcedure


Procedure.i Window_FormMAIN()
  If OpenWindow(#Window_FormMAIN,0,0,278,92,"MultiForm Demo",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
    CreateImageMenu(#MenuBar_FormMAIN,WindowID(#Window_FormMAIN))
      MenuTitle("Project")
      MenuItem(#MenuBar_FormMAIN_splash,"zeige Splash")
      MenuBar()
      MenuItem(#MenuBar_FormMAIN_about,"Information")
      MenuBar()
      MenuItem(#MenuBar_FormMAIN_quit,"Beenden")
      ButtonGadget(#Gadget_FormMAIN_ButtonINFO,140,10,120,45,"Information")
      ButtonGadget(#Gadget_FormMAIN_ButtonOPEN,15,10,120,45,"Zeige Splash",#PB_Button_Default)
      HideWindow(#Window_FormMAIN,#False)
    ProcedureReturn WindowID(#Window_FormMAIN)
  EndIf
EndProcedure


