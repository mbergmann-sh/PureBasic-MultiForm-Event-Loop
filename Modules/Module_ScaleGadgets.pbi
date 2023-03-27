;-TOP

; Comment: ScaleGadget
; Author : mk-soft
; Version: v0.31
; Create : 27.11.2018
; Update : 01.09.2019
; OS     : All
;
; ***************************************************************************************

;
; Syntax for OwnerGadget Resize Callback 
;   OwnerGadgetCB(Gadget, x, y, Width, Height)
;  
; Syntax for Font Callback
;   OwnerFontCB(Gadget, ScaleX.d, ScaleY.d)
;  

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  Import "-no-pie" : EndImport
CompilerEndIf

;EnableExplicit

;- Begin DeclareModule ScaleGadgets

DeclareModule ScaleGadgets
  
  Enumeration 
    #ScaleModeReal ; Real coordinates
    #ScaleModeScaled ; Scaled coordinates
    #ScaleModeDynamic; Dynamic coordinates (Default)
  EndEnumeration
  
  Enumeration 
    #ScaleModeImageNone ; Scaled none
    #ScaleModeImageScaled ; Scaled size
    #ScaleModeImageDynamic; Dynamic size (Default)
  EndEnumeration
  
  Enumeration 
    #ScaleModeFontNone ; Scaled none
    #ScaleModeFontScaled ; Scaled size
    #ScaleModeFontDynamic; Dynamic size (Default)
  EndEnumeration
  
  ;- - ScaleGadget Framework
  Declare SetScaleGadget(x.f = 1.0, y.f = 1.0, dx.f = 1.0, dy.f = 1.0, Font.f = 0.0)
  Declare SetScaleWindow(x.f = 1.0, y.f = 1.0, dx.f = 1.0, dy.f = 1.0)
  Declare SetScaleFontID(Gadget, FontID)
  Declare SetScaleFontCallback(Gadget, *Callback)
  
  Declare SetScaleImage(Gadget, ImageID)
  Declare SetScaleMode(Mode) ; Set mode for result of position and size from windows and gadgets
  Declare SetScaleModeImage(Mode) ; Set mode update of images size
  Declare SetScaleModeFont(Mode)  ; Set mode update of font size
  
  Declare.f GetDynamicScaleX(Window) ; Returns the current dynamic scaling of ScaleAllGadgets
  Declare.f GetDynamicScaleY(Window) ; Returns the current dynamic scaling of ScaleAllGadgets
  
  Declare ScaleResizeGadget(Gadget, x, y, dx, dy) ; Resize gadget with scaling and dynamic scaling
  Declare ScaleResizeWindow(Window, x, y, dx, dy) ; Resize window
  Declare ScaleAllGadgets(Window, DeltaDY = 0)    ; Scales dynamic all gadgets from the window
  
  Declare ScaleOpenGadgetList(Gadget, GadgetItem = 0)
  Declare ScaleCloseGadgetList()
  Declare ScaleSetGadgetAttribute(Gadget, Attribute, Value)
  
  Declare ScaleWindowWidth(Window, Mode = #PB_Window_InnerCoordinate)
  Declare ScaleWindowHeight(Window, Mode = #PB_Window_InnerCoordinate)
  Declare ScaleWindowBounds(Window, MinimumWidth, MinimumHeight, MaximumWidth, MaximumHeight)
  Declare ScaleGadgetX(Gadget, Mode = 0)
  Declare ScaleGadgetY(Gadget, Mode = 0)
  Declare ScaleGadgetWidth(Gadget, Mode = 0)
  Declare ScaleGadgetHeight(Gadget, Mode = 0)
  
  Declare ScaleCloseWindow(Window)
  Declare ScaleFreeGadget(Gadget)
  
  Declare ScaleRegisterGadget(Gadget, *Callback = 0, Name.s = "") ; Register your owner draw gadget
  Declare ScaleUnregisterGadget(Gadget)                           ; Unregister your owner draw gadget
  
  Declare ScaleUpdateGadget(Gadget)
  
  Declare CreateWindow(Name.s, Window, x, y, InnerWidth, InnerHeight, Title.s, Flags, ParentID)
  Declare CreateGadget(Type, Name.s, Gadget, x, y, dx, dy, Text.s, Param1, Param2, Param3, Flags)
  
  Declare ParentWindow(Gadget)
  Declare ParentGadget(Gadget)
  
  ;- - Font Framework
  
  Declare ScaleLoadFont(Font, Name.s, Height, Style = 0)
  Declare ScaleFreeFont(Font)
  Declare.s GetScaleFontName(Font)
  Declare GetScaleFontHeight(Font)
  Declare GetScaleFontStyle(Font)
  
  ;- - Declare Macros
  Macro dq
    "
  EndMacro
  
  ;- - Create Window´s
  Macro OpenWindow(Window, x, y, InnerWidth, InnerHeight, Title, Flags = 0, ParentID = 0)
    CreateWindow(dq#Window#dq, Window, x, y, InnerWidth, InnerHeight, Title, Flags, ParentID)
  EndMacro
  
  ;- - Create Gadget´s
  Macro ButtonGadget(Gadget, x, y, dx, dy, text, Flags = 0)
    CreateGadget(#PB_GadgetType_Button, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, Flags)
  EndMacro
  
  Macro ButtonImageGadget(Gadget, x, y, dx, dy, ImageID, Flags = 0)
    CreateGadget(#PB_GadgetType_ButtonImage, dq#Gadget#dq, Gadget, x, y, dx, dy, "", ImageID, 0, 0, Flags)
  EndMacro
  
  Macro CalendarGadget(gadget, x, y, dx, dy, Date, Flags = 0)
    CreateGadget(#PB_GadgetType_Calendar, dq#Gadget#dq, Gadget, x, y, dx, dy, "", Date, 0, 0, Flags)
  EndMacro
  
  Macro CanvasGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_Canvas, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  Macro CheckBoxGadget(gadget, x, y, dx, dy, text, Flags = 0)
    CreateGadget(#PB_GadgetType_CheckBox, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, Flags)
  EndMacro
  
  Macro ComboBoxGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_ComboBox, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  Macro ContainerGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_Container, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  Macro DateGadget(gadget, x, y, dx, dy, Mask, Date, Flags = 0)
    CreateGadget(#PB_GadgetType_Date, dq#Gadget#dq, Gadget, x, y, dx, dy, Mask, Date, 0, 0, Flags)
  EndMacro
  
  Macro EditorGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_Editor, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  Macro ExplorerComboGadget(gadget, x, y, dx, dy, Directory, Flags = 0)
    CreateGadget(#PB_GadgetType_ExplorerCombo, dq#Gadget#dq, Gadget, x, y, dx, dy, Directory, 0, 0, 0, Flags)
  EndMacro
  
  Macro ExplorerListGadget(gadget, x, y, dx, dy, Directory, Flags = 0)
    CreateGadget(#PB_GadgetType_ExplorerList, dq#Gadget#dq, Gadget, x, y, dx, dy, Directory, 0, 0, 0, Flags)
  EndMacro
  
  Macro ExplorerTreeGadget(gadget, x, y, dx, dy, Directory, Flags = 0)
    CreateGadget(#PB_GadgetType_ExplorerTree, dq#Gadget#dq, Gadget, x, y, dx, dy, Directory, 0, 0, 0, Flags)
  EndMacro
  
  Macro FrameGadget(gadget, x, y, dx, dy, text, Flags = 0)
    CreateGadget(#PB_GadgetType_Frame, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, Flags)
  EndMacro
  
  Macro HyperLinkGadget(gadget, x, y, dx, dy, text, Color, Flags = 0)
    CreateGadget(#PB_GadgetType_HyperLink, dq#Gadget#dq, Gadget, x, y, dx, dy, text, Color, 0, 0, Flags)
  EndMacro
  
  Macro ImageGadget(gadget, x, y, dx, dy, ImageID, Flags = 0)
    CreateGadget(#PB_GadgetType_Image, dq#Gadget#dq, Gadget, x, y, dx, dy, "", ImageID, 0, 0, Flags)
  EndMacro
  
  Macro IPAddressGadget(gadget, x, y, dx, dy)
    CreateGadget(#PB_GadgetType_IPAddress, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, 0)
  EndMacro
  
  Macro ListIconGadget(gadget, x, y, dx, dy, Titel, TitelWidth, Flags = 0)
    CreateGadget(#PB_GadgetType_ListIcon, dq#Gadget#dq, Gadget, x, y, dx, dy, Titel, TitelWidth, 0, 0, Flags)
  EndMacro
  
  Macro ListViewGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_ListView, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Macro MDIGadget(gadget, x, y, dx, dy, SubMenu, FirstMenuItem, Flags = 0)
      CreateGadget(#PB_GadgetType_MDI, dq#Gadget#dq, Gadget, x, y, dx, dy, "", SubMenu, FirstMenuItem, 0, Flags)
    EndMacro
  CompilerEndIf
  
  Macro OptionGadget(gadget, x, y, dx, dy, text)
    CreateGadget(#PB_GadgetType_Option, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, 0)
  EndMacro
  
  Macro PanelGadget(gadget, x, y, dx, dy)
    CreateGadget(#PB_GadgetType_Panel, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, 0)
  EndMacro
  
  Macro ProgressBarGadget(gadget, x, y, dx, dy, Minimum, Maximum, Flags = 0)
    CreateGadget(#PB_GadgetType_ProgressBar, dq#Gadget#dq, Gadget, x, y, dx, dy, "", Minimum, Maximum, 0, Flags)
  EndMacro
  
  Macro ScintillaGadget(gadget, x, y, dx, dy, Callback)
    CreateGadget(#PB_GadgetType_Scintilla, dq#Gadget#dq, Gadget, x, y, dx, dy, "", Callback, 0, 0, 0)
  EndMacro
  
  Macro ScrollAreaGadget(gadget, x, y, dx, dy, param1, param2, param3, Flags = 0)
    CreateGadget(#PB_GadgetType_ScrollArea, dq#Gadget#dq, Gadget, x, y, dx, dy, "", param1, param2, param3, Flags)
  EndMacro
  
  Macro ScrollBarGadget(gadget, x, y, dx, dy, param1, param2, param3, Flags = 0)
    CreateGadget(#PB_GadgetType_ScrollBar, dq#Gadget#dq, Gadget, x, y, dx, dy, "", param1, parma2, param3, Flags)
  EndMacro
  
  Macro ShortcutGadget(gadget, x, y, dx, dy, Shortcut)
    CreateGadget(#PB_GadgetType_Shortcut, dq#Gadget#dq, Gadget, x, y, dx, dy, "", Shortcut, 0, 0, 0)
  EndMacro
  
  Macro SpinGadget(gadget, x, y, dx, dy, param1, param2, Flags = 0)
    CreateGadget(#PB_GadgetType_Spin, dq#Gadget#dq, Gadget, x, y, dx, dy, "", param1, param2, 0, Flags)
  EndMacro
  
  Macro SplitterGadget(gadget, x, y, dx, dy, param1, param2, Flags = 0)
    CreateGadget(#PB_GadgetType_Splitter, dq#Gadget#dq, Gadget, x, y, dx, dy, "", param1, param2, 0, Flags)
  EndMacro
  
  Macro StringGadget(gadget, x, y, dx, dy, text, Flags = 0)
    CreateGadget(#PB_GadgetType_String, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, Flags)
  EndMacro
  
  Macro TextGadget(gadget, x, y, dx, dy, text, Flags = 0)
    CreateGadget(#PB_GadgetType_Text, dq#Gadget#dq, Gadget, x, y, dx, dy, text, 0, 0, 0, Flags)
  EndMacro
  
  Macro TrackBarGadget(gadget, x, y, dx, dy, param1, param2, Flags = 0)
    CreateGadget(#PB_GadgetType_TrackBar, dq#Gadget#dq, Gadget, x, y, dx, dy, "", param1, param2, 0, Flags)
  EndMacro
  
  Macro TreeGadget(gadget, x, y, dx, dy, Flags = 0)
    CreateGadget(#PB_GadgetType_Tree, dq#Gadget#dq, Gadget, x, y, dx, dy, "", 0, 0, 0, Flags)
  EndMacro
  
  Macro WebGadget(gadget, x, y, dx, dy, url)
    CreateGadget(#PB_GadgetType_Web, dq#Gadget#dq, Gadget, x, y, dx, dy, url, 0, 0, 0, 0)
  EndMacro
  
  ;- - Window and Gadget Functions
  
  Macro CloseWindow(Window)
    ScaleCloseWindow(Window)
  EndMacro
  
  Macro FreeGadget(Gadget)
    ScaleFreeGadget(Gadget)
  EndMacro
  
  Macro OpenGadgetList(Gadget, GadgetItem = 0)
    ScaleOpenGadgetList(Gadget, GadgetItem)
  EndMacro
  
  Macro CloseGadgetList()
    ScaleCloseGadgetList()
  EndMacro
  
  Macro SetGadgetAttribute(Gadget, Attribute, Value)
    ScaleSetGadgetAttribute(Gadget, Attribute, Value)
  EndMacro
  
  ;- Size Functions
  
  Macro ResizeWindow(window, x, y, dx, dy)
    ScaleResizeWindow(window, x, y, dx, dy)
  EndMacro
  
  Macro ResizeGadget(gadget, x, y, dx, dy)
    ScaleResizeGadget(gadget, x, y, dx, dy)
  EndMacro
  
  Macro WindowWidth(Window, Mode = #PB_Window_InnerCoordinate)
    ScaleWindowWidth(Window, Mode)
  EndMacro
  
  Macro WindowHeight(Window, Mode = #PB_Window_InnerCoordinate)
    ScaleWindowHeight(Window, Mode)
  EndMacro
  
  Macro WindowBounds(Window, MinimumWidth, MinimumHeight, MaximumWidth, MaximumHeight)
    ScaleWindowBounds(Window, MinimumWidth, MinimumHeight, MaximumWidth, MaximumHeight)
  EndMacro
  
  Macro GadgetX(Gadget, Mode = 0)
    ScaleGadgetX(Gadget, Mode)
  EndMacro
  
  Macro GadgetY(Gadget, Mode = 0)
    ScaleGadgetY(Gadget, Mode)
  EndMacro
  
  Macro GadgetWidth(Gadget, Mode = 0)
    ScaleGadgetWidth(Gadget, Mode)
  EndMacro
  
  Macro GadgetHeight(Gadget, Mode = 0)
    ScaleGadgetHeight(Gadget, Mode)
  EndMacro
  
  ;- Font Function
  
  Macro LoadFont(Font, Name, Height, Style = 0)
    ScaleLoadFont(Font, Name, Height, Style)
  EndMacro
  
  Macro FreeFont(Font)
    ScaleFreeFont(Font)
  EndMacro
  
  Macro SetGadgetFont(Gadget, FontID)
    SetScaleFontID(Gadget, FontID)
  EndMacro
  
  ;- Scale All
  Macro SetScale(Factor, Font = 0.0)
    SetScaleGadget(Factor, Factor, Factor, Factor, Font)
    SetScaleWindow(Factor, Factor, Factor, Factor)
  EndMacro
  
EndDeclareModule

;- Begin Module ScaleGadgets

Module ScaleGadgets
  
  EnableExplicit
  
  ; Force to call orginal PB-Function
  Macro PB(Function)
    Function
  EndMacro
  
  ; -----------------------------------------------------------------------------------
  
  ;-- Import internal function
  
  ; Force Import Fonts
  Global __Dummy = PB(LoadFont)(#PB_Any, "", 11) : PB(FreeFont)(__Dummy)
  
  ; Actual Parent Gadget
  Global ActGadget = -1
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Import ""
      PB_Object_EnumerateStart( PB_Objects )
      PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
      PB_Object_EnumerateAbort( PB_Objects )
      PB_Object_GetObject( PB_Object , DynamicOrArrayID)
      PB_Window_Objects.i
      PB_Gadget_Objects.i
      PB_Image_Objects.i
      PB_Font_Objects.i
    EndImport
  CompilerElse
    ImportC ""
      PB_Object_EnumerateStart( PB_Objects )
      PB_Object_EnumerateNext( PB_Objects, *ID.Integer )
      PB_Object_EnumerateAbort( PB_Objects )
      PB_Object_GetObject( PB_Object , DynamicOrArrayID)
      PB_Window_Objects.i
      PB_Gadget_Objects.i
      PB_Image_Objects.i
      PB_Font_Objects.i
    EndImport
  CompilerEndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
    ; PB Interne Struktur Gadget MacOS
    Structure sdkGadget
      *gadget
      *container
      *vt
      UserData.i
      Window.i
      Type.i
      Flags.i
    EndStructure
  CompilerEndIf
  
  ; -----------------------------------------------------------------------------------
  
  Procedure WindowPB(WindowID) ; Find pb-id over handle
    Protected result, window
    result = -1
    PB_Object_EnumerateStart(PB_Window_Objects)
    While PB_Object_EnumerateNext(PB_Window_Objects, @window)
      If WindowID = WindowID(window)
        result = window
        Break
      EndIf
    Wend
    PB_Object_EnumerateAbort(PB_Window_Objects)
    ProcedureReturn result
  EndProcedure
  
  ; ---------------------------------------------------------------------------------------
  
  Procedure GadgetPB(GadgetID) ; Find pb-id over handle
    Protected result, gadget
    result = -1
    PB_Object_EnumerateStart(PB_Gadget_Objects)
    While PB_Object_EnumerateNext(PB_Gadget_Objects, @gadget)
      If GadgetID = GadgetID(gadget)
        result = gadget
        Break
      EndIf
    Wend
    PB_Object_EnumerateAbort(PB_Gadget_Objects)
    ProcedureReturn result
  EndProcedure
  
  ; ---------------------------------------------------------------------------------------
  
  Procedure ImagePB(ImageID) ; Find pb-id over handle
    Protected result, image
    result = -1
    PB_Object_EnumerateStart(PB_Image_Objects)
    While PB_Object_EnumerateNext(PB_Image_Objects, @image)
      If ImageID = ImageID(image)
        result = image
        Break
      EndIf
    Wend
    PB_Object_EnumerateAbort(PB_Image_Objects)
    ProcedureReturn result
  EndProcedure
  
  ; ---------------------------------------------------------------------------------------
  
  ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  ;- Declare Globals
  
  #ScaleFontMin = 7
  #ScaleFontMax = 27
  
  #ScaleMinimumDX = 1
  #ScaleMinimumDY = 1
  
  
  ; Prototype for OwnerGadget Resize Callback 
  Prototype OwnerGadgetCB(Gadget, x, y, Width, Height)
  
  ; Prototype for Font Callback
  Prototype OwnerFontCB(Gadget, ScaleX.d, ScaleY.d)
  
  Structure ArrayOfInteger
    i.i[0]
  EndStructure
  
  Structure udtWindowList
    ; Header
    Name.s
    Window.i
    ; Data
    x.i
    y.i
    dx.i
    dy.i
    ; Dynamics Scale
    ScaleX.d
    ScaleY.d
  EndStructure
  
  Structure udtGadgetList
    ; Header
    Name.s
    Gadget.i
    Parent.i
    Window.i
    ; Size
    x.i
    y.i
    dx.i
    dy.i
    ; Dynamics Scale
    ScaleX.d
    ScaleY.d
    ; Font
    FontID.i
    ScaleFont.i
    FontName.s
    FontHeight.i
    FontStyle.i
    FontSize.i
    *FontArray.ArrayOfInteger
    FontMin.i
    FontMax.i
    *FontCallback.OwnerFontCB
    ; Image
    Image.i
    ScaleImage.i
    ImageDX.i
    ImageDY.i
    ; Owner Gadgets 
    *GadgetCallback.OwnerGadgetCB
  EndStructure
  
  Structure udtFontList
    Font.i
    FontID.i
    Name.s
    Height.i
    Style.i
  EndStructure
  
  Global NewMap WindowList.udtWindowList()
  Global NewMap GadgetList.udtGadgetList()
  Global NewMap FontList.udtFontList()
  
  Global.d ScaleGadgetX, ScaleGadgetY, ScaleGadgetDX, ScaleGadgetDY
  Global.d ScaleWindowX, ScaleWindowY, ScaleWindowDX, ScaleWindowDY
  Global.d ScaleFontFactor
  Global.d ScaleFontXY
  
  Global.i ScaleMode
  Global.i ScaleModeImage
  Global.i ScaleModeFont
  
  Global ScaleDefaultFont.i
  Global ScaleDefaultScaleFont.i
  Global ScaleDefaultFontName.s
  Global ScaleDefaultFontHeight.i
  Global ScaleDefaultFontStyle.i
  Global ScaleDefaultFontSize.i
  
  Global DefaultFontID
  
  ; ---------------------------------------------------------------------------------------
  
  ;- ScaleGadget Framework
  
  Declare _ScaleUpdateGadget(*Gadget.udtGadgetList)
  
  ; -----------------------------------------------------------------------------------
  
  Procedure InitModule()
    
    ScaleGadgetX = 1.0
    ScaleGadgetY = 1.0
    ScaleGadgetDX = 1.0
    ScaleGadgetDY = 1.0
    ScaleWindowX = 1.0
    ScaleWindowY = 1.0
    ScaleWindowDX = 1.0
    ScaleWindowDY = 1.0
    ScaleFontXY = 1.0
    ScaleMode = #ScaleModeDynamic
    ScaleModeImage = #ScaleModeImageDynamic
    ScaleModeFont = #ScaleModeFontDynamic
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ScaleFontFactor = 0.9
      CompilerCase #PB_OS_Linux
        ScaleFontFactor = 1.0
      CompilerCase #PB_OS_MacOS
        ScaleFontFactor = 1.2
    CompilerEndSelect
    
    ScaleDefaultFontName = ""
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Windows
        ScaleDefaultFontHeight = 9
      CompilerCase #PB_OS_Linux
        ScaleDefaultFontHeight = 10
      CompilerCase #PB_OS_MacOS
        ScaleDefaultFontHeight = 12
    CompilerEndSelect
    ScaleDefaultFontStyle = 0
    ScaleDefaultFontSize = 0
    ScaleDefaultFont = PB(LoadFont)(#PB_Any, ScaleDefaultFontName, ScaleDefaultFontHeight, ScaleDefaultFontStyle)
    PB(SetGadgetFont)(#PB_Default, FontID(ScaleDefaultFont))
    
  EndProcedure : InitModule()
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleGadget(x.f = 1.0, y.f = 1.0, dx.f = 1.0, dy.f = 1.0, Font.f = 0.0)
    Protected ScaleFont
    ScaleGadgetX = x
    ScaleGadgetY = y
    ScaleGadgetDX = dx
    ScaleGadgetDY = dy
    ScaleFontXY = Font
    If Font = 0.0
      ScaleFontXY = dy
    Else 
      ScaleFontXY = Font
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleWindow(x.f = 1.0, y.f = 1.0, dx.f = 1.0, dy.f = 1.0)
    ScaleWindowX = x
    ScaleWindowY = y
    ScaleWindowDX = dx
    ScaleWindowDY = dy
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleMode(Mode)
    Select Mode
      Case #ScaleModeReal, #ScaleModeScaled, #ScaleModeDynamic
        ScaleMode = Mode
    EndSelect
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleModeImage(Mode)
    Select Mode
      Case #ScaleModeImageNone, #ScaleModeImageScaled, #ScaleModeImageDynamic
        ScaleModeImage = Mode
    EndSelect
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleModeFont(Mode)
    Select Mode
      Case #ScaleModeFontNone, #ScaleModeFontScaled, #ScaleModeFontDynamic
        ScaleModeFont = Mode
    EndSelect
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleFontID(Gadget, FontID)
    If Gadget = #PB_Default
      DefaultFontID = FontID
    Else
      With GadgetList()
        If FindMapElement(GadgetList(), Hex(Gadget))
          \FontID = FontID
          If FindMapElement(FontList(), Hex(FontID))
            \FontName = FontList()\Name
            \FontHeight = FontList()\Height
            \FontStyle = FontList()\Style
            \FontSize = 0
          EndIf
          _ScaleUpdateGadget(GadgetList())
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleFontCallback(Gadget, *Callback)
    If FindMapElement(GadgetList(), Hex(Gadget))
      GadgetList()\FontCallback = *Callback
      _ScaleUpdateGadget(GadgetList())
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure SetScaleImage(Gadget, Image)
    If FindMapElement(GadgetList(), Hex(Gadget))
      With GadgetList()
        \Image = Image
        \ImageDX = 0
        \ImageDY = 0
        _ScaleUpdateGadget(GadgetList())
      EndWith
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure.f GetDynamicScaleX(Window)
    If FindMapElement(WindowList(), Hex(Window))
      ProcedureReturn WindowList()\ScaleX
    Else
      ProcedureReturn 1.0
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure.f GetDynamicScaleY(Window)
    If FindMapElement(WindowList(), Hex(Window))
      ProcedureReturn WindowList()\ScaleY
    Else
      ProcedureReturn 1.0
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleResizeWindow(Window, x, y, dx, dy)
    If dx <> #PB_Ignore
      dx = dx * ScaleWindowDX
    EndIf
    If dy <> #PB_Ignore
      dy = dy * ScaleWindowDY
    EndIf
    PB(ResizeWindow)(Window, x, y, dx, dy)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleResizeGadget(Gadget, x, y, dx, dy)
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If x <> #PB_Ignore
          If x < 0 : x = 0: EndIf
          \x = x
        EndIf
        If y <> #PB_Ignore
          If y < 0 : y = 0: EndIf
          \y = y
        EndIf
        If dx <> #PB_Ignore
          If dx < #ScaleMinimumDX : dx = #ScaleMinimumDX : EndIf
          \dx = dx
        EndIf
        If dy <> #PB_Ignore
          If dy < #ScaleMinimumDY : dy = #ScaleMinimumDY: EndIf
          \dy = dy
        EndIf
        _ScaleUpdateGadget(GadgetList())
      Else
        PB(ResizeGadget)(Gadget, x, y, dx, dy)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleWindowWidth(Window, Mode = #PB_Window_InnerCoordinate)
    If #PB_Window_FrameCoordinate
      ProcedureReturn PB(WindowWidth)(Window, Mode)
    EndIf
    Select ScaleMode
      Case #ScaleModeReal
        ProcedureReturn PB(WindowWidth)(Window)
      Case #ScaleModeScaled
        ProcedureReturn PB(WindowWidth)(Window) / ScaleWindowDX
      Case #ScaleModeDynamic
        If FindMapElement(WindowList(), Hex(Window))
          ProcedureReturn PB(WindowWidth)(Window) / ScaleWindowDX / WindowList()\ScaleX
        EndIf
    EndSelect
    ProcedureReturn PB(WindowWidth)(Window)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleWindowHeight(Window, Mode = #PB_Window_InnerCoordinate)
    If #PB_Window_FrameCoordinate
      ProcedureReturn PB(WindowHeight)(Window, Mode)
    EndIf
    Select ScaleMode
      Case #ScaleModeReal
        ProcedureReturn PB(WindowHeight)(Window)
      Case #ScaleModeScaled
        ProcedureReturn PB(WindowHeight)(Window) / ScaleWindowDY
      Case #ScaleModeDynamic
        If FindMapElement(WindowList(), Hex(Window))
          ProcedureReturn PB(WindowHeight)(Window) / ScaleWindowDY / WindowList()\ScaleY
        EndIf
    EndSelect
    ProcedureReturn PB(WindowHeight)(Window)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleWindowBounds(Window, MinimumWidth, MinimumHeight, MaximumWidth, MaximumHeight)
    If MinimumWidth <> #PB_Ignore
      MinimumWidth = MinimumWidth * ScaleWindowDX
    EndIf
    If MinimumHeight <> #PB_Ignore
      MinimumHeight = MinimumHeight * ScaleWindowDY
    EndIf
    If MaximumWidth <> #PB_Ignore
      MaximumWidth = MaximumWidth * ScaleWindowDX
    EndIf
    If MaximumHeight <> #PB_Ignore
      MaximumHeight = MaximumHeight * ScaleWindowDY
    EndIf
    PB(WindowBounds)(Window, MinimumWidth, MinimumHeight, MaximumWidth, MaximumHeight)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleGadgetX(Gadget, Mode = 0)
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If Mode
          ProcedureReturn PB(GadgetX)(Gadget, Mode)
        Else  
          Select ScaleMode
            Case #ScaleModeReal
              ProcedureReturn PB(GadgetX)(Gadget)
            Case #ScaleModeScaled
              ProcedureReturn GadgetList()\x * \ScaleX
            Case #ScaleModeDynamic
              ProcedureReturn GadgetList()\x
          EndSelect
        EndIf
      Else
        ProcedureReturn PB(GadgetX)(Gadget, Mode)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleGadgetY(Gadget, Mode = 0)
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If Mode
          ProcedureReturn PB(GadgetX)(Gadget, Mode)
        Else
          Select ScaleMode
            Case #ScaleModeReal
              ProcedureReturn PB(GadgetY)(Gadget)
            Case #ScaleModeScaled
              ProcedureReturn GadgetList()\y * \ScaleY
            Case #ScaleModeDynamic
              ProcedureReturn GadgetList()\y
          EndSelect
        EndIf
      Else
        ProcedureReturn PB(GadgetY)(Gadget, Mode)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleGadgetWidth(Gadget, Mode = 0)
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If Mode
          ProcedureReturn PB(GadgetWidth)(Gadget, Mode)
        Else
          Select ScaleMode
            Case #ScaleModeReal
              ProcedureReturn PB(GadgetWidth)(Gadget)
            Case #ScaleModeScaled
              ProcedureReturn GadgetList()\dx * \ScaleX
            Case #ScaleModeDynamic
              ProcedureReturn GadgetList()\dx
          EndSelect
        EndIf
      Else
        ProcedureReturn PB(GadgetWidth)(Gadget, Mode)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleGadgetHeight(Gadget, Mode = 0)
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If Mode
          ProcedureReturn PB(GadgetHeight)(Gadget, Mode)
        Else
          Select ScaleMode
            Case #ScaleModeReal
              ProcedureReturn PB(GadgetHeight)(Gadget)
            Case #ScaleModeScaled
              ProcedureReturn GadgetList()\dy * \ScaleY
            Case #ScaleModeDynamic
              ProcedureReturn GadgetList()\dy
          EndSelect
        EndIf
      Else
        ProcedureReturn PB(GadgetHeight)(Gadget, Mode)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleUpdateGadget(Gadget)
    If FindMapElement(GadgetList(), Hex(Gadget))
      _ScaleUpdateGadget(GadgetList())
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure _ScaleUpdateGadget(*Gadget.udtGadgetList)
    Protected ScaleX.f, ScaleY.f, x, y, dx, dy, FontSize, ImageDX, ImageDY
    
    With *Gadget
      ScaleX = \ScaleX
      ScaleY = \ScaleY
      If \Parent >= 0 And IsGadget(\Parent) And GadgetType(\Parent) = #PB_GadgetType_Splitter
        ; Do Nothing  
      Else
        x = \x * ScaleGadgetX * ScaleX
        y = \y * ScaleGadgetY * ScaleY
        dx = \dx * ScaleGadgetDX * ScaleX
        dy = \dy * ScaleGadgetDY * ScaleY
        If x < 0 : x = 0: EndIf
        If y < 0 : y = 0: EndIf
        If dx < #ScaleMinimumDX : dx = #ScaleMinimumDX : EndIf
        If dy < #ScaleMinimumDY : dy = #ScaleMinimumDY: EndIf
        PB(ResizeGadget)(\Gadget, x , y, dx, dy)
      EndIf
      If \GadgetCallback > 0
        \GadgetCallback(\Gadget, x, y, dx , dy)
      Else
        ; Font
        If \FontID
          If ScaleModeFont = #ScaleModeFontNone
            If \FontSize
              \FontSize = 0
              PB(SetGadgetFont)(\Gadget, \FontID)
            EndIf
          Else
            If ScaleModeFont = #ScaleModeFontScaled
              If ScaleX < ScaleY
                FontSize = \FontHeight * ScaleFontXY 
              Else
                FontSize = \FontHeight * ScaleFontXY
              EndIf  
            Else
              If ScaleX < ScaleY
                FontSize = \FontHeight * ScaleFontXY * ScaleX 
              Else
                FontSize = \FontHeight * ScaleFontXY * ScaleY
              EndIf  
            EndIf  
            If FontSize < #ScaleFontMin
              FontSize = #ScaleFontMin
            EndIf
            If FontSize <> \FontSize
              \FontSize = FontSize
              If \ScaleFont And IsFont(\ScaleFont)
                PB(FreeFont)(\ScaleFont)
              EndIf
              \ScaleFont = PB(LoadFont)(#PB_Any, \FontName, FontSize, \FontStyle)
              PB(SetGadgetFont)(\Gadget, FontID(\ScaleFont))
            EndIf  
          EndIf 
        ElseIf \FontCallback
          \FontCallback(\Gadget, ScaleGadgetDX * ScaleX, ScaleGadgetDY * ScaleY)
        ElseIf ScaleDefaultFont
          If ScaleModeFont = #ScaleModeFontNone
            If \FontSize
              \FontSize = 0
              PB(SetGadgetFont)(\Gadget, FontID(ScaleDefaultFont))
            EndIf
          Else
            If ScaleModeFont = #ScaleModeFontScaled
              If ScaleX < ScaleY
                FontSize = ScaleDefaultFontHeight * ScaleFontXY 
              Else
                FontSize = ScaleDefaultFontHeight * ScaleFontXY
              EndIf  
            Else
              If ScaleX < ScaleY
                FontSize = ScaleDefaultFontHeight * ScaleFontXY * ScaleX 
              Else
                FontSize = ScaleDefaultFontHeight * ScaleFontXY * ScaleY
              EndIf  
            EndIf
            If FontSize < #ScaleFontMin
              FontSize = #ScaleFontMin
            EndIf
            If FontSize <> ScaleDefaultFontSize
              ScaleDefaultFontSize = FontSize
              If ScaleDefaultScaleFont And IsFont(ScaleDefaultScaleFont)
                PB(FreeFont)(ScaleDefaultScaleFont)
              EndIf
              ScaleDefaultScaleFont = PB(LoadFont)(#PB_Any, ScaleDefaultFontName, FontSize, ScaleDefaultFontStyle)
            EndIf
            If FontSize <> \FontSize
              \FontSize = FontSize
              PB(SetGadgetFont)(\Gadget, FontID(ScaleDefaultScaleFont))
            EndIf
          EndIf 
        EndIf
        ; Images
        If \Image >= 0
          If ScaleModeImage = #ScaleModeImageNone
            If \ImageDX
              \ImageDX = 0
              \ImageDY = 0
              Select GadgetType(\Gadget)
                Case #PB_GadgetType_ButtonImage
                  PB(SetGadgetAttribute)(\Gadget, #PB_Button_Image, ImageID(\Image))
                Case #PB_GadgetType_Image
                  PB(SetGadgetState)(\Gadget, ImageID(\Image))
              EndSelect
            EndIf
          Else
            If ScaleModeImage = #ScaleModeImageScaled
              ImageDX = ImageWidth(\Image) * ScaleGadgetDX
              ImageDY = ImageHeight(\Image) * ScaleGadgetDY
            Else
              ImageDX = ImageWidth(\Image) * ScaleGadgetDX * ScaleX
              ImageDY = ImageHeight(\Image) * ScaleGadgetDY * ScaleY
            EndIf
            If ImageDX < 1
              ImageDX = 1
            EndIf
            If ImageDY < 1
              ImageDY = 1
            EndIf
            If ImageDX <> \ImageDX Or ImageDY <> \ImageDY
              \ImageDX = ImageDX
              \ImageDY = ImageDY
              If IsImage(\ScaleImage)
                FreeImage(\scaleimage)
              EndIf
              \ScaleImage = CopyImage(\image, #PB_Any)
DisableDebugger : PB(ResizeImage)(\ScaleImage, ImageDX, ImageDY) : EnableDebugger
              Select GadgetType(\Gadget)
                Case #PB_GadgetType_ButtonImage
                  PB(SetGadgetAttribute)(\Gadget, #PB_Button_Image, ImageID(\ScaleImage))
                Case #PB_GadgetType_Image
                  PB(SetGadgetState)(\Gadget, ImageID(\ScaleImage))
              EndSelect
            EndIf
          EndIf
        EndIf
      EndIf
    EndWith
    
  EndProcedure
  
  ; ---------------------------------------------------------------------------------------
  
  Procedure ScaleAllGadgets(Window, DeltaDY = 0)
    Protected ScaleX.f, ScaleY.f, font, x, y, dx, dy
    
    If Not FindMapElement(WindowList(), Hex(Window))
      ProcedureReturn 0
    EndIf
    
    With WindowList()
      ScaleX = PB(WindowWidth)(Window) / \dx
      ScaleY = (PB(WindowHeight)(Window) - DeltaDY) / (\dy - DeltaDY)
      \ScaleX = ScaleX
      \ScaleY = ScaleY
    EndWith
    
    With GadgetList()
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SendMessage_(WindowID(Window), #WM_SETREDRAW, 0, 0)
      CompilerEndIf
      ForEach GadgetList()
        If \Window = Window
          If Not IsGadget(\Gadget)
            If \ScaleImage And IsImage(\ScaleImage)
              FreeImage(\ScaleImage)
            EndIf
            If \ScaleFont And IsFont(\ScaleFont)
              FreeFont(\ScaleFont)
            EndIf
            DeleteMapElement(GadgetList())
            Continue
          EndIf
          \ScaleX = ScaleX
          \ScaleY = ScaleY
          _ScaleUpdateGadget(GadgetList())
        EndIf
      Next
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        SendMessage_(WindowID(Window), #WM_SETREDRAW, 1, 0)
        InvalidateRect_(WindowID(Window), 0, 1)
      CompilerEndIf
    EndWith
    
  EndProcedure
  
  ; ---------------------------------------------------------------------------------------
  
  Procedure ScaleOpenGadgetList(Gadget, GadgetItem = 0)
    ActGadget = Gadget
    PB(OpenGadgetList)(Gadget, GadgetItem)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleCloseGadgetList()
    If FindMapElement(GadgetList(), Hex(ActGadget))
      ActGadget = GadgetList()\Parent
    Else
      ActGadget = -1
    EndIf
    PB(CloseGadgetList)()
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleSetGadgetAttribute(Gadget, Attribute, Value)
    Protected Window
    With GadgetList()
      PB(SetGadgetAttribute)(Gadget, Attribute, Value)
      If Attribute = #PB_Splitter_FirstGadget Or Attribute = #PB_Splitter_SecondGadget
        If FindMapElement(GadgetList(), Hex(Gadget))
          window = \Window
          If FindMapElement(GadgetList(), Hex(Value))
            GadgetList()\Window = Window
            GadgetList()\Parent = Gadget
          EndIf
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleRegisterGadget(Gadget, *Callback = 0, Name.s = "")
    Protected *gadget.udtGadgetList
    Protected x, y, dx, dy
    
    If Not IsGadget(Gadget)
      ProcedureReturn
    EndIf
    
    x = PB(GadgetX)(Gadget)
    y = PB(GadgetY)(Gadget)
    dx = PB(GadgetWidth)(Gadget)
    dy = PB(GadgetHeight)(Gadget)
    
    *gadget = AddMapElement(GadgetList(), Hex(Gadget))
    
    With *gadget
      \Name = Name
      \Gadget = Gadget
      \Parent = ActGadget
      \Window = WindowPB(UseGadgetList(0))
      \x = x
      \y = y
      \dx = dx
      \dy = dy
      \image = -1
      \GadgetCallback = *Callback
      If FindMapElement(WindowList(), Hex(\Window))
        \ScaleX = WindowList()\ScaleX
        \ScaleY = WindowList()\ScaleY
      Else
        \ScaleX = 1.0
        \ScaleY = 1.0
      EndIf
      _ScaleUpdateGadget(*Gadget)
    EndWith
    
    ProcedureReturn GadgetID(Gadget)
    
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleUnregisterGadget(Gadget)
    If FindMapElement(GadgetList(), Hex(Gadget))
      DeleteMapElement(GadgetList())
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleCloseWindow(Window)
    Protected font
    With GadgetList()
      If IsWindow(Window)
        ForEach GadgetList()
          If \Window = Window
            If \ScaleImage And IsImage(\ScaleImage)
              FreeImage(\ScaleImage)
            EndIf
            If \ScaleFont And IsFont(\ScaleFont)
              FreeFont(\ScaleFont)
            EndIf
            DeleteMapElement(GadgetList())
          EndIf
        Next
        PB(CloseWindow)(Window)
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleFreeGadget(Gadget)
    Protected Parent
    With GadgetList()
      If IsGadget(Gadget)
        PB(FreeGadget)(Gadget)
        If Gadget = #PB_All
          ForEach GadgetList()
            If \ScaleImage And IsImage(\ScaleImage)
              FreeImage(\ScaleImage)
            EndIf
            If \ScaleFont And IsFont(\ScaleFont)
              FreeFont(\ScaleFont)
            EndIf
          Next
          ClearMap(GadgetList())
        Else
          ForEach GadgetList()
            If Not IsGadget(\Gadget)
              If \ScaleImage And IsImage(\ScaleImage)
                FreeImage(\ScaleImage)
              EndIf
              If \ScaleFont And IsFont(\ScaleFont)
                FreeFont(\ScaleFont)
              EndIf
              DeleteMapElement(GadgetList())
            EndIf
          Next
        EndIf
      EndIf
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure CreateWindow(Name.s, Window, x, y, InnerWidth, InnerHeight, Title.s, Flags, ParentID)
    Protected result
    
    x = x * ScaleWindowX
    y = y * ScaleWindowY
    InnerWidth = InnerWidth * ScaleWindowDX
    InnerHeight = InnerHeight * ScaleWindowDY
    
    result = PB(OpenWindow)(Window, x, y, InnerWidth, InnerHeight, Title.s, Flags, ParentID)
    If result = 0
      ProcedureReturn 0
    EndIf
    
    If Window = #PB_Any
      Window = result
    EndIf
    
    AddMapElement(WindowList(), Hex(Window))
    
    With WindowList()
      \Name = Name
      \Window = Window
      \x = x
      \y = y
      \dx = InnerWidth
      \dy = InnerHeight
      \ScaleX = 1.0
      \ScaleY = 1.0
    EndWith
    
    ProcedureReturn result
    
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure CreateGadget(GadgetType, Name.s, Gadget, x, y, dx, dy, Text.s, Param1, Param2, Param3, Flags)
    Protected result, *gadget.udtGadgetList
    
    Select GadgetType
      Case #PB_GadgetType_Button : result = PB(ButtonGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_ButtonImage : result = PB(ButtonImageGadget)(Gadget, x, y, dx, dy, Param1, Flags)
      Case #PB_GadgetType_Calendar : result = PB(CalendarGadget)(Gadget, x, y, dx, dy, Param1, Flags)
      Case #PB_GadgetType_Canvas : result = PB(CanvasGadget)(Gadget, x, y, dx, dy, Flags)
      Case #PB_GadgetType_CheckBox : result = PB(CheckBoxGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_ComboBox : result = PB(ComboBoxGadget)(Gadget, x, y, dx, dy, Flags)
      Case #PB_GadgetType_Container : result = PB(ContainerGadget)(Gadget, x, y, dx, dy, Flags)
      Case #PB_GadgetType_Date : result = PB(DateGadget)(Gadget, x, y, dx, dy, Text, Param1, Flags)
      Case #PB_GadgetType_Editor : result = PB(EditorGadget)(Gadget, x, y, dx, dy, Flags)
      Case #PB_GadgetType_ExplorerCombo : result = PB(ExplorerComboGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_ExplorerList : result = PB(ExplorerListGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_ExplorerTree : result = PB(ExplorerTreeGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_Frame : result = PB(FrameGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_HyperLink : result = PB(HyperLinkGadget)(Gadget, x, y, dx, dy, Text, Param1, Flags)
      Case #PB_GadgetType_Image : result = PB(ImageGadget)(Gadget, x, y, dx, dy, Param1, Flags)
      Case #PB_GadgetType_IPAddress : result = PB(IPAddressGadget)(Gadget, x, y, dx, dy)
      Case #PB_GadgetType_ListIcon : result = PB(ListIconGadget)(Gadget, x, y, dx, dy, Text, Param1, Flags)
      Case #PB_GadgetType_ListView : result = PB(ListViewGadget)(Gadget, x, y, dx, dy, Flags)
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        Case #PB_GadgetType_MDI : result = PB(MDIGadget)(Gadget, x, y, dx, dy, Param1, Param2, Flags)
        CompilerEndIf
      Case #PB_GadgetType_Option : result = PB(OptionGadget)(Gadget, x, y, dx, dy, Text)
      Case #PB_GadgetType_Panel : result = PB(PanelGadget)(Gadget, x, y, dx, dy)
      Case #PB_GadgetType_ProgressBar : result = PB(ProgressBarGadget)(Gadget, x, y, dx, dy, Param1, Param2, Flags)
      Case #PB_GadgetType_Scintilla : result = PB(ScintillaGadget)(Gadget, x, y, dx, dy, Param1)
      Case #PB_GadgetType_ScrollArea : result = PB(ScrollAreaGadget)(Gadget, x, y, dx, dy, Param1, Param2, Param3, Flags)
      Case #PB_GadgetType_ScrollBar : result = PB(ScrollBarGadget)(Gadget, x, y, dx, dy, Param1, Param2, Param3, Flags)
      Case #PB_GadgetType_Shortcut : result = PB(ShortcutGadget)(Gadget, x, y, dx, dy, Param1)
      Case #PB_GadgetType_Spin : result = PB(SpinGadget)(Gadget, x, y, dx, dy, Param1, Param2, Flags)
      Case #PB_GadgetType_Splitter : result = PB(SplitterGadget)(Gadget, x, y, dx, dy, Param1, Param2, Flags)
      Case #PB_GadgetType_String : result = PB(StringGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_Text : result = PB(TextGadget)(Gadget, x, y, dx, dy, Text, Flags)
      Case #PB_GadgetType_TrackBar : result = PB(TrackBarGadget)(Gadget, x, y, dx, dy, Param1, Param2, Flags)
      Case #PB_GadgetType_Tree : result = PB(TreeGadget)(Gadget, x, y, dx, dy, Flags)
      Case #PB_GadgetType_Web : result = PB(WebGadget)(Gadget, x, y, dx, dy, Text)
    EndSelect
    
    If result = 0
      ProcedureReturn 0
    EndIf
    
    If Gadget = #PB_Any
      Gadget = result
    EndIf
    
    With GadgetList()
      If FindMapElement(GadgetList(), Hex(Gadget))
        If \ScaleImage And IsImage(\ScaleImage)
          FreeImage(\ScaleImage)
        EndIf
        If \ScaleFont And IsFont(\ScaleFont)
          PB(FreeFont)(\ScaleFont)
        EndIf
        DeleteMapElement(GadgetList())
      EndIf
    EndWith
    *gadget = AddMapElement(GadgetList(), Hex(Gadget))
    With *gadget
      \Name = Name
      \Gadget = Gadget
      \Parent = ActGadget
      \Window = WindowPB(UseGadgetList(0))
      \x = x
      \y = y
      \dx = dx
      \dy = dy
      \image = -1
      
      If DefaultFontID
        \FontID = DefaultFontID
        If FindMapElement(FontList(), Hex(DefaultFontID))
          \FontName = FontList()\Name
          \FontHeight = FontList()\Height
          \FontStyle = FontList()\Style
          \FontSize = 0
        EndIf
      Else
        \FontID = ScaleDefaultFont
        \FontName = ScaleDefaultFontName
        \FontHeight = ScaleDefaultFontHeight
        \FontStyle = ScaleDefaultFontStyle
        \FontSize = ScaleDefaultFontSize
      EndIf
      
      If FindMapElement(WindowList(), Hex(\Window))
        \ScaleX = WindowList()\ScaleX
        \ScaleY = WindowList()\ScaleY
      Else
        \ScaleX = 1.0
        \ScaleY = 1.0
      EndIf
      Select GadgetType(Gadget)
        Case #PB_GadgetType_ButtonImage
          If Param1
            \image = ImagePB(Param1)
            \scaleimage = CopyImage(\image, #PB_Any) ; force init image (Bug ?)
          EndIf
        Case #PB_GadgetType_Image
          If Param1
            \image = ImagePB(Param1)
            \ScaleImage = CopyImage(\image, #PB_Any) ; force init image (Bug ?)
          EndIf
        Case #PB_GadgetType_Canvas
          If Flags & #PB_Canvas_Container
            ActGadget = Gadget
          EndIf
        Case #PB_GadgetType_Container
          ActGadget = Gadget
        Case #PB_GadgetType_Panel
          ActGadget = Gadget
        Case #PB_GadgetType_ScrollArea
          ActGadget = Gadget
        Case #PB_GadgetType_Splitter
          If FindMapElement(GadgetList(), Hex(Param1))
            GadgetList()\Parent = Gadget
          EndIf
          If FindMapElement(GadgetList(), Hex(Param2))
            GadgetList()\Parent = Gadget
          EndIf
      EndSelect
      _ScaleUpdateGadget(*gadget)
    EndWith
    
    ProcedureReturn result
    
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ParentWindow(Gadget)
    If FindMapElement(GadgetList(), Hex(Gadget))
      ProcedureReturn GadgetList()\Window
    Else
      ProcedureReturn -1
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ParentGadget(Gadget)
    If FindMapElement(GadgetList(), Hex(Gadget))
      ProcedureReturn GadgetList()\Parent
    Else
      ProcedureReturn -1
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  ;- Font Framework
  
  Procedure ScaleLoadFont(Font, Name.s, Height, Style = 0)
    Protected new_font
    
    With FontList()
      If Font <> #PB_Any And IsFont(Font)
        FindMapElement(FontList(), Hex(FontID(Font)))
        DeleteMapElement(FontList())
      EndIf
      new_font = PB(LoadFont)(Font, Name.s, Height, Style)
      If new_font
        If font = #PB_Any
          AddMapElement(FontList(), Hex(FontID(new_font)))
          \Font = new_font
          \FontID = FontID(new_font)
        Else
          AddMapElement(FontList(), Hex(new_font))
          \Font = font
          \FontID = new_font
        EndIf
        \Name = Name
        \Height = Height
        \Style = Style
      EndIf
      ProcedureReturn new_font
    EndWith
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure ScaleFreeFont(Font)
    If IsFont(font) And FindMapElement(FontList(), Hex(FontID(font)))
      DeleteMapElement(FontList())
    EndIf
    PB(FreeFont)(Font)
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure.s GetScaleFontName(Font)
    If FindMapElement(FontList(), Hex(FontID(Font)))
      ProcedureReturn FontList()\Name
    Else
      ProcedureReturn ""
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
  Procedure GetScaleFontHeight(Font)
    If FindMapElement(FontList(), Hex(FontID(Font)))
      ProcedureReturn FontList()\Height
    Else
      ProcedureReturn 0
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  Procedure GetScaleFontStyle(Font)
    If FindMapElement(FontList(), Hex(FontID(Font)))
      ProcedureReturn FontList()\Style
    Else
      ProcedureReturn 0
    EndIf
  EndProcedure
  
  ; -----------------------------------------------------------------------------------
  
EndModule

;- End Module ScaleGadgets

; ---------------------------------------------------------------------------------------

; ***************************************************************************************

;-Example

CompilerIf #PB_Compiler_IsMainFile
  
  UseModule ScaleGadgets
  
  Macro PB(Function)
    Function
  EndMacro
  
  Enumeration Window 1
    #Main
  EndEnumeration
  
  Enumeration Gadget
    #Editor
    #Container
    #ButtonB0
    #ButtonB1
    #ButtonB2
  EndEnumeration
  
  Enumeration MenuItem
    #New
    #Load
    #Save
    #Exit
  EndEnumeration
  
  Enumeration StatusBar
    #StatusBar
  EndEnumeration
  
  ; -----------------------------------------------------------------
  
  Global ExitApplication
  
  ; -----------------------------------------------------------------
  
  DeclareModule MyGadget
    Declare MyOwnerDrawGadget(Gadget, x, y, Width, Height)
    Declare MyOwnerDrawCB(Gadget, x, y, Width, Height)
  EndDeclareModule
  
  Module MyGadget
    Procedure MyOwnerDrawCB(Gadget, x, y, Width, Height)
      If IsGadget(Gadget)
        StartDrawing(CanvasOutput(Gadget))
        Box(0, 0, Width, Height, #Green)
        DrawingMode(#PB_2DDrawing_Outlined)
        Box(1, 1, Width-2 , Height-2, #Black)
        DrawingMode(#PB_2DDrawing_Default)
        Circle(Width / 2, Height / 2, Height / 2 - 4, #Red)
        StopDrawing()
      EndIf
    EndProcedure
    ; ---    
    Procedure MyOwnerDrawGadget(Gadget, x, y, Width, Height)
      Protected r1
      r1 = CanvasGadget(Gadget, x, y, Width, Height)
      If r1
        MyOwnerDrawCB(Gadget, x, y, Width, Height)
      EndIf
      ProcedureReturn r1
    EndProcedure
  EndModule
  
  ; -----------------------------------------------------------------
  
  Global DPI.f = 1.25
  Global MyFont
  
  SetScale(DPI)
  
  ; -----------------------------------------------------------------
  
  Procedure GetStatus(Gadget)
    Protected x, y, dx, dy, text.s
    
    SetScaleMode(#ScaleModeReal)
    x = GadgetX(Gadget)
    y = GadgetY(Gadget)
    dx = GadgetWidth(Gadget)
    dy = GadgetHeight(Gadget)
    text = "R = " + Str(x) + "/" + Str(y) + " - " + Str(dx) + "*" + Str(dy)
    StatusBarText(#StatusBar, 1, text)
    SetScaleMode(#ScaleModeScaled)
    x = GadgetX(Gadget)
    y = GadgetY(Gadget)
    dx = GadgetWidth(Gadget)
    dy = GadgetHeight(Gadget)
    text = "S = " + x + "/" + y + " - " + dx + "*" + dy
    StatusBarText(#StatusBar, 2, text)
    SetScaleMode(#ScaleModeDynamic)
    x = GadgetX(Gadget)
    y = GadgetY(Gadget)
    dx = GadgetWidth(Gadget)
    dy = GadgetHeight(Gadget)
    text = "D = " + x + "/" + y + " - " + dx + "*" + dy
    StatusBarText(#StatusBar, 3, text)
  EndProcedure
  
  ; -----------------------------------------------------------------
  
  Procedure DoSizeWindow()
    ScaleAllGadgets(#Main, MenuHeight() + StatusBarHeight(#StatusBar))
    GetStatus(#Editor)
  EndProcedure
  
  ; -----------------------------------------------------------------
  
  Global ButtonB1
  
  Procedure OpenMain(x = 10, y = 10, width = 550, height = 415)
    OpenWindow(#Main, x, y, width, height + MenuHeight(), "Module ScaleGadgets", 
               #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_ScreenCentered)
    
    If CreateMenu(0, WindowID(#Main))
      ; Mac Menu´s
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        MenuItem(#PB_Menu_About, "")
        MenuItem(#PB_Menu_Preferences, "")
        MenuItem(#PB_Menu_Quit, "")
      CompilerEndIf
      MenuTitle("&File")
      MenuItem(#New, "&New")
      MenuItem(#Load, "&Load")
      MenuItem(#Save, "&Save")
      MenuBar()
      MenuItem(#Exit, "&Exit")
    EndIf
    
    CreateStatusBar(#StatusBar, WindowID(#Main))
    AddStatusBarField(180)
    AddStatusBarField(150)
    AddStatusBarField(150)
    AddStatusBarField(150)
    StatusBarText(#StatusBar, 0, "ScaleGadgets: DPI = " + StrF(DPI *100) + "%")
    
    EditorGadget(#Editor, 10, 10, 530, 310)
    SetGadgetText(#Editor, "I like Purebasic!")
    ContainerGadget(#Container, 10, 330, 530, 50, #PB_Container_Single)
    ButtonGadget(#ButtonB0, 10, 10, 160, 30, "Create Button")
    ButtonGadget(#ButtonB1, 180, 10, 170, 30, "---")
    ButtonGadget(#ButtonB2, 360, 10, 160, 30, "Remove Button")
    
    CloseGadgetList()
  EndProcedure
  
  OpenMain()
  
  MyFont = LoadFont(#PB_Any, "Courier New", 20, #PB_Font_Bold | #PB_Font_Italic)
  SetGadgetFont(#Editor, FontID(MyFont))
  
  BindEvent(#PB_Event_SizeWindow, @DoSizeWindow())
  
  GetStatus(#Editor)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        ExitApplication = 1
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #ButtonB0
            If Not ButtonB1
              OpenGadgetList(#Container)
              HideGadget(#ButtonB1, 1)
              ButtonB1 = MyGadget::MyOwnerDrawGadget(#PB_Any, 180, 10, 170, 30)
              ; Register gadget to ScaleGadget and resize gadget to scale factors
              ScaleRegisterGadget(ButtonB1, MyGadget::@MyOwnerDrawCB())
            EndIf
          Case #ButtonB1
            
          Case #ButtonB2
            If ButtonB1
              ScaleUnregisterGadget(ButtonB1)
              FreeGadget(ButtonB1)
              ButtonB1 = 0
              HideGadget(#ButtonB1, 0)
            EndIf
          Case ButtonB1
            
        EndSelect
    EndSelect
  Until ExitApplication
  
  End
  
CompilerEndIf
; IDE Options = PureBasic 5.71 LTS (Windows - x86)
; CursorPosition = 1021
; FirstLine = 986
; Folding = ---------------------
; EnableXP
; DisableDebugger
; CompileSourceDirectory