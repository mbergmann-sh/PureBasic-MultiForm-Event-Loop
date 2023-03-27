; PureVision v6.01 - Event Loop Template
; Basis Main Event Loop für Programme mit mehreren Dialogen / Forms
; Version 2.01 Stand 27.03.2023

CompilerIf  #PB_Compiler_OS = #PB_OS_Linux Or #PB_Compiler_OS = #PB_OS_MacOS
    XIncludeFile "multiform_Constants_linux_mac.pb"
CompilerElse
  XIncludeFile "multiform_Constants.pb"
CompilerEndIf

XIncludeFile "multiform_Windows.pb"

; -- Basis Event Main Loop --
If Window_FormMAIN()                 ; --> Öffne Hauptfenster (Format = Window_ + FormName)
  Repeat                             ; -> Hauptschleife ANFANG
    EventID  = WaitWindowEvent()     ; Warte auf ein Fenster-Event
    MenuID   = EventMenu()           ; Merke, wenn ein Menü-Eintrag gewählt wurde
    GadgetID = EventGadget()         ; Merke, wenn ein Gadget gewählt wurde
    WindowID = EventWindow()         ; Merke, für welches Fenster der Event gilt
    
    Select EventID                   ; Event auswerten  
      Case #PB_Event_Menu            ; wenn ein Menü-Eintrag gewählt wurde
        Select MenuID                ; stelle fest, welcher es war
          ; für jeden Menü-Eintrag, auf den eine Reaktion erfolgen soll, folgt hier eine CASE-Anweisung:
          ;*******************
          ;* FORM MAIN Menüs *
          ;*******************
          Case #MenuBar_FormMAIN_splash
            Window_FormSplash()
          Case #MenuBar_FormMAIN_about
            Result = MessageRequester("Über MultiForm Demo", "Dieses Programm demonstriert die Auswertung mehrerer Fenster mittels einer eigenen Event-Schleife", #PB_MessageRequester_Ok | #PB_MessageRequester_Info) 
          Case #MenuBar_FormMAIN_quit
            Result = MessageRequester("MultiForm Demo", "Programm beenden?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) 
            If Result = #PB_MessageRequester_Yes       ; Ja-Schalter wurde gedrückt
              Break
            EndIf
          ; Case Gadget_FormName_GadgetName
          ; Window_FormName                   ; --> Öffne Window / Form (Format = Window_ + FormName)
        EndSelect
        
      Case #PB_Event_Gadget          ; wenn ein Gadget ausgewählt wurde
        Select GadgetID              ; stelle fest, welches Gadget betroffen ist
            
          ; für jedes Gadget, auf das eine Reaktion erfolgen soll, folgt hier eine CASE-Anweisung:
          ;*********************
          ;* FORM MAIN Gadgets *
          ;*********************
          Case #Gadget_FormMAIN_ButtonINFO
            Result = MessageRequester("Über MultiForm Demo", "Dieses Programm demonstriert die Auswertung mehrerer Fenster mittels einer eigenen Event-Schleife", #PB_MessageRequester_Ok | #PB_MessageRequester_Info) 
          Case #Gadget_FormMAIN_ButtonOPEN
            Window_FormSplash()
          ; Case Gadget_FormName_GadgetName
          ; Window_FormName                   ; --> Öffne Window / Form (Format = Window_ + FormName)
            
          ;***********************
          ;* FORM Splash Gadgets *
          ;***********************
          Case #Gadget_FormSplash_ButtonEXIT
            Debug "Splash EXIT"
            CloseWindow(#Window_FormSplash)
          ; Case Gadget_FormName_GadgetName
              ; Window_FormName               ; --> Öffne Window / Form (Format = Window_ + FormName)
        EndSelect                         
    EndSelect
    
    If EventID = #PB_Event_CloseWindow        ; wenn ein Window / eine Form geschlossen werden soll...
      If WindowID = #Window_FormMAIN          ; ...und es das Hauptfenster ist...
        Result = MessageRequester("MultiForm Demo", "Programm beenden?", #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning) 
        If Result = #PB_MessageRequester_Yes       ; Ja-Schalter wurde gedrückt
          Break
        Else
          Continue
        EndIf                                 ; Beende den Event Loop
      EndIf
      CloseWindow(WindowID)                   ; Wenn es nicht das Hauptfenster ist, dann schließe es.
    EndIf
    
  ForEver   ; -> Hauptschleife ENDE
  ; Optional könnten hier vor Programmende noch Einstellungen gesichert werden
EndIf

End   ; --> Schließt alle noch offenen Fenster und gibt den reservierten Speicher frei
     
; IDE Options = PureBasic 6.01 LTS (Linux - x64)
; CursorPosition = 8
; Folding = -
; EnableXP
; DPIAware
; UseIcon = ..\..\Icon_Library\open_icon_library-win\icons\16x16\emblems\emblem-multimedia.ico