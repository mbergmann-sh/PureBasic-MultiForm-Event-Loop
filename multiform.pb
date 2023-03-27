;/ Created with PureVision64 v6.01 x64
;/ Mon, 27 Mar 2023 09:32:14
;/ by Michael Bergmann                




XIncludeFile "multiform_Constants.pb"
XIncludeFile "multiform_Windows.pb"






;- Main Loop
If Window_FormSplash()

  Define quitFormSplash=0
  Repeat
    EventID  =WaitWindowEvent()
    MenuID   =EventMenu()
    GadgetID =EventGadget()
    WindowID =EventWindow()

    Select EventID
      Case #PB_Event_CloseWindow
        Select WindowID
          Case #Window_FormSplash
            quitFormSplash=1
        EndSelect


      Case #PB_Event_Gadget
        Select GadgetID
          Case #Gadget_FormSplash_Image
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
              Case #PB_EventType_LeftClick
              Case #PB_EventType_RightDoubleClick
              Case #PB_EventType_RightClick
              Case #PB_EventType_DragStart
              Default
            EndSelect
          Case #Gadget_FormSplash_Image3
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
              Case #PB_EventType_LeftClick
              Case #PB_EventType_RightDoubleClick
              Case #PB_EventType_RightClick
              Case #PB_EventType_DragStart
              Default
            EndSelect
          Case #Gadget_FormSplash_ButtonEXIT
        EndSelect

    EndSelect
  Until quitFormSplash
  CloseWindow(#Window_FormSplash)
EndIf
End
