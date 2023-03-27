; PureVision v6.01 - Event Loop Template
; Basis Main Event Loop für Programme mit mehreren Dialogen / Forms
; Version 2.01 Stand 27.03.2023

XIncludeFile "MainCodeExport_Constants.pb"    ;-> anpassen!
XIncludeFile "MainCodeExport_Windows.pb"      ;-> anpassen!

; -- Basis Event Main Loop --
If Window_FormName()                 ; --> Öffne Hauptfenster (Format = Window_ + FormName)
  Repeat                             ; -> Hauptschleife ANFANG
    EventID  = WaitWindowEvent()     ; Warte auf ein Fenster-Event
    MenuID   = EventMenu()           ; Merke, wenn ein Menü-Eintrag gewählt wurde
    GadgetID = EventGadget()         ; Merke, wenn ein Gadget gewählt wurde
    WindowID = EventWindow()         ; Merke, für welches Fenster der Event gilt
    
    Select EventID                   ; Event auswerten  
      Case #PB_Event_Menu            ; wenn ein Menü-Eintrag gewählt wurde
        Select MenuID                ; stelle fest, welcher es war
          ; für jeden Menü-Eintrag, auf den eine Reaktion erfolgen soll, folgt hier eine CASE-Anweisung:
          ;****************
          ;* FORM 1 Menüs *
          ;****************
          ; Case Gadget_FormName_GadgetName
          ; Window_FormName                   ; --> Öffne Window / Form (Format = Window_ + FormName)
            
          ;****************
          ;* FORM 2 Menüs *
          ;****************
          ; Case Gadget_FormName_GadgetName
              ; Window_FormName               ; --> Öffne Window / Form (Format = Window_ + FormName)  
        EndSelect
        
      Case #PB_Event_Gadget          ; wenn ein Gadget ausgewählt wurde
        Select GadgetID              ; stelle fest, welches Gadget betroffen ist
            
          ; für jedes Gadget, auf das eine Reaktion erfolgen soll, folgt hier eine CASE-Anweisung:
          ;******************
          ;* FORM 1 Gadgets *
          ;******************
          ; Case Gadget_FormName_GadgetName
          ; Window_FormName                   ; --> Öffne Window / Form (Format = Window_ + FormName)
            
          ;******************
          ;* FORM 2 Gadgets *
          ;******************
          ; Case Gadget_FormName_GadgetName
              ; Window_FormName               ; --> Öffne Window / Form (Format = Window_ + FormName)
        EndSelect                         
    EndSelect
    
    If EventID = #PB_Event_CloseWindow        ; wenn ein Window / eine Form geschlossen werden soll...
      If WindowID = #Window_FormName          ; ...und es das Hauptfenster ist...
        Break                                 ; Beende den Event Loop
      EndIf
      CloseWindow(WindowID)                   ; Wenn es nicht das Hauptfenster ist, dann schließe es.
    EndIf
    
  ForEver   ; -> Hauptschleife ENDE
  ; Optional könnten hier vor Programmende noch Einstellungen gesichert werden
EndIf

End   ; --> Schließt alle noch offenen Fenster und gibt den reservierten Speicher frei
     
; IDE Options = PureBasic 6.01 LTS (Windows - x64)
; CursorPosition = 25
; EnableXP
; DPIAware