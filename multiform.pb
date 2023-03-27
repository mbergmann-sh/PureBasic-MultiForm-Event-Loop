;/ Created with PureVision64 v6.01 x64
;/ Mon, 27 Mar 2023 11:07:14
;/ by Michael Bergmann                




XIncludeFile "multiform_Constants.pb"
XIncludeFile "multiform_Windows.pb"






;- Main Loop
If Window_FormMAIN()

  Define quitFormMAIN=0
  Repeat
    EventID  =WaitWindowEvent()
    MenuID   =EventMenu()
    GadgetID =EventGadget()
    WindowID =EventWindow()

    Select EventID
      Case #PB_Event_CloseWindow
        Select WindowID
          Case #Window_FormMAIN
            quitFormMAIN=1
        EndSelect

      Case #PB_Event_Menu
        Select MenuID
          Case #MenuBar_FormMAIN_splash
          Case #MenuBar_FormMAIN_about
          Case #MenuBar_FormMAIN_quit
        EndSelect

      Case #PB_Event_Gadget
        Select GadgetID
          Case #Gadget_FormMAIN_ButtonINFO
          Case #Gadget_FormMAIN_ButtonOPEN
        EndSelect

    EndSelect
  Until quitFormMAIN
  CloseWindow(#Window_FormMAIN)
EndIf
End
