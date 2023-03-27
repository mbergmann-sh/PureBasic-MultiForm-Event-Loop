;**********************************************************************************
;*  Copyright (c)2002-2022 Reel Media Productions                                 *
;*                                                                                *
;*  This Module is made available to Registered PureVision End Users to use       *
;*  Royalty Free in Private or Commercial Compiled Projects.                      *
;*  You are free to modify this Modules Source Code and/or add to it as you wish. *
;*                                                                                *
;*  The Source Code in this Module is only for Registered PureVision End Users    *
;*  and is not to be distributed publicly.                                        *
;**********************************************************************************


; Aug.30, 2020 - Updated PVGadgets Canvas,ProgressBar,AnimGadget & PieChart to be DPI Aware
; Oct.17, 2020 - Added Extra Functions & PVGadgets_CenterListIconRow
; Nov.13, 2020 - Added Splitter command for easy SplitterGadget use
; Jul.13, 2021 - Added Proportional Move/Resize to Dynamic Resizing
; Aug.29, 2022 - Added Flags to Exclude Procedures if Never Used to reduce EXE size when Compiled

 
 


CompilerIf Defined(ToolBarStandardButton, #PB_Function)=0
  Enumeration
    #PB_ToolBarIcon_Cut
    #PB_ToolBarIcon_Copy
    #PB_ToolBarIcon_Paste
    #PB_ToolBarIcon_Undo
    #PB_ToolBarIcon_Redo
    #PB_ToolBarIcon_Delete
    #PB_ToolBarIcon_New
    #PB_ToolBarIcon_Open
    #PB_ToolBarIcon_Save
    #PB_ToolBarIcon_PrintPreview
    #PB_ToolBarIcon_Properties
    #PB_ToolBarIcon_Help
    #PB_ToolBarIcon_Find
    #PB_ToolBarIcon_Replace
    #PB_ToolBarIcon_Print
  EndEnumeration
CompilerEndIf


DeclareModule PVX
  EnumerationBinary
    #VerticalSize    ;1
    #HorizontalSize  ;2
    #VerticalMove    ;4
    #HorizontalMove  ;8

    #VerticalSizeP   ;16
    #HorizontalSizeP ;32
    #VerticalMoveP   ;64
    #HorizontalMoveP ;128
  EndEnumeration
  
  #ExcludeToolbar       = #False ;change to #True if never going to use ToolBarStandardButton()
  #ExcludeListIconImage = #False ;change to #True if never going to use CreateListIconImageList()
  #ExcludePureSkin      = #False ;change to #True if never going to use PureSkin Commands
  #ExcludePurePoint     = #False ;change to #True if never going to use PurePoint Commands
  
  
  #SystemFont       = 0
  #Left             = 0
  #Right            = 1
  #Center           = 2
  #BubbleTip        = 0
  #ToolTip          = 1
  #DisableTip       =-1
  #SystemColor      =-1
  #NoShadow         = 0
  #Shadow           = 1
  #NoNumber         =-1
  #NoBorder         = 0
  #FlatBorder       = 2
  #SunkenBorder     =#PB_Image_Border
  
  Global MainWin_W,MainWin_H

  Declare.i PVGadgets_Min(a,b)
  Declare.i PVGadgets_Max(a,b)
  Declare.i PVGadgets_HiWord(a)
  Declare.i PVGadgets_LoWord(a)

  
  Declare   PVDynamic_AddWindow(WindowID.i)
  Declare   PVDynamic_FreeWindow(WindowID.i)
  Declare   PVDynamic_AddGadget(parentid.i,GadgetID.i,MoveSize.i,SBFull.i=0)
  Declare   PVDynamic_FreeGadget(GadgetID.i)
  Declare   PVDynamic_Resize(hDynamic_WindowID.i) 
   
  Declare.i PVGadgets_Splitter(Gadget1.i,Gadget2.i,flag.i=0)
  
  
  
  
  CompilerIf #PB_Compiler_OS=#PB_OS_Windows
    Declare   PVDynamic_AddStatusBar(parentid.i,GadgetID.l,hGadget.i,ResizeStatusBar.i) 
    
    Declare   PVDynamic_AddColorGadget(GadgetID.i,fgcolor.i,bgcolor.i)
    Declare   PVDynamic_FreeColorGadget(GadgetID.i)
    Declare.i PVDynamic_ColorGadget(Dynamic_lParam.i,Dynamic_wParam.i)
  
    CompilerIf Not #ExcludePurePoint
    Declare.i PurePoint(file.s) 
    Declare.i PurePointMem(mem.i)
    Declare.i UsePurePoint(hPoint.i)
    Declare.i SysPurePoint(hPoint.i)
    Declare.i FreePurePoint(hPoint.i)
    Declare.i ResetPurePoint()
    Declare.i PurePointX(Window.i,DPIFix=0)
    Declare.i PurePointY(Window.i,DPIFix=0)
    Declare.i PurePointXX(Window.i,DPIFix=0)
    Declare.i PurePointYY(Window.i,DPIFix=0)
    Declare.i PurePointChild(Window.i)
    CompilerEndIf
      
    Declare.i PVGadgets_Canvas(CanvasID,ImageId,x,y,w,h,BColor,flag=0)
    Declare   PVGadgets_FreeCanvas(CanvasID,ImageId)
    Declare   PVGadgets_CanvasFree(CanvasID,ImageId)
    Declare   PVGadgets_CanvasButtonRegister(WindowID.i,CanvasID.i,ImageId.i,SubID.i)
    Declare   PVGadgets_CanvasButtonAdd(WindowID.i,CanvasID.i,ImageId.i,SubID.i)
    Declare.i PVGadgets_CanvasButtonFree(CanvasID.i)
    Declare.i PVGadgets_CanvasButtonDelete(CanvasID.l)
    Declare.i PVGadgets_CanvasButtonPressed()
    Declare.i PVGadgets_CanvasButtonHover(WindowID.i)
    Declare.i PVGadgets_CanvasEnableClick(CanvasID.i)
    Declare.i PVGadgets_CanvasDisableClick(CanvasID.i)
  
    Declare.i PVGadgets_ProgressBar(BarID,ImageId,x,y,w,h,Progress,Shadow,BColor,FColor1,FColor2,flag=0)
    Declare   PVGadgets_FreeProgressBar(BarID,ImageId)
    Declare   PVGadgets_ProgressBarFree(BarID,ImageId)
  
    Declare.i PVGadgets_PieChart(GadgetID,ImageId,x,y,w,h,BackColor,PieBack,PieFront,Progress,FontID,TextColor=0)
    Declare   PVGadgets_FreePieChart(GadgetID,ImageId)
    Declare   PVGadgets_PieChartFree(GadgetID,ImageId)
      
    Declare   PVGadgets_WindowFreeze(Window.i,MaxWindows.i)
    Declare   PVGadgets_WindowUnfreeze(Window.i,MaxWindows.i)
    Declare   PVGadgets_WindowTop(Window.i)
    Declare   PVGadgets_WindowReset(Window.i)
    Declare   PVGadgets_WindowTransparent(Window.i,Transparency.i)
    Declare   PVGadgets_ToolWindow(Window.i)
    Declare.i GetTaskBarState()
    Declare.i HideTaskBar(flag.i=#True)
    
    Declare.s PVGadgets_GetAppDirectory()
    
    Declare.s PVGadgets_FormatNumber(Number.s,Group.i=3,DecDig.i=2,DecSep.s=".",GrpSep.s=",",Neg.i=0)
    Declare.s PVGadgets_GetCalendarDate(GadgetID.i)
    Declare.i PVGadgets_SetCalendarDate(GadgetID.i,year.i,month.i,day.i)
  
    Declare.i PVGadgets_Refresh(GadgetID.i)
    Declare.i PVGadgets_RefreshWindow(WindowID.i)
    Declare.i PVGadgets_StartOnce(name.s)
    Declare.s PVGadgets_APIError()
     
    Declare.i PVGadgets_CountListIconColumns(GadgetID.i)  
    Declare.i PVGadgets_GetListIconColumnWidth(GadgetID.i,column)
    Declare.i PVGadgets_SetListIconColumnWidth(GadgetID.i,column.i,Width.i)  
    Declare.i PVGadgets_JustifyListIconColumn(GadgetID.i,column.i,flag.i) 
    Declare.i PVGadgets_ListIconColumn(GadgetID.i,column.i,flag.i) 
    CompilerIf Not #ExcludeListIconImage 
    Declare.i PVGadgets_CreateListIconImageList(GadgetID.i) 
    CompilerEndIf
    Declare.i PVGadgets_FreeListIconImageList(hImageList.i) 
    Declare.i PVGadgets_AddListIconImageList(hImageList.i,hImageId.i) 
    Declare.i PVGadgets_ChangeListIconImage(GadgetID.i,row.i,column.i,hIcon.i=0)  
    Declare.i PVGadgets_LastListIconRow(GadgetID.i) 
    Declare.i PVGadgets_SelectListIconRow(GadgetID.i,row.i)
    Declare.i PVGadgets_CenterListIconRow(GadgetID.i,row.i) 
    Declare.i PVGadgets_ListIconTitle(GadgetID.i,column.i,text.s)
  
    Declare.i PVGadgets_InitAnimGadget()  
    Declare.i PVGadgets_AnimGadget(hAnimGadget.i,Window.i,x,y,w,h,flag.i)
    Declare   PVGadgets_AnimGadgetPlay(GadgetID.i,Loop.i=-1,First.w=-1,Last.w=-1)
    Declare   PVGadgets_AnimGadgetStop(GadgetID.i)
    Declare   PVGadgets_AnimGadgetHide(GadgetID.i,flag.i)
    Declare   PVGadgets_FreeAnimGadget(hAnimGadget)
    Declare.i PVGadgets_FreeAnimGadgetImages(ImagePath.s)
    
    Declare.i PVGadgets_BubbleTipDelete(bWindow.i,bGadget.i,hTip.i)
    Declare.i PVGadgets_BubbleTipChange(bWindow.i,bGadget.i,hTip.i,bText.s)
    Declare.i PVGadgets_BubbleTip(bWindow.i,bGadget.i,bText.s,flag.i=0,BColor.i=$DFFFFF)  
    
    CompilerIf Not #ExcludePureSkin
    Declare   PureSkinHide(Window.i,flag.i=#False)
    Declare.i PureSkin(Window,Gadget,image,file.s,center.i=#True)
    Declare.i PureSkinMem(Window,Gadget,image,pos.i,center.i=#True)
    CompilerEndIf
    
    Declare   PVGadgets_NoSkin(GadgetID.i)
    Declare   PVGadgets_NoSkinWin(WindowID.i)
  CompilerEndIf

  CompilerIf Not #ExcludeToolbar
  CompilerIf #PB_Compiler_OS<>#PB_OS_Web And Defined(ToolBarStandardButton, #PB_Function)=0
    Declare.i ToolBarStandardButton(hBtn.i,hIcon.i,Mode.i,Text.s)
  CompilerEndIf
  CompilerEndIf
EndDeclareModule


;---------------------------------------------------------------------------


Module PVX
; EnableExplicit


;-
;----- Extra Functions
  Procedure.i PVGadgets_Min(a,b)
    ProcedureReturn (Bool(a>b)*b) | (Bool(a<b)*a)
  EndProcedure
  
  Procedure.i PVGadgets_Max(a,b)
    ProcedureReturn (Bool(a>b)*a) | (Bool(a<b)*b)
  EndProcedure
  
  Procedure.i PVGadgets_HiWord(a)
    ProcedureReturn (a >> 16 & $ffff)
  EndProcedure
  
  Procedure.i PVGadgets_LoWord(a)
    ProcedureReturn (a & $ffff)
  EndProcedure

;-
;----- Dynamic Window/Gadget Resizing
  Structure Dynamic_RestrictWindow
    id.i
    Width.i
    Height.i
  EndStructure  
  Structure Dynamic_AutoResizeGadgets
    MS.i    
    parent.i
    Gadget.i
    hGadget.i
    ResizeStatusBar.i
    xdif.i
    ydif.i
    wdif.i
    hdif.i
    xwin.i
    ywin.i
    xgad.i
    ygad.i
    wgad.i
    hgad.i
  EndStructure  
  Global NewList DynamicRW.Dynamic_RestrictWindow()
  Global NewList DynamicAR.Dynamic_AutoResizeGadgets()  
  

    
  Procedure PVDynamic_AddWindow(WindowID.i);Create a Dynamic Window
    ForEach DynamicRW()
      If DynamicRW()\id=WindowID
        DeleteElement(DynamicRW())
        Break
      EndIf
    Next
    AddElement(DynamicRW())
    DynamicRW()\id=WindowID
    DynamicRW()\Width=WindowWidth(WindowID,#PB_Window_FrameCoordinate)
    DynamicRW()\Height=WindowHeight(WindowID,#PB_Window_FrameCoordinate)
  EndProcedure
  
  Procedure PVDynamic_FreeWindow(WindowID.i);Free a Dynamic Window and all Gadgets
    ForEach DynamicRW()
      If DynamicRW()\id=WindowID
        DeleteElement(DynamicRW())
        Break
      EndIf
    Next
    ResetList(DynamicAR())
    While NextElement(DynamicAR())
      If DynamicAR()\parent=WindowID
        DeleteElement(DynamicAR())
        ResetList(DynamicAR())
      EndIf
    Wend
  EndProcedure
  
  Procedure PVDynamic_AddGadget(parentid.i,GadgetID.i,MoveSize.i,SBFull.i=0);Create a Dynamic Resized Gadget
    ForEach DynamicAR()
      If DynamicAR()\gadget=GadgetID And DynamicAR()\ResizeStatusBar=0
        DeleteElement(DynamicAR())
        Break
      EndIf
    Next
    
    If SBFull And MainWin_W And MainWin_H  ; SpiderBasic - #PB_Window_Background
      wx=0
      wy=0
      ww=WindowWidth(parentid)
      wh=WindowHeight(parentid)
      gx=GadgetX(GadgetID)
      gy=GadgetY(GadgetID)
      gw=GadgetWidth(GadgetID)
      gh=GadgetHeight(GadgetID)
      If MoveSize & #VerticalSize
        gh=wh-(MainWin_H-gh)
      EndIf
      If MoveSize & #HorizontalSize
        gw=ww-(MainWin_W-gw)
      EndIf
      If MoveSize & #HorizontalMove
        gx=ww-(MainWin_W-gx)
      EndIf
      If MoveSize & #VerticalMove
        gy=wh-(MainWin_H-gy)
      EndIf
      ResizeGadget(GadgetID,gx,gy,gw,gh)   
    EndIf ; ---------------------------------------------------------------------
    
    AddElement(DynamicAR())
    DynamicAR()\MS=MoveSize
    DynamicAR()\parent=parentid
    DynamicAR()\gadget=GadgetID
  
    DynamicAR()\xdif=WindowWidth(parentid)-GadgetX(GadgetID)
    DynamicAR()\ydif=WindowHeight(parentid)-GadgetY(GadgetID)
    DynamicAR()\wdif=GadgetWidth(GadgetID)
    DynamicAR()\hdif=GadgetHeight(GadgetID)
    DynamicAR()\xwin=WindowWidth(parentid)
    DynamicAR()\ywin=WindowHeight(parentid)  
    
    DynamicAR()\xgad=GadgetX(GadgetID)
    DynamicAR()\ygad=GadgetY(GadgetID)      
    DynamicAR()\wgad=GadgetWidth(GadgetID)
    DynamicAR()\hgad=GadgetHeight(GadgetID)      
  EndProcedure
  
  Procedure PVDynamic_FreeGadget(GadgetID.i);Free a Dynamic Gadget
    ForEach DynamicAR()
      If DynamicAR()\gadget=GadgetID
        DeleteElement(DynamicAR())
        Break
      EndIf
    Next
  EndProcedure
   
  Procedure PVDynamic_Resize(hDynamic_WindowID.i);Callback Handler for Dynamic Resizing
    Protected.i dRW,wwin,hwin,tmp
    ForEach DynamicRW()
      dRW=DynamicRW()\id
      If IsWindow(dRW)
        If WindowID(dRW)=hDynamic_WindowID
          wwin=WindowWidth(dRW)
          hwin=WindowHeight(dRW) 
      
          ForEach DynamicAR()
            If DynamicAR()\parent=dRW
              If DynamicAR()\ResizeStatusBar
                CompilerIf #PB_Compiler_OS=#PB_OS_Windows 
                  Global Dim PVSBField.l(DynamicAR()\ResizeStatusBar-1)
                  SendMessage_(DynamicAR()\hGadget,#SB_GETPARTS,DynamicAR()\ResizeStatusBar,@PVSBField())
                  For tmp=0 To DynamicAR()\ResizeStatusBar-1
                    PVSBField(tmp)+wwin-DynamicAR()\xwin
                  Next
                  SendMessage_(DynamicAR()\hGadget,#SB_SETPARTS,DynamicAR()\ResizeStatusBar,@PVSBField())
                CompilerEndIf
                Else
                
                If IsGadget(DynamicAR()\Gadget)
                  If DynamicAR()\MS & #HorizontalMove
                    ResizeGadget(DynamicAR()\Gadget,wwin-DynamicAR()\xdif,#PB_Ignore,#PB_Ignore,#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #VerticalMove
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,hwin-DynamicAR()\ydif,#PB_Ignore,#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #HorizontalSize
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,#PB_Ignore,(wwin-DynamicAR()\xwin)+DynamicAR()\wdif,#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #VerticalSize
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,#PB_Ignore,#PB_Ignore,(hwin-DynamicAR()\ywin)+DynamicAR()\hdif)
                  EndIf

                  If DynamicAR()\MS & #HorizontalMoveP
                    ResizeGadget(DynamicAR()\Gadget,((wwin-DynamicAR()\xdif)/2)+DynamicAR()\xgad/2,#PB_Ignore,#PB_Ignore,#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #VerticalMoveP
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,((hwin-DynamicAR()\ydif)/2)+DynamicAR()\ygad/2,#PB_Ignore,#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #HorizontalSizeP
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,#PB_Ignore,((wwin-DynamicAR()\xwin)+DynamicAR()\wdif)/2+(DynamicAR()\wgad/2),#PB_Ignore)
                  EndIf
                  If DynamicAR()\MS & #VerticalSizeP
                    ResizeGadget(DynamicAR()\Gadget,#PB_Ignore,#PB_Ignore,#PB_Ignore,((hwin-DynamicAR()\ywin)+DynamicAR()\hdif)/2+(DynamicAR()\hgad/2))
                  EndIf
                EndIf
                
              EndIf
            EndIf
          Next
          
          Break
        EndIf
      EndIf    
    Next
    CompilerIf #PB_Compiler_OS=#PB_OS_Windows
      InvalidateRgn_(hDynamic_WindowID,0,1)
    CompilerEndIf
  EndProcedure



  Procedure.i PVGadgets_Splitter(Gadget1.i,Gadget2.i,flag.i=0)
    Protected result,size
    If flag & #PB_Splitter_Vertical
      size=GadgetWidth(Gadget1)
      Else
      size=GadgetHeight(Gadget1)        
    EndIf 
    result=SplitterGadget(#PB_Any,GadgetX(Gadget1),GadgetY(Gadget1),
    (GadgetWidth(Gadget1)+GadgetWidth(Gadget2))+(GadgetX(Gadget2)-(GadgetX(Gadget1)+GadgetWidth(Gadget1))),
    (GadgetHeight(Gadget1)+GadgetHeight(Gadget2))+(GadgetY(Gadget2)-(GadgetY(Gadget1)+GadgetHeight(Gadget1))),
    Gadget1,Gadget2,flag)
    SetGadgetState(result,size)        
    ProcedureReturn result
  EndProcedure


  CompilerIf #PB_Compiler_OS=#PB_OS_Windows 
    Structure Dynamic_AutoResizeStatusBar
      Gadget.l
      Width.l
    EndStructure   
    Global NewList DynamicARSB.Dynamic_AutoResizeStatusBar()
  
    Procedure PVDynamic_AddStatusBar(parentid.i,GadgetID.l,hGadget.i,ResizeStatusBar.i);Create a Dynamic Resized StatusBar
      ForEach DynamicAR()
        If DynamicAR()\Gadget=GadgetID And DynamicAR()\ResizeStatusBar
          DeleteElement(DynamicAR())
          ResetList(DynamicARSB())
          While NextElement(DynamicARSB())
            If DynamicARSB()\Gadget=GadgetID
              DeleteElement(DynamicARSB())
              ResetList(DynamicARSB())
            EndIf
          Wend
          Break
        EndIf
      Next
      AddElement(DynamicAR())
      DynamicAR()\parent=parentid
      DynamicAR()\Gadget=GadgetID
      DynamicAR()\hGadget=hGadget
      DynamicAR()\ResizeStatusBar=ResizeStatusBar
      DynamicAR()\xwin=WindowWidth(parentid)
      DynamicAR()\ywin=WindowHeight(parentid)
    EndProcedure
    
    
  ;-
  ;----- Dynamic Color Gadget
    Structure Dynamic_ColorGadgets
      Gadget.l
      fgcolor.l
      bgcolor.l
      rFace.l
      rBrush.l
    EndStructure
    Global NewList DynamicCG.Dynamic_ColorGadgets()
  
    Procedure PVDynamic_AddColorGadget(GadgetID.i,fgcolor.i,bgcolor.i);Create a Dynamic Colored Gadget
      ForEach DynamicCG()
        If DynamicCG()\gadget=GadgetID
          DeleteObject_(DynamicCG()\rFace)
          DeleteObject_(DynamicCG()\rBrush)
          DeleteElement(DynamicCG())
          Break
        EndIf
      Next
      AddElement(DynamicCG())
      DynamicCG()\gadget=GadgetID
      DynamicCG()\fgcolor=fgcolor
      DynamicCG()\bgcolor=bgcolor
      DynamicCG()\rFace=CreateSolidBrush_(GetSysColor_(#COLOR_BTNFACE))
      If bgcolor=-1
        DynamicCG()\rBrush=GetStockObject_(#HOLLOW_BRUSH)
        Else
        DynamicCG()\rBrush=CreateSolidBrush_(bgcolor)
      EndIf
    EndProcedure
    
    Procedure PVDynamic_FreeColorGadget(GadgetID.i);Free a Dynamic Color Gadget
      ForEach DynamicCG()
        If DynamicCG()\Gadget=GadgetID
          DeleteObject_(DynamicCG()\rFace)
          DeleteObject_(DynamicCG()\rBrush)
          DeleteElement(DynamicCG())
          Break
        EndIf
      Next
    EndProcedure
    
    Procedure.i PVDynamic_ColorGadget(Dynamic_lParam.i,Dynamic_wParam.i);Callback Handler for Dynamic Color Gadgets
      Protected Dynamic_ReturnValue=#PB_ProcessPureBasicEvents
      ForEach DynamicCG()
        If IsGadget(DynamicCG()\gadget)
          If GadgetID(DynamicCG()\gadget)=Dynamic_lParam
            SetTextColor_(Dynamic_wParam,DynamicCG()\fgcolor)
            If DynamicCG()\bgcolor>0
              SetBkMode_(Dynamic_wParam,#OPAQUE)
              SetBkColor_(Dynamic_wParam,DynamicCG()\bgcolor)
              Dynamic_ReturnValue=DynamicCG()\rBrush
              Else
              SetBkMode_(Dynamic_wParam,#TRANSPARENT)
              If DynamicCG()\bgcolor=0
                SetBkColor_(Dynamic_wParam,DynamicCG()\rFace)
                Dynamic_ReturnValue=DynamicCG()\rFace
                Else
                SetBkColor_(Dynamic_wParam,DynamicCG()\rBrush)
                Dynamic_ReturnValue=DynamicCG()\rBrush
              EndIf
            EndIf
          EndIf
        EndIf
      Next
      ProcedureReturn Dynamic_ReturnValue
  EndProcedure
  
  
  ;-
  ;----- PurePoint LIB
    CompilerIf Not #ExcludePurePoint
    Procedure.i PurePoint(file.s) ;Load a PurePoint from File
      Protected hFile.i,mem0.i,curs.i
      hFile=ReadFile(#PB_Any,File.s)
      If hFile
        mem0=AllocateMemory(Lof(hFile))
        ReadData(hFile,mem0,Lof(hFile))
        CloseFile(hFile)
        curs=CreateCursor_(GetModuleHandle_(0),PeekB(mem0),PeekB(mem0+1),32,32,mem0+53,mem0+53+128)
        ProcedureReturn curs
      EndIf
    EndProcedure
       
    Procedure.i PurePointMem(mem.i) ;Load a PurePoint from Memory
      Protected curs.i
      curs=CreateCursor_(GetModuleHandle_(0),PeekB(mem),PeekB(mem+1),32,32,mem+53,mem+53+128)
      ProcedureReturn curs  
    EndProcedure
    
    Procedure.i UsePurePoint(hPoint.i) ;Display PurePoint on Form
      ProcedureReturn SetCursor_(hPoint)
    EndProcedure
    
    Procedure.i SysPurePoint(hPoint.i) ;Changes System Cursor to PurePoint
      ProcedureReturn SetSystemCursor_(hPoint,#OCR_NORMAL)
    EndProcedure
    
    Procedure.i FreePurePoint(hPoint.i) ;Free PurePoint Resources 
      If DestroyCursor_(hPoint)
        ProcedureReturn 0
        Else
        ProcedureReturn -1
      EndIf
    EndProcedure
    
    Procedure.i ResetPurePoint() ;Resets System Cursor to Standard Arrow
      Protected *Buf,curs.i
      *Buf=AllocateMemory(256)
      CopyMemory(?cursorstart,*Buf,?CursorEnd - ?CursorStart)
      curs=CreateCursor_(GetModuleHandle_(0),0,0,32,32,*Buf,*Buf+128)
      SetSystemCursor_(curs,#OCR_NORMAL)
      FreeMemory(*Buf)
    EndProcedure
    
    Procedure.i PurePointX(Window.i,DPIFix=0) ;Return X Position of PurePoint on Window
      Protected mouse.POINT,rect.rect
      Protected dpifx.d = DesktopResolutionX()
      GetCursorPos_(mouse) 
      ScreenToClient_(WindowID(Window),mouse) 
      GetClientRect_(WindowID(Window),rect) 
      If mouse\x < 0 Or mouse\x > rect\right 
        ProcedureReturn -1 
        Else 
        If DPIFix 
          ProcedureReturn mouse\x /dpifx
          Else
          ProcedureReturn mouse\x
        EndIf
      EndIf 
    EndProcedure 
    
    Procedure.i PurePointY(Window.i,DPIFix=0) ;Return Y Position of PurePoint on Window  
      Protected mouse.POINT,rect.rect
      Protected dpify.d = DesktopResolutionY()
      GetCursorPos_(mouse) 
      ScreenToClient_(WindowID(Window),mouse) 
      GetClientRect_(WindowID(Window),rect) 
      If mouse\y < 0 Or mouse\y > rect\bottom 
        ProcedureReturn -1 
        Else 
        If DPIFix 
          ProcedureReturn mouse\y /dpify
          Else
          ProcedureReturn mouse\y
        EndIf
      EndIf 
    EndProcedure
    
    Procedure.i PurePointXX(Window.i,DPIFix=0) ;Return X Position of PurePoint on Gadget
      Protected mouse.POINT,rect.rect
      Protected dpifx.d = DesktopResolutionX()
      GetCursorPos_(mouse) 
      ScreenToClient_(GadgetID(Window),mouse) 
      GetClientRect_(GadgetID(Window),rect) 
      If mouse\x < 0 Or mouse\x > rect\right 
        ProcedureReturn -1 
        Else 
        If DPIFix 
          ProcedureReturn mouse\x /dpifx
          Else
          ProcedureReturn mouse\x
        EndIf
      EndIf 
    EndProcedure 
    
    Procedure.i PurePointYY(Window.i,DPIFix=0) ;Return Y Position of PurePoint on Gadget
      Protected mouse.POINT,rect.rect 
      Protected dpify.d = DesktopResolutionY()
      GetCursorPos_(mouse) 
      ScreenToClient_(GadgetID(Window),mouse) 
      GetClientRect_(GadgetID(Window),rect) 
      If mouse\y < 0 Or mouse\y > rect\bottom 
        ProcedureReturn -1 
        Else 
        If DPIFix 
          ProcedureReturn mouse\y /dpify
          Else
          ProcedureReturn mouse\y
        EndIf
      EndIf 
    EndProcedure
    
    Procedure.i PurePointChild(Window.i) ;Returns Handle of Gadget PurePoint is over
      Protected mouse.POINT
      GetCursorPos_(mouse)
      MapWindowPoints_(0,WindowID(Window),mouse,1)
      ProcedureReturn ChildWindowFromPoint_(WindowID(Window),mouse\y << 32 + mouse\x) ;@mouse)
    EndProcedure
    CompilerEndIf 
  
  ;-
  ;----- Canvas
    Structure Dynamic_CanvasButtons
      WindowID.l
      CanvasID.l
      ImageId.l
      SubID.l
      Used.l
    EndStructure
    Global NewList DynamicCB.Dynamic_CanvasButtons()
  
    Procedure.i PVGadgets_Canvas(CanvasID,ImageId,x,y,w,h,BColor,flag=0);Create Canvas Gadget
      Protected Result=0,rec.rect
      Protected dpifx.d = DesktopResolutionX()
      Protected dpify.d = DesktopResolutionY()
      w*dpifx:h*dpify
      
      If IsGadget(CanvasID) And IsImage(ImageId)
        GetClientRect_(GadgetID(CanvasID),rec.rect)
        If w=0:w=rec\right:EndIf
        If h=0:h=rec\bottom:EndIf
        ResizeImage(ImageId,w,h)
        Result=1
        Else
        CreateImage(ImageId,w,h)
        ImageGadget(CanvasID,x,y,w,h,ImageID(ImageId),flag)
        Result=2
      EndIf 
      
      If Result
        If StartDrawing(ImageOutput(ImageId))
          Box(0,0,w,h,BColor)
          StopDrawing()
        EndIf
        SetGadgetState(CanvasID,ImageID(ImageId))
      EndIf 
      ProcedureReturn Result
    EndProcedure
    
    Procedure PVGadgets_FreeCanvas(CanvasID,ImageId);Free Resources for Specified Canvas/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(CanvasID)
        FreeGadget(CanvasID)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_CanvasFree(CanvasID,ImageId);Free Resources for Specified Canvas/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(CanvasID)
        FreeGadget(CanvasID)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_CanvasButtonRegister(WindowID.i,CanvasID.i,ImageId.i,SubID.i);Register a CanvasButton to List
      AddElement(DynamicCB())
      DynamicCB()\WindowID=WindowID
      DynamicCB()\CanvasID=CanvasID
      DynamicCB()\ImageId=ImageId
      DynamicCB()\SubID=SubID
      SetWindowLong_(GadgetID(CanvasID),#GWL_STYLE,GetWindowLong_(GadgetID(CanvasID),#GWL_STYLE)!#SS_NOTIFY)
    EndProcedure
    
    Procedure PVGadgets_CanvasButtonAdd(WindowID.i,CanvasID.i,ImageId.i,SubID.i);Add a CanvasButton to List
      AddElement(DynamicCB())
      DynamicCB()\WindowID=WindowID
      DynamicCB()\CanvasID=CanvasID
      DynamicCB()\ImageId=ImageId
      DynamicCB()\SubID=SubID
      SetWindowLong_(GadgetID(CanvasID),#GWL_STYLE,GetWindowLong_(GadgetID(CanvasID),#GWL_STYLE)!#SS_NOTIFY)

    EndProcedure
    
    Procedure.i PVGadgets_CanvasButtonFree(CanvasID.i);Free specified CanvasID from CanvasButton List
      Protected Result=0
      ForEach DynamicCB()
        If DynamicCB()\CanvasID=CanvasID
          DeleteElement(DynamicCB())
          Result=1
          Break
        EndIf
      Next
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i PVGadgets_CanvasButtonDelete(CanvasID.l);Delete specified CanvasID from CanvasButton List
      Protected Result=0
      ForEach DynamicCB()
        If DynamicCB()\CanvasID=CanvasID
          DeleteElement(DynamicCB())
          Result=1
          Break
        EndIf
      Next
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i PVGadgets_CanvasButtonPressed();Return CanvasID of CanvasButton if MouseOver
      Protected Result
      ForEach DynamicCB()
        If DynamicCB()\Used
          Result=DynamicCB()\CanvasID
          Break
        EndIf
      Next
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i PVGadgets_CanvasButtonHover(WindowID.i);Replace Original Image with Sub Image if MouseOver
      Protected Result=0
      Protected mouse.POINT,rect.rect
      ForEach DynamicCB()
        GetCursorPos_(mouse) 
        ScreenToClient_(GadgetID(DynamicCB()\CanvasID),mouse) 
        GetClientRect_(GadgetID(DynamicCB()\CanvasID),rect) 
        If (mouse\x>-1) And (mouse\x<rect\right) And (mouse\y>-1) And (mouse\y<rect\bottom) And DynamicCB()\WindowID=WindowID
          If DynamicCB()\Used=0
            SetGadgetState(DynamicCB()\CanvasID,ImageID(DynamicCB()\SubID))
            DynamicCB()\Used=1
            Result=DynamicCB()\CanvasID
          EndIf
          Else
          If DynamicCB()\Used=1
            SetGadgetState(DynamicCB()\CanvasID,ImageID(DynamicCB()\ImageId))
            DynamicCB()\Used=0
          EndIf
        EndIf
      Next
      ProcedureReturn Result
    EndProcedure
    
    Procedure.i PVGadgets_CanvasEnableClick(CanvasID.i);Enables Mouse Click Event to Canvas Gadget
      ProcedureReturn SetWindowLong_(GadgetID(CanvasID),#GWL_STYLE,GetWindowLong_(GadgetID(CanvasID),#GWL_STYLE)|#SS_NOTIFY)
    EndProcedure
    
    Procedure.i PVGadgets_CanvasDisableClick(CanvasID.i);Disables Mouse Click Event from Canvas Gadget
      ProcedureReturn SetWindowLong_(GadgetID(CanvasID),#GWL_STYLE,GetWindowLong_(GadgetID(CanvasID),#GWL_STYLE)!#SS_NOTIFY)
    EndProcedure
  
  
  ;-
  ;----- ProgressBar
    Procedure.i PVGadgets_ProgressBar(BarID,ImageId,x,y,w,h,Progress,Shadow,BColor,FColor1,FColor2,flag=0);Create/Update ProgressBar Gadget
      Protected progbar.f,progbar2.i,sRed.f,sGreen.f,sBlue.f,r.f,g.f,b.f
      Protected xx.f,yy.f,zz.f,grad.i,txtht.i,txtlen.i,Result.i
      Protected rec.RECT
      Protected dpifx.d = DesktopResolutionX()
      Protected dpify.d = DesktopResolutionY()
      w*dpifx:h*dpify
            
      If Progress<0:Progress=0:EndIf
      If Progress>100:Progress=100:EndIf
      
      If IsGadget(BarID) And IsImage(ImageId)
        If x=0:x=GadgetX(BarID):EndIf
        If y=0:y=GadgetY(BarID):EndIf
        GetClientRect_(GadgetID(BarID),rec)
        If w=0:w=rec\right:EndIf
        If h=0:h=rec\bottom:EndIf
        ResizeImage(ImageId,w,h)
        Result=1
        Else
        If w<1:w=1:EndIf
        If h<1:h=1:EndIf
        If flag=0 Or flag=2 Or flag=#PB_Image_Border
          ;ok
          Else
          flag=0
        EndIf
        CreateImage(ImageId,w,h)
        ImageGadget(BarID,x,y,w,h,ImageID(ImageId),flag)
        Result=2
      EndIf
      
      If Result
        progbar=(Progress/100)*w
        progbar2=Round(progbar,0)
        sRed.f   = Red(FColor1)   : r.f = (Red  (FColor1) - Red  (FColor2))/w 
        sGreen.f = Green(FColor1) : g.f = (Green(FColor1) - Green(FColor2))/w 
        sBlue.f  = Blue(FColor1)  : b.f = (Blue (FColor1) - Blue (FColor2))/w 
        If IsImage(ImageId)
          If StartDrawing(ImageOutput(ImageId))
            If BColor<0
              Box(0,0,w,h,GetSysColor_(#COLOR_BTNFACE))
              Else
              Box(0,0,w,h,BColor)
            EndIf
            For grad=0 To progbar2-1
              xx.f=sRed-grad*r 
              yy.f=sGreen-grad*g 
              zz.f=sBlue-grad*b 
              Line(grad,0,1,h,RGB(xx,yy,zz)) 
            Next
            If Result=1
              If Shadow>-1
                DrawingMode(#PB_2DDrawing_Transparent)
                txtht=(h/2)-8
                If txtht<0:txtht=0:EndIf 
                txtlen=TextWidth(Str(Progress)+"%")
                If Shadow
                  FrontColor(RGB($00,$00,$00))
                  DrawText(((w/2)-(txtlen/2))+1,txtht+1,Str(Progress)+"%")
                EndIf
                FrontColor(RGB($FF,$FF,$FF))
                DrawText((w/2)-(txtlen/2),txtht,Str(Progress)+"%")
              EndIf
            EndIf
            If flag=2
              DrawingMode(#PB_2DDrawing_Outlined)
              Box(0,0,w,h,RGB(0,0,0))
            EndIf
            StopDrawing() 
          EndIf
          SetGadgetState(BarID,ImageID(ImageId))
        EndIf
      EndIf 
      ProcedureReturn Result
    EndProcedure
    
    Procedure PVGadgets_FreeProgressBar(BarID,ImageId);Free Resources for Specified ProgressBar/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(BarID)
        FreeGadget(BarID)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_ProgressBarFree(BarID,ImageId);Free Resources for Specified ProgressBar/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(BarID)
        FreeGadget(BarID)
      EndIf
    EndProcedure
  
  
  ;-
  ;----- PieChart
    Procedure.i PVGadgets_PieChart(GadgetID,ImageId,x,y,w,h,BackColor,PieBack,PieFront,Progress,FontID,TextColor=0);Create/Update PieChart Gadget
      Protected dc,pen,brush,color,cstate,mx,my,rx.f,ry.f,x2,y2,angle.f
      Protected text.s,frontcolor,diffx,diffy,Result
      Protected rec.RECT
      Protected dpifx.d = DesktopResolutionX()
      Protected dpify.d = DesktopResolutionY()
      w*dpifx:h*dpify
            
      If Progress<0:Progress=0:EndIf
      If Progress>100:Progress=100:EndIf
      
      If IsGadget(GadgetID) And IsImage(ImageId)
        If x=0:x=GadgetX(GadgetID):EndIf
        If y=0:y=GadgetY(GadgetID):EndIf
        GetClientRect_(GadgetID(GadgetID),rec)
        If w=0:w=rec\right:EndIf
        If h=0:h=rec\bottom:EndIf
        ResizeImage(ImageId,w,h)
        Result=1
        Else
        CreateImage(ImageId,w,h)
        ImageGadget(GadgetID,x,y,w,h,ImageID(ImageId))
        Result=2
      EndIf
      
      If Result
        dc=StartDrawing(ImageOutput(ImageId))
        If dc
          If BackColor=-1
            Box(0,0,w,h,GetSysColor_(#COLOR_BTNFACE))
            Else
            Box(0,0,w,h,BackColor)
          EndIf
          pen=CreatePen_(#PS_SOLID,1,PieBack)
          brush=CreateSolidBrush_(PieBack)
          SelectObject_(dc,brush):SelectObject_(dc,pen)
          Ellipse_(dc,0,0,w,h)
          DeleteObject_(brush):DeleteObject_(pen)
          
          pen=CreatePen_(#PS_SOLID,1,0)
          If frontcolor=-1
            cstate=Progress*448/100
            If cstate<256
              color=RGB(255,cstate,0)
              Else
              cstate-256
              color=RGB(255-cstate,255,0)
            EndIf
            brush=CreateSolidBrush_(color)
            Else 
            brush=CreateSolidBrush_(PieFront)
          EndIf
          SelectObject_(dc,brush) : SelectObject_(dc,pen)
          angle=Progress * 360 / 100
          If angle>0
            If angle>358
              Ellipse_(dc,0,0,w,h)
              Else
              mx=w/2 : my=h/2
              rx = 0 - (0 - my) * Sin(6.28318531*angle/360) + mx
              ry = (0 - my) * Cos(6.28318531*angle/360) + my
              x2 = rx : y2 = ry
              Pie_(dc,0,0,w,h,x2,y2,w/2,0)
            EndIf
          EndIf
          DeleteObject_(brush) : DeleteObject_(pen)
    
          If FontID
            If IsFont(FontID)
              DrawingFont(FontID(FontID))
            EndIf
            DrawingMode(#PB_2DDrawing_Transparent)
            text = Str(Progress)+"%"
            diffx=(w-TextWidth(text))/2:diffy=(h-TextHeight(text))/2
            DrawText(diffx,diffy,text,TextColor)        
          EndIf
          
          StopDrawing()
        EndIf
        SetGadgetState(GadgetID,ImageID(ImageID)) 
      EndIf
      
      ProcedureReturn Result
    EndProcedure
    
    Procedure PVGadgets_FreePieChart(GadgetID,ImageId);Free Resources for Specified PieChart/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(GadgetID)
        FreeGadget(GadgetID)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_PieChartFree(GadgetID,ImageId);Free Resources for Specified PieChart/Image
      If IsGadget(ImageId)
        FreeImage(ImageId)
      EndIf
      If IsGadget(GadgetID)
        FreeGadget(GadgetID)
      EndIf
    EndProcedure
  
  
  ;-
  ;----- Extra Window Functions
    Procedure PVGadgets_WindowFreeze(Window.i,MaxWindows.i);Freeze all Windows except specified Window
      Protected.i tmp
      EnableWindow_(WindowID(Window),0)
      For tmp=0 To MaxWindows
        If IsWindow(tmp)
          EnableWindow_(WindowID(tmp),0)
        EndIf
      Next
      EnableWindow_(WindowID(Window),1)
      BringWindowToTop_(WindowID(Window))
    EndProcedure
    
    Procedure PVGadgets_WindowUnfreeze(Window.i,MaxWindows.i);UnFreeze all Windows and activate specified Window
      Protected.i tmp
      For tmp=0 To MaxWindows
        If IsWindow(tmp)
          EnableWindow_(WindowID(tmp),1)
        EndIf
      Next
      EnableWindow_(WindowID(Window),1)
      BringWindowToTop_(WindowID(Window))
      SetForegroundWindow_(WindowID(Window)) 
    EndProcedure
    
    Procedure PVGadgets_WindowTop(Window.i);Force Window to always on top
      SetWindowPos_(WindowID(Window),#HWND_TOPMOST,0,0,0,0,#SWP_NOACTIVATE|#SWP_NOMOVE|#SWP_NOSIZE)
    EndProcedure
    
    Procedure PVGadgets_WindowReset(Window.i);Reset Window to not always on top
      SetWindowPos_(WindowID(Window),#HWND_NOTOPMOST,0,0,0,0,#SWP_NOACTIVATE|#SWP_NOMOVE|#SWP_NOSIZE)
    EndProcedure
    
    Procedure PVGadgets_WindowTransparent(Window.i,Transparency.i);Set Transparentcy on a Window (Win 2000/XP)
      Protected.i osv,lib,SetLayeredWindowAttributes
      osv=OSVersion()
      If osv=#PB_OS_Windows_2000 Or osv=#PB_OS_Windows_XP Or osv=#PB_OS_Windows_Future
        If Transparency<0:Transparency=0:EndIf
        If Transparency>255:Transparency=255:EndIf
        SetWindowLong_(WindowID(Window),#GWL_EXSTYLE,GetWindowLong_(WindowID(Window),#GWL_EXSTYLE)|$80000) ;#WS_EX_LAYERED  
        lib=OpenLibrary(#PB_Any,"User32.dll")
        If lib
          SetLayeredWindowAttributes=GetFunction(lib,"SetLayeredWindowAttributes")
          If SetLayeredWindowAttributes
            CallFunctionFast(SetLayeredWindowAttributes,WindowID(Window),0,Transparency,$2) ;#LWA_ALPHA 
          EndIf
          CloseLibrary(lib)
        EndIf
      EndIf
    EndProcedure
    
    Procedure PVGadgets_ToolWindow(Window.i);Convert Window to a Tool Window
      SetWindowLong_(WindowID(Window),#GWL_EXSTYLE,GetWindowLong_(WindowID(Window),#GWL_EXSTYLE)|#WS_EX_TOOLWINDOW)
      ResizeWindow(Window,#PB_Ignore,#PB_Ignore,#PB_Ignore,#PB_Ignore)
    EndProcedure


    Procedure.i GetTaskBarState() ;Returns 0=Visible / 1=Hidden
      TaskBar = FindWindow_("Shell_TrayWnd",0)
      tbdata.AppBarData
      tbdata\cbSize = SizeOf(tbdata)
      tbdata\hwnd = TaskBar      
      ProcedureReturn SHAppBarMessage_(#ABM_GETSTATE,@tbdata) 
    EndProcedure

    Procedure.i HideTaskBar(flag.i=#True) ;Hide=#True / Show=#False
      TaskBar = FindWindow_("Shell_TrayWnd",0)
      tbdata.AppBarData
      tbdata\cbSize = SizeOf(tbdata)
      tbdata\hwnd = TaskBar
      tbdata\lParam = flag      
      SHAppBarMessage_(#ABM_SETSTATE,@tbdata)
      ProcedureReturn SHAppBarMessage_(#ABM_GETSTATE,@tbdata) 
    EndProcedure

     
  
  ;-
  ;----- Extra Path Functions
    Procedure.s PVGadgets_GetAppDirectory();Returns Path of Application Directory
      Protected.s exepath
      exepath=Space(512)
      GetModuleFileName_(0,@exepath,512)
      exepath=GetPathPart(exepath)
      If Right(exepath,1)<>"\":exepath+"\":EndIf
      ProcedureReturn exepath
    EndProcedure
  
  
  ;-
  ;----- Extra Number Functions
    Procedure.s PVGadgets_FormatNumber(Number.s,Group.i=3,DecDig.i=2,DecSep.s=".",GrpSep.s=",",Neg.i=0);Format Number String
      Protected Buffer.s,NF.NUMBERFMT
      Buffer.s=Space(255)
      NF.NUMBERFMT\NumDigits=DecDig
      NF\LeadingZero=0
      NF\Grouping=Group
      NF\lpDecimalSep=@DecSep
      NF\lpThousandSep=@GrpSep
      NF\NegativeOrder=Neg
      GetNumberFormat_(0,0,Number,NF,@Buffer,Len(Buffer))
      ProcedureReturn Buffer
    EndProcedure
  
  
  ;-
  ;----- Calendar Commands
    Procedure.s PVGadgets_GetCalendarDate(GadgetID.i);Get Date of Selected Gadget
      Protected time.SYSTEMTIME
      SendMessage_(GadgetID(GadgetID),$1001,0,@time.SYSTEMTIME)
      ProcedureReturn RSet(Str(time\wYear),4,"0")+RSet(Str(time\wMonth),2,"0")+RSet(Str(time\wDay),2,"0")
    EndProcedure
    
    Procedure.i PVGadgets_SetCalendarDate(GadgetID.i,year.i,month.i,day.i);Get Date of Selected Gadget
      Protected time.SYSTEMTIME
      time\wYear=year
      time\wMonth=month
      time\wDay=day
      ProcedureReturn SendMessage_(GadgetID(GadgetID),$1002,0,@time.SYSTEMTIME)
    EndProcedure
  
  
  ;-
  ;----- Refresh Gadgets
    Procedure.i PVGadgets_Refresh(GadgetID.i);Force Redraw on Specified Gadget
      If IsGadget(GadgetID)
        InvalidateRgn_(GadgetID(GadgetID),0,1)
        ProcedureReturn 1
      EndIf
    EndProcedure
    
    Procedure.i PVGadgets_RefreshWindow(WindowID.i);Force Refresh on Specified Window
      If IsWindow(WindowID)
        RedrawWindow_(WindowID(WindowID),0,0,#RDW_ERASE|#RDW_INVALIDATE)
        ProcedureReturn 1
      EndIf
    EndProcedure
  
  
  ;-
  ;----- Start Once
    Procedure.i PVGadgets_StartOnce(name.s);Allow only one instance of Program to Start
      Protected OnlyOneStartMutex.i=CreateMutex_(0,1,name)
      Protected OnlyOneStartError.i=GetLastError_()
      If OnlyOneStartMutex<>0 And OnlyOneStartError=0
        ProcedureReturn OnlyOneStartMutex
        Else
        CloseHandle_(OnlyOneStartMutex)
        End
      EndIf
    EndProcedure
  
  
  ;-
  ;----- API Error
    Procedure.s PVGadgets_APIError();Return Last Error Message from API Call
      Protected ErrorBuffer.s=Space(200)
      FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM,0,GetLastError_(),#LANG_NEUTRAL,@ErrorBuffer,200,0)
      ErrorBuffer=ReplaceString(ErrorBuffer,#CRLF$,"")
      ProcedureReturn ErrorBuffer
    EndProcedure
  
  
  ;-
  ;----- Extra ListIcon Functions
    Procedure.i PVGadgets_CountListIconColumns(GadgetID.i);Count Number of Columns in ListIcon
      Protected hHeader.i
      hHeader=SendMessage_(GadgetID(GadgetID),#LVM_FIRST+31,0,0)
      ProcedureReturn SendMessage_(hHeader,#HDM_GETITEMCOUNT,0,0)
    EndProcedure
    
    Procedure.i PVGadgets_GetListIconColumnWidth(GadgetID.i,column);Get Column Width of ListIcon
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_GETCOLUMNWIDTH,column,0)
    EndProcedure
    
    Procedure.i PVGadgets_SetListIconColumnWidth(GadgetID.i,column.i,Width.i);Set Column Width of ListIcon
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SETCOLUMNWIDTH,column,Width)
    EndProcedure
    
    Procedure.i PVGadgets_JustifyListIconColumn(GadgetID.i,column.i,flag.i);Justify ListIcon Column 0-Left 1-Right 2-Center
      Protected lvc.LV_COLUMN
      lvc\Mask = #LVCF_FMT 
      Select flag
        Case 1
          lvc\fmt=#LVCFMT_RIGHT
        Case 2
          lvc\fmt=#LVCFMT_CENTER
        Default
          lvc\fmt=#LVCFMT_LEFT
      EndSelect
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SETCOLUMN,column,@lvc)
    EndProcedure
    
    Procedure.i PVGadgets_ListIconColumn(GadgetID.i,column.i,flag.i);Justify ListIcon Column 0-Left 1-Right 2-Center
      Protected lvc.LV_COLUMN
      lvc\Mask = #LVCF_FMT 
      Select flag
        Case 1
          lvc\fmt=#LVCFMT_RIGHT
        Case 2
          lvc\fmt=#LVCFMT_CENTER
        Default
          lvc\fmt=#LVCFMT_LEFT
      EndSelect
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SETCOLUMN,column,@lvc)
    EndProcedure
    
    CompilerIf Not #ExcludeListIconImage
    Procedure.i PVGadgets_CreateListIconImageList(GadgetID.i);Create an ImageList for a ListIconGadget
      Protected hImageList
      hImageList=ImageList_Create_(16,16,#ILC_MASK|#ILC_COLOR32,0,15) 
      SendMessage_(GadgetID(GadgetID),#LVM_SETIMAGELIST,#LVSIL_SMALL,hImageList)  
      ImageList_SetBkColor_(hImageList,#CLR_NONE)  
      SendMessage_(GadgetID(GadgetID),$1036,$2,$2) 
      ImageList_ReplaceIcon_(hImageList,-1,ImageID(CatchImage(#PB_Any,?NullImageStart,?NullImageEnd-?NullImageEnd)))
      ProcedureReturn hImageList
    EndProcedure
    CompilerEndIf
    
    Procedure.i PVGadgets_FreeListIconImageList(hImageList.i);Free a previously created ImageList
      ProcedureReturn ImageList_Destroy_(hImageList.i)
    EndProcedure
    
    Procedure.i PVGadgets_AddListIconImageList(hImageList.i,hImageId.i);Add an Icon to an ImageList 
      ProcedureReturn ImageList_ReplaceIcon_(hImageList,-1,hImageId) 
    EndProcedure
    
    Procedure.i PVGadgets_ChangeListIconImage(GadgetID.i,row.i,column.i,hIcon.i=0);Changes the Icon in a ListIconGadget
      Protected LVG.LV_ITEM,txt$     
      LVG\Mask=#LVIF_IMAGE|#LVIF_TEXT 
      LVG\iItem=row 
      LVG\iSubItem=column
      txt$=GetGadgetItemText(GadgetID,row,column)
      LVG\pszText=@txt$ 
      LVG\iImage=hIcon  
      SetGadgetItemText(GadgetID,row,txt$,column)
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SETITEM,0,@LVG) 
    EndProcedure
    
    Procedure.i PVGadgets_LastListIconRow(GadgetID.i);Make the last row in a ListIconGadget visible
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_ENSUREVISIBLE,CountGadgetItems(GadgetID)-1,0)
    EndProcedure
    
    Procedure.i PVGadgets_SelectListIconRow(GadgetID.i,row.i);Select a ListIconGadget row and make visible
      SetGadgetState(GadgetID,row)
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_ENSUREVISIBLE,row,0)
    EndProcedure

    Procedure.i PVGadgets_CenterListIconRow(GadgetID.i,row.i);Select a ListIconGadget row and make visible in center
      Protected center,rowheight
      center=SendMessage_(GadgetID(GadgetID),#LVM_GETCOUNTPERPAGE,0,0)/2
      actualtoprow=SendMessage_(GadgetID(GadgetID),#LVM_GETTOPINDEX,0,0)
      rowheight=PVGadgets_HiWord(SendMessage_(GadgetID(GadgetID),#LVM_GETITEMSPACING,#True,0))
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SCROLL,0,((row-center)-actualtoprow)*rowheight)
    EndProcedure
    
    Procedure.i PVGadgets_ListIconTitle(GadgetID.i,column.i,text.s)
      Protected lvc.LV_COLUMN 
      lvc\Mask=#LVCF_TEXT 
      lvc\pszText=@text 
      ProcedureReturn SendMessage_(GadgetID(GadgetID),#LVM_SETCOLUMN,column,@lvc) 
    EndProcedure
  
  
  ;-
  ;----- AnimGadget Commands
    Procedure.i PVGadgets_InitAnimGadget();Initialize AnimGadget
      ProcedureReturn LoadLibrary_("Shell32.dll")
    EndProcedure
    
    Procedure.i PVGadgets_AnimGadget(hAnimGadget.i,Window.i,x,y,w,h,flag.i);Create AnimGadget
      Protected Result
      Protected dpifx.d = DesktopResolutionX()
      Protected dpify.d = DesktopResolutionY()
      Result=CreateWindowEx_(0,"SysAnimate32","",#ACS_CENTER|#ACS_TRANSPARENT|#WS_CHILD|#WS_VISIBLE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS,x*dpifx,y*dpify,w*dpifx,h*dpify,WindowID(Window),0,GetModuleHandle_(0),0)
      SendMessage_(Result,#ACM_OPEN,hAnimGadget,flag)
      SendMessage_(Result,#ACM_PLAY,-1,-1)
      ProcedureReturn Result
    EndProcedure
    
    Procedure PVGadgets_AnimGadgetPlay(GadgetID.i,Loop.i=-1,First.w=-1,Last.w=-1);Play Animation (Default=Loop Forever)
      SendMessage_(GadgetID,#ACM_PLAY,Loop,(First|Last<<16))
    EndProcedure
    
    Procedure PVGadgets_AnimGadgetStop(GadgetID.i);Stop Animation
      SendMessage_(GadgetID,#ACM_STOP,0,0)
    EndProcedure
    
    Procedure PVGadgets_AnimGadgetHide(GadgetID.i,flag.i);0=Show 1=Hide  
      If flag
        ShowWindow_(GadgetID,#SW_HIDE)
        Else
        ShowWindow_(GadgetID,#SW_SHOW)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_FreeAnimGadget(hAnimGadget);Free AnimGadget
      FreeLibrary_(hAnimGadget)
    EndProcedure
    
    Procedure.i PVGadgets_FreeAnimGadgetImages(ImagePath.s);Delete All AnimGadget AVI Images from Folder
      Protected quitDelete.i
      If Right(ImagePath,1)<>"\":ImagePath+"\":EndIf
      If ExamineDirectory(0,ImagePath,"*.avi")
        Repeat
          quitDelete=NextDirectoryEntry(0)
          If quitDelete=1
            DeleteFile(ImagePath+DirectoryEntryName(0)) 
          EndIf
        Until quitDelete=0
        ProcedureReturn 1
      EndIf
    EndProcedure
  
  
  ;-
  ;----- BubbleTips
    Procedure.i PVGadgets_BubbleTipDelete(bWindow.i,bGadget.i,hTip.i)
      Protected Button.TOOLINFO
      Button\cbSize=SizeOf(TOOLINFO)
      Button\hwnd=WindowID(bWindow)
      Button\uID=GadgetID(bGadget)
      SendMessage_(hTip,#TTM_DELTOOL,0,Button)
    EndProcedure
    
    Procedure.i PVGadgets_BubbleTipChange(bWindow.i,bGadget.i,hTip.i,bText.s)
      Protected Button.TOOLINFO
      Button\cbSize=SizeOf(TOOLINFO)
      Button\hwnd=WindowID(bWindow)
      Button\uID=GadgetID(bGadget)
      Button\lpszText=@bText
      SendMessage_(hTip,#TTM_UPDATETIPTEXT,0,Button)
    EndProcedure
    
    Procedure.i PVGadgets_BubbleTip(bWindow.i,bGadget.i,bText.s,flag.i=0,BColor.i=$DFFFFF)
      Protected ToolTipControl,Button.TOOLINFO
      Select flag
        Case -1
          ;disable tips
          ;SendMessage_(bGadget,#TTM_ACTIVATE,#False,0)
          
        Case 1
          GadgetToolTip(bGadget,bText)
          
        Default 
          ToolTipControl=CreateWindowEx_(0,"ToolTips_Class32","",#WS_POPUP|#TTS_NOPREFIX|#TTS_BALLOON,0,0,0,0,WindowID(bWindow),0,GetModuleHandle_(0),0)
          SetWindowPos_(ToolTipControl,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE)
          SendMessage_(ToolTipControl,#TTM_SETTIPTEXTCOLOR,0,0)
          SendMessage_(ToolTipControl,#TTM_SETTIPBKCOLOR,BColor,0)
          SendMessage_(ToolTipControl,#TTM_SETMAXTIPWIDTH,0,180)
          Button\cbSize=SizeOf(TOOLINFO)
          Button\uFlags=#TTF_IDISHWND|#TTF_SUBCLASS
          Button\hwnd=WindowID(bWindow)
          Button\uID=GadgetID(bGadget)
          Button\hInst=0
          Button\lpszText=@bText
          SendMessage_(ToolTipControl,#TTM_ADDTOOL,0,Button)
          SendMessage_(ToolTipControl,#TTM_UPDATE,0,0)
      EndSelect
      ProcedureReturn ToolTipControl
    EndProcedure
  
  
  ;-
  ;----- PureSkin Lib
    CompilerIf Not #ExcludePureSkin
    Procedure.i PureSkin(Window,Gadget,image,file.s,center.i=#True) ;Skin the Selected Window from File
      UseJCALG1Packer()
      UseZipPacker()    
      Protected quality.b,compress.b,length.i,pack.i
      Protected usemem0.i,usemem1.i,Width.i,Height.i,hReg.i,pos.i,cx.i,cy.i
      Protected x.i,y.i,w.i,pixel.i,Result,hFile
      
      hFile=ReadFile(#PB_Any,file)
      If hFile
        quality=ReadByte(hFile)
        compress=ReadByte(hFile)
        length=ReadLong(hFile)
        pack=ReadLong(hFile)
        file.s=ReadString(hFile,#PB_Ascii)
        
        If Left(file,13)="PureSkin - Co" Or file="PureSkin-v510"
          If compress
            usemem0=AllocateMemory(pack)
            ReadData(hFile,usemem0,pack)
            usemem1=AllocateMemory(length)
            
            If file="PureSkin-v510"
              UncompressMemory(usemem0,pack,usemem1,length,#PB_PackerPlugin_Zip)
              Else
              UncompressMemory(usemem0,pack,usemem1,length,#PB_PackerPlugin_JCALG1)
            EndIf
                    
            Else
            usemem1=AllocateMemory(length)
            ReadData(hFile,usemem1,length)
          EndIf 
                 
          If CatchImage(Image,usemem1)
            Width=ImageWidth(Image)
            Height=ImageHeight(Image)
            
            ResizeWindow(Window,#PB_Ignore,#PB_Ignore,Width,Height)
            hReg=CreateRectRgn_(0,0,Width,Height)
            
            length=ReadLong(hFile)
            usemem1=AllocateMemory(length)
            ReadData(hFile,usemem1,length)        
      
            pos=0
            While pos<length
              x=PeekW(usemem1+pos):pos+2
              y=PeekW(usemem1+pos):pos+2
              w=PeekW(usemem1+pos):pos+2
              pixel=CreateRectRgn_(x,y,w,y+quality)
              CombineRgn_(hReg,hReg,pixel,#RGN_XOR)
              DeleteObject_(pixel)
            Wend
            
            SetWindowRgn_(WindowID(Window),hReg,1)
            
            If Center
              cx=(GetSystemMetrics_(#SM_CXSCREEN)/2)-(Width/2)
              cy=(GetSystemMetrics_(#SM_CYSCREEN)/2)-(Height/2)
              SetWindowPos_(WindowID(Window),#HWND_TOP,cx,cy,Width,Height,#SWP_SHOWWINDOW)
            EndIf

            ImageGadget(Gadget,0,0,Width,Height,ImageID(Image))
            SetWindowLong_(GadgetID(Gadget),#GWL_STYLE,GetWindowLong_(GadgetID(Gadget),#GWL_STYLE)!#SS_NOTIFY)
           
            Result=1
          EndIf
          
          If usemem0:FreeMemory(usemem0):EndIf
          If usemem1:FreeMemory(usemem1):EndIf
        EndIf
        CloseFile(hFile)
      EndIf
      ProcedureReturn Result
    EndProcedure
    Procedure.i PureSkinMem(Window,Gadget,image,pos.i,center.i=#True) ;Skin the Selected Window from Memory
      UseJCALG1Packer()
      UseZipPacker()    
      Protected quality.b,compress.b,length.i,pack.i,file.s
      Protected usemem0.i,usemem1.i,Width.i,Height.i,hReg.i,cx.i,cy.i
      Protected x.i,y.i,w.i,pixel.i,Result
  
      quality=PeekB(pos):pos+1
      compress=PeekB(pos):pos+1
      length=PeekL(pos):pos+4
      pack=PeekL(pos):pos+4
      file=PeekS(pos,13,#PB_Ascii)
      If file="PureSkin - Co":pos+50:EndIf
      If file="PureSkin-v510":pos+15:EndIf
                         
      If file="PureSkin - Co" Or file="PureSkin-v510"      
        If compress
          usemem0=AllocateMemory(pack)
          CopyMemory(pos,usemem0,pack)
          usemem1=AllocateMemory(length)
          
          If file="PureSkin-v510"
            UncompressMemory(usemem0,pack,usemem1,length,#PB_PackerPlugin_Zip)
            Else
            UncompressMemory(usemem0,pack,usemem1,length,#PB_PackerPlugin_JCALG1)
          EndIf      
    
          pos+pack
          Else
          usemem1=AllocateMemory(length)
          CopyMemory(pos,usemem1,length)
          pos+length
        EndIf 
    
        If CatchImage(Image,usemem1,length)
          Width=ImageWidth(Image)
          Height=ImageHeight(Image)      
          ResizeWindow(Window,#PB_Ignore,#PB_Ignore,Width,Height)
          hReg=CreateRectRgn_(0,0,Width,Height)      
          length=PeekL(pos):pos+4      
          usemem1=AllocateMemory(length)
          CopyMemory(pos,usemem1,length)        
      
          pos=0
          While pos<length
            x=PeekW(usemem1+pos):pos+2
            y=PeekW(usemem1+pos):pos+2
            w=PeekW(usemem1+pos):pos+2
            pixel=CreateRectRgn_(x,y,w,y+quality)
            CombineRgn_(hReg,hReg,pixel,#RGN_XOR)
            DeleteObject_(pixel)
          Wend
          
          
          SetWindowRgn_(WindowID(Window),hReg,1)
          If Center
            cx=(GetSystemMetrics_(#SM_CXSCREEN)/2)-(Width/2)
            cy=(GetSystemMetrics_(#SM_CYSCREEN)/2)-(Height/2)
            SetWindowPos_(WindowID(Window),#HWND_TOP,cx,cy,Width,Height,#SWP_HIDEWINDOW) ;SHOWWINDOW)
          EndIf
      
          ImageGadget(Gadget,0,0,Width,Height,ImageID(Image))
          SetWindowLong_(GadgetID(Gadget),#GWL_STYLE,GetWindowLong_(GadgetID(Gadget),#GWL_STYLE)!#SS_NOTIFY)
          Result=1
        EndIf
        
        If usemem0:FreeMemory(usemem0):EndIf
        If usemem1:FreeMemory(usemem1):EndIf
        ProcedureReturn Result
      EndIf
    EndProcedure
    Procedure PureSkinHide(Window.i,flag.i=#False) ;Display a Window that contains a PureSkin
      If flag
        HideWindow(Window,#True)
        Else
        RedrawWindow_(WindowID(Window),0,0,#RDW_UPDATENOW|#RDW_ERASE|#RDW_INVALIDATE|#RDW_ALLCHILDREN)
        HideWindow(Window,#False)
      EndIf
    EndProcedure
    CompilerEndIf
    
    Procedure PVGadgets_NoSkin(GadgetID.i) ;Remove XP Skin From Gadget
      Protected null.w
      If OSVersion()>=#PB_OS_Windows_XP
        SetWindowTheme_(GadgetID(GadgetID),@null,@null)
      EndIf
    EndProcedure
    
    Procedure PVGadgets_NoSkinWin(WindowID.i) ;Remove XP Skin From Window
      Protected null.w
      If OSVersion()>=#PB_OS_Windows_XP
        SetWindowTheme_(WindowID(WindowID),@null,@null)
      EndIf
    EndProcedure
    
    
    CompilerIf Not #ExcludePurePoint
    DataSection
      CursorStart:
      Data.l $FFFFFF7F,$FFFFFF3F,$FFFFFF1F,$FFFFFF0F,$FFFFFF07,$FFFFFF03,$FFFFFF01,$FFFFFF00
      Data.l $FFFF7F00,$FFFF3F00,$FFFF1F00,$FFFF0F00,$FFFFFF00,$FFFFFF00,$FFFF7F18,$FFFF7F38
      Data.l $FFFF3F7C,$FFFF3FFC,$FFFF1FFE,$FFFF1FFE,$FFFF3FFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
      Data.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
      Data.l $00000000,$00000000,$00000040,$00000060,$00000070,$00000078,$0000007C,$0000007E
      Data.l $0000007F,$0000807F,$0000C07F,$0000007E,$00000076,$00000066,$00000043,$00000003
      Data.l $00008001,$00008001,$0000C000,$0000C000,$00000000,$00000000,$00000000,$00000000
      Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
      CursorEnd:
    EndDataSection
    CompilerEndIf
    
    CompilerIf Not #ExcludeListIconImage
    DataSection  
      NullImageStart:
      Data.l $00010000,$10100001,$00000010,$01280000,$00160000,$00280000,$00100000,$00200000
      Data.l $00010000,$00000004,$00800000,$00000000,$00000000,$00000000,$00000000,$00000000
      Data.l $00000000,$80000080,$80000000,$00800080,$00800000,$80800080,$80800000,$C0C00080
      Data.l $000000C0,$FF0000FF,$FF000000,$00FF00FF,$00FF0000,$FFFF00FF,$FFFF0000,$000000FF
      Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
      Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
      Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000
      Data.l $00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$00000000,$FFFF0000
      Data.l $FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000
      Data.l $FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000,$FFFF0000
      Data.a $00
      NullImageEnd:
    EndDataSection
    CompilerEndIf

  CompilerEndIf



  
  CompilerIf Not #ExcludeToolbar
  CompilerIf #PB_Compiler_OS<>#PB_OS_Web And Defined(ToolBarStandardButton,#PB_Function)=0     
    UsePNGImageDecoder()
    Structure hTIL
      id.i
      icon.i
    EndStructure
    NewList hToolbarIconList.hTIL()    
    hToolbarIconStrip=CatchImage(#PB_Any,?stoolbariconstrip,?etoolbariconstrip-?stoolbariconstrip)
      
    Procedure.i ToolBarStandardButton(hBtn.i,hIcon.i,Mode.i,Text.s)
      Shared hToolbarIconList(),hToolbarIconStrip
      ForEach hToolbarIconList()
        If hToolbarIconList()\id=hBtn
          If IsImage(hToolbarIconList()\icon)
            FreeImage(hToolbarIconList()\icon)
            DeleteElement(hToolbarIconList())
            Break
          EndIf
        EndIf
      Next
      hToolbarIcon=GrabImage(hToolbarIconStrip,#PB_Any,48*hIcon,0,48,48)
      AddElement(hToolbarIconList())
      hToolbarIconList()\id=hBtn
      hToolbarIconList()\icon=hToolbarIcon
      ProcedureReturn ToolBarImageButton(hBtn,ImageID(hToolbarIcon),Mode,Text)    
    EndProcedure

    DataSection
      stoolbariconstrip:
      Data.q $0A1A0A0D474E5089,$524448490D000000,$30000000D0020000,$4D8C380000000608,$5845741900000037,$72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$4D58745854698403
      Data.q $64612E6D6F633A4C,$00706D782E65626F,$70783F3C00000000,$65622074656B6361,$BFBBEF223D6E6967,$3557223D64692022,$69686543704D304D,$544E7A5365727A48,$3F226439636B7A63,$706D783A783C203E
      Data.q $6C6D78206174656D,$6461223D783A736E,$6D3A736E3A65626F,$3A7820222F617465,$41223D6B74706D78,$504D582065626F64,$2E352065726F4320,$3720383331632D36,$3432383935312E39,$302F36313032202C
      Data.q $3A31302D34312F39,$20202031303A3930,$203E222020202020,$4644523A6664723C,$723A736E6C6D7820,$70747468223D6664,$772E7777772F2F3A,$39312F67726F2E33,$32322F32302F3939,$6E79732D6664722D
      Data.q $2223736E2D786174,$443A6664723C203E,$6974706972637365,$613A666472206E6F,$2022223D74756F62,$6D783A736E6C6D78,$747468223D4D4D70,$612E736E2F2F3A70,$6D6F632E65626F64,$302E312F7061782F
      Data.q $6D7820222F6D6D2F,$655274733A736E6C,$3A70747468223D66,$6F64612E736E2F2F,$782F6D6F632E6562,$732F302E312F7061,$7365522F65707954,$666552656372756F,$736E6C6D78202223,$7468223D706D783A
      Data.q $2E736E2F2F3A7074,$6F632E65626F6461,$2E312F7061782F6D,$4D706D7820222F30,$6E696769724F3A4D,$656D75636F446C61,$6D78223D4449746E,$66623A6469642E70,$392D653539396432,$373438632D333939
      Data.q $34312D316135612D,$6536643762343934,$4D706D7820223637,$656D75636F443A4D,$6D78223D4449746E,$33363A6469642E70,$4444413537333432,$3441434531314636,$4339414133463436,$2022323634363845
      Data.q $6E493A4D4D706D78,$444965636E617473,$69692E706D78223D,$3733343233363A64,$3131463644443935,$3346343634414345,$3436384543394141,$3A706D7820223236,$54726F7461657243,$6F6441223D6C6F6F
      Data.q $6F746F6850206562,$20434320706F6873,$6957282037313032,$3E222973776F646E,$3A4D4D706D783C20,$4664657669726544,$65527473206D6F72,$6E6174736E693A66,$6D78223D44496563,$61353A6469692E70
      Data.q $622D313137346636,$653435372D353565,$66362D363938382D,$6133363532303863,$6552747320223364,$656D75636F643A66,$6461223D4449746E,$69636F643A65626F,$736F746F68703A64,$313039623A706F68
      Data.q $3464642D32393663,$392D636531312D38,$666135612D646138,$3866656265373135,$64722F3C203E2F22,$6972637365443A66,$3C203E6E6F697470,$4644523A6664722F,$6D783A782F3C203E,$3C203E6174656D70
      Data.q $74656B636170783F,$2272223D646E6520,$0000F11C44833E3F,$DA78544144495D7F,$FFFA551460075DEC,$092BD3776497B666,$A20BA51041D09090,$9DB1514444510362,$9CBDBFF67789EA77,$7A72F67A89E7A9DE
      Data.q $0A080A0AC3677782,$248120484EF480A8,$DEFBFF999B7B67A4,$C83753766ECEECCC,$666F33BA99783E9D,$104615F7BF7DF95E,$986189389D35F804,$971DDF77DDEEFD6E,$B0E1CFB9463A9292,$9544FACE6733986F
      Data.q $FD35FA6BF2BAD7ED,$FBFDFECCFB1BFE9A,$2CE9E0E717171617,$1FDFBF06AD5A82CB,$685D629B7D94D3EA,$D7EB55DDBB73DFAF,$8E65FD4FB5FAAFAF,$D1CAC8CD8A952AB9,$8DB3468C5B272527,$6AC71CBB71E5485C
      Data.q $183057568E9C5BAA,$DE5DE92FFC69C8E4,$1FF5B700B6A72902,$A2757DD425FDEAD0,$D9FF0BC8F4BC532A,$83564A9F178DDF7A,$E4FA7049A3B5FE52,$67F068381DCE4F93,$EC9F8343634341A4,$371E3D99A5A6A7F2
      Data.q $B0582FA79BE6F9BC,$16E574F9D689D560,$44EE01E425536E52,$2EDAFE32AE7F83E8,$CF01138EA6BF4D7E,$5ED81DD168B45DBF,$207CF9F01A346B30,$CB28EF5A1F3CF36F,$D3E1012F72B2B2A9,$FC37D7F874DA6D37
      Data.q $DC663D51A30648CB,$64319FF6FA0B53A4,$2A257939D989A8F8,$10EA4721238ADAB5,$744045C7AF5E650A,$B1D9EE3F3DBED965,$601396DB5DDEF965,$59A0B9D3004BFADD,$DE6A82B7AD9A079C,$755E7F5FFDE4D033
      Data.q $55BF362FCDFC5E6F,$19234D593868795D,$26192A9567E3902B,$20AED9602C86340B,$F8081E83E1CF8E94,$ED353527405CFDF6,$DEECF7D746CD9B1C,$F5FB7D9D7C911F7D,$1414FA092929217B,$93AA2FFAAF76445C
      Data.q $A325A90D6931AB0C,$57EACB6C9C07D292,$0B1A35A9E4E6B26A,$BF9F017149D8A6F9,$7FBB5CD15E5F5ED9,$E57B3EB5CED8EBBB,$D192685E3B384961,$D293218CC66C3318,$AC501DCB4A4E4B72,$EFC5A300883219D5
      Data.q $4D53476EDD040C1C,$5BDDEAA6B2C1CD63,$58AD7CE07F7B8D3C,$198427632CDEB9FF,$3B81F9CFDCFA0256,$5DF65C3E79F016DB,$739CC00B9057DFC2,$C804776F288932A7,$FB0C2CF20799D771,$F6C6EE7EBFE765E1
      Data.q $4F4F4C2D90C0114B,$E3D9E85C71CBCFA7,$FF27DE5A8058E801,$EFBBEEF4BB3B3B36,$CF7D3DEF7BDEECFE,$DDFFCBC2BF753D9E,$ACF5349BA69A9294,$3EBCC2E6773CCFCB,$A74E8CAC5927077D,$9D6338100A958323
      Data.q $980C10392399C242,$1B0E9516070B72B2,$3EAB1D5769A4CA78,$AC36B7EAFD71B0DA,$FFEAC6E6D6D9E6FB,$40723392173D2045,$16660264C606A253,$1F39A4822EF79A03,$E8982F5CBFFFC380,$ED5F3BE28C51340E
      Data.q $0CA2AAAABDAE4298,$385D90470B86EFFE,$CF98FA3ABC74D5D5,$4BDCCC618BAFF731,$2F81EEC7A9ACD121,$7808BDBFD607B89E,$B34FF4F86829EF8E,$88CD382DC0F862AF,$3690651A4B156ADB,$C049FF7306608750
      Data.q $2AC8CB49BF429269,$DADAF5C663E9C8CA,$3F272B21E802269A,$2E9DFB83E1DAB105,$681003B1F8996B47,$39AA3076D8EE00AC,$01FCF972A13569D0,$FCB43E6637BE8210,$9517D544837CAEB9,$3E8CE63B9C9F5936
      Data.q $39F274A734BCCF43,$7B705A33C2D99D1A,$DE252769E0148749,$166A9E692183219E,$EA382F7E82061AB4,$8692D1FADCAD6C0F,$F5D536F413BE5F7D,$9F5B7A6DE9544016,$CC82C17C9C966753,$792D460DE8A663BE
      Data.q $B40BB3E471F1E06D,$A4D4CF943FC86457,$1E0F0C540A83067C,$B2BACB62AC7FCB8F,$0FAAF9634FFB3E9F,$DF9519544C6E9808,$A87807CCC16F83A4,$D6B0DFC005771486,$0530297C9D29471E,$68F85B6CE85A2144
      Data.q $B626DEB060415AF9,$383A0C99D832013C,$574F7DA7A658EA6F,$97F5EC601BC4FFEB,$86F4969595F8F9F4,$F6C8F002690F1DCA,$A000BFFA80DF3F25,$27BCEF3BCE0DF33B,$EC0978DBDDF77DDF,$36E567002E8FB884
      Data.q $BE16AD5A0F5EBD26,$D2F4BD2F95CBF2FC,$DB17A9B1FC7F1F9C,$92E657BB88D2A76F,$06DB7D47E724F7C5,$DECEDA627B6CA792,$47DEF57F2D3D33AA,$C1FF79B29FA6AEF4,$6494AAB0E6359642,$ABBBCF3B26B88DFA
      Data.q $6D64652985716D59,$A3BF9644DE7DE94E,$325E27D3E9F2737E,$641C0C068B17EAFF,$CF9F06A55605494D,$E9176EDC1B976E0B,$97857AC679943DDF,$793BC660E78D5046,$55A3806C6E685EBD,$DB43D9F15BBE5B87
      Data.q $386E82E3957BAE37,$360F7E95BB506671,$64BAF922AEA83243,$E076B0B351304760,$FA263C6E60435697,$888089512385527F,$7D10F470492C5307,$C59C7DC53D8806A7,$277DC152A3037CC8,$ABC8FFDBD8D0BB1B
      Data.q $CE01AB51CD60048F,$8FFF5FA8744FEBB9,$9DCAA4CEE881E2E7,$94C5FFB92F375ADF,$C4E37849019E8364,$BACE7216BAB0750F,$078650046949B407,$0A1F0F8798010F01,$6675AB6D09FE253D,$F5A6040844632D93
      Data.q $439FE5FC1E5EC381,$38A8D07BD0F4DC9F,$C3FAB6DA2C756868,$F2D9D1559E4D86CF,$7B56AB0087FDADEA,$A0CBA20D20EDF69B,$7E980FA635486350,$2B4A496FF349A0F5,$41077168187A722C,$96235AD1F77BE0F0
      Data.q $3C8E0556093CDC30,$29D4069F9D8037B3,$C088C86B3C0C4683,$9E3FC36879DDDF84,$6AE03E22EEFADEAB,$8C6951300849E521,$76988F6733E2B4AA,$E9375282B4D683C3,$9B60FEDC017E3C0E,$06BB92085886425A
      Data.q $7460EBD27D781CFD,$4D060A53F1C2D4DA,$EF9ED8F63968E29A,$16FF77A7F2BB783F,$32999DEB7555D770,$1FEACE09BF6B7AAD,$4E004AA2D5274196,$1112401316E00CBA,$76EC8078023F52BD,$51AEE00737668F1D
      Data.q $20690CE011FE1700,$2F0909CCF0BA74EF,$76520BC064E6010F,$752FD47A1359D67B,$8DC6665BF8981065,$3BD35923A9E2C2D7,$58320786AF506CEB,$B16DB2DC29761F48,$F372F96E9009C1C0,$F4963E833AC5B72C
      Data.q $DD69EB9206BADE6C,$202C3A47FA05FFA6,$4B0714D0D0B7230B,$22AC92C2DF48A8FE,$320EA354BC366A1B,$38B435E7201C912E,$F08011FB911D70E1,$92680306D41E5D78,$BAD669E3EE36C893,$756F8DF0FC7CD75A
      Data.q $66959ECE8A301BF5,$E9C004081C10651F,$4C25E32F13AE8674,$6E4A7BF81AE85326,$1BD3F4FA7D30D5A8,$A2BB2B2B2A5F1B1B,$869EB69EE7E1A1A1,$973E059C7EC639E0,$A200EEE375BD9DE4,$E7C3FE09B6CC3F83
      Data.q $53A2E8EB86738231,$061ADB488B35A118,$75882C6CFC504F3F,$D5DF3CB80BEF778D,$9FCC6051FD2EAD96,$7EFA9FFACF82DA30,$FA9E4E564F3D6F73,$4BA2E333DD17999C,$1A35A8D7CDCECDEF,$A5A5A11B1B9A575A
      Data.q $A08CA011352C5485,$0C65A6A7498126D1,$4ED5BD809848FC04,$DE9D059A20256DCE,$591615E432730604,$85B99933CE6F3F4F,$CB8F7AE0FB2CD7D3,$5203BE8D95BFE479,$4A60265BCD02CD4F,$29F24CF540439DE2
      Data.q $4B42AF39D6075C97,$1A7E9FE6C4245120,$F3E44C6C3F8FC3FD,$8623E1E4E1371F8C,$FD0015EF7D6AEA6F,$A9332748539DAADE,$81B522DB6C1A6E5F,$5695008CD03C459F,$53F1D39AB8155C7E,$4989F076898A7FDD
      Data.q $C52DB3001D53582E,$187DC9C7CEE73CE0,$BF357BBADFE6FB58,$4004F43A72EACEA3,$E69D70911F774047,$5C2BA76A7E351852,$FB5E08B8A8AD0EBC,$B52A06459B90C7E3,$AD6EE560E8173A4A,$A7B36B52504974B3
      Data.q $3CDF6F95EDFA7BCC,$C3210167636B948B,$BE4C1729DF5B19AA,$37171667273FEDFA,$0E4F0B81A6A104B4,$96F90ACE06511E84,$803C905BDF4C3C89,$C81E1FCA78A5252E,$FBDC5FDD9CEE7C1E,$9EC13CA4759E525B
      Data.q $8BE8D66E725D5D7C,$B73CEE325052BD17,$C43111025B871807,$D7812DC1456A212B,$CEA36C5362ACD3CF,$E57C5DC7032DDDFA,$9EEB5595FE2FE5E6,$112CB4B3A3BF3815,$B1C9FD3E66232C38,$33AABD0013362BFD
      Data.q $4F0035C46018BA00,$5B8042D2469F6127,$A13FC03F74819177,$00D9CCF99D097607,$4753DE925B91E7FD,$6F7401177F7F625A,$BB964690299C0225,$8652EC34A3BA20A7,$9E10B2DDD70BEFC9,$38E36AB34B3FD91F
      Data.q $4C01811C15A7D618,$19485E2D1BFEF375,$FBE0B17DB0598F36,$D78C56EF8ECBDFB9,$D9260550AAE2BACF,$5421325E2F063C14,$841D95920C6A95EF,$625D43A13A0CB6F1,$32C938756D19D25E,$E7DFB6E2CC04FC0F
      Data.q $95AF2D4337777783,$07821E39A81133C0,$5D6EEADE0DC869F7,$9A9A90F5F5F53FC4,$E459046ED143EA1A,$06BC55FB2B3DEACE,$262EF379BCD31EFE,$9CFB4F6D77D9370B,$A9AE3B1E6EB9B69E,$1EFCD4080284ED6C
      Data.q $BF4E93C62AF9C6F8,$A19B16626124B507,$DE07CF6FEF901902,$FEA0702E6CFAEC8E,$9E7268C9FEFD37C0,$26E87AA136B09A2D,$7D7FBF0DF5735993,$C0B232D3F3E9B4F2,$34B4254D6D41F5E7,$0D15FA0D25B240B7
      Data.q $D68629844F4E8303,$A7A9107AA9F00A03,$39BF25E07071AA1C,$EBC0CB2B2A1AAC76,$064A4B0668DE82F3,$65B2732CEE3D1D0C,$68E9CB31FFF7B2F9,$D4836FA206DFFFDD,$BEA3C04C5DA00559,$240BCF1794B19513
      Data.q $85F6773AB52AFEEA,$3DB10DD72FB329B3,$1ED1D72A5C5D6677,$D4D9B99C11C8EAA2,$905F05A97BA8B2D5,$EC15A1AF5181316A,$E60F596C0FCF0367,$D3D4B2E9D4428354,$05B462BA57835C19,$FCF779C70604D9DE
      Data.q $A93BA39D476CEE89,$8216FF67630BD5B1,$06168D1ACDF79EC1,$B2429787DC00B99F,$FC36978F1E3D7C59,$3593E96B466D7C6E,$8DCFFFBF4B0BCE76,$92EA42DDBA204817,$D1516A78CF863372,$5D5008B7D497E9A8
      Data.q $0CD3B2261E7F081F,$AAA2319BF842FB77,$5B0040F74070E444,$B3BFE793C0E95A6B,$F37E4ADE0F17D77C,$FF258980B74F2906,$3A87EEF75FA7D1D4,$9B60C42DD3BE6663,$6D31543D10B3C0A3,$D4007B6688D635D0
      Data.q $5C3FF739C4EB14AA,$FFB93E5BD9BCE235,$36D329AD37BCCE86,$309A0FE697279CE8,$7497D81DAAE0E1B1,$601E349C02FA39E6,$EE7BC244B3D1A2B2,$EF414F00E5FC8059,$173CE013E7B073A8,$82EAE90A401B26E0
      Data.q $2344097FF7964E81,$0D5DE7FB852C2E78,$EF2E1FB0956717F7,$5061D5A62D37CB0B,$ADC3810EB74830E6,$79F0CA4336D52F3B,$F39F8E0B16DBC5CC,$6A3A93D04E9DF89D,$8C806C777823F6DF,$1C92D53926533779
      Data.q $2E3388295021CC02,$D4B1285B320CC04A,$AE566022CA3220BC,$E9316DB8A06014F3,$47C166780961AFC1,$F86BC581E197886A,$494CE82579BAD083,$C8CF6F410A1C2DA0,$91D719164618255D,$144142911C387681
      Data.q $C8FDE4F3E5D79670,$73B9F0832D2B233E,$783B54D4D4D15EE7,$8015DAED76FBE0F0,$2689BBE0749B535F,$AA176A158DBB1E08,$A68C426B5295BF18,$C7F42DA14FBA2827,$6FAA01D37ACD5EDE,$E0337C0E0B0DFCE5
      Data.q $B7E278AA7ACEA06F,$1BEAF9E643559E3D,$B7CCE799CA6D796E,$54D42B4B6B43A6A5,$190F06093E83011F,$0EB455A8D03A964D,$46CCE20BC11C0AB1,$06FC1040FEF27490,$87C9CEC8068C981D,$485ED5754177DBCD
      Data.q $0FFA053C00264E4E,$FD3EABECF67A5E1C,$CABB71ED9DAF5FEC,$3636903DF4405BFF,$2ECF009D558B340F,$A1D78CFF8054F7E0,$9EF273BE1A7DA125,$895A189EA42189A5,$A8E3462BAD231CA8,$ABB475E4BFA64675
      Data.q $00AF6F1C7BB65812,$40649ACD3D8AB568,$6D5FDBEF2247B189,$2A91DEC399C5705F,$3C04CF32182AD757,$BBA1A6D0A0EAA417,$FA77B9AAA007350E,$0AD938AE1AB334B5,$1CEA07BA20246F6F,$6D3F0A5A90BD70F1
      Data.q $D4ED0CDC7EEB0DDB,$1C0C9052B1EB988E,$74E608C89209BC39,$BC7ACE858CA47A7B,$E1F73F67538CECAA,$37935222FEFFEF8F,$33949A95388302C4,$6758B5BF57C9D4E6,$32436817523C282D,$005182D7EC3840CB
      Data.q $B42C3699AF81466B,$C86E8318E167C4BC,$92B16F57B73E8FF9,$D7D1A5D3CA433EDB,$5B9FF3A9C4F277D6,$783E3F9F364C141A,$E702DA669A062016,$00AB536C9D8086E8,$7786ED361A4F7D19,$0C327763E1F0FC57
      Data.q $8D1B162F81F91AFB,$2ECE3E27F4E079E0,$ED26C6BA17913719,$CC559E425481F806,$A1E017B8EB485904,$090F3C0236958226,$024EED30051F1BD6,$524064455B4FE5CE,$104DE8406D13FAEC,$FBF830EFBAB3C04D
      Data.q $7818FD6CBAE1EBEC,$D42CB83D6C3C5FFB,$16526A43B6EA2B38,$679D96550219CD0C,$1017D10105F60C11,$023A0FBD73F8DD10,$6356042ACBA2CA91,$2282FB72EE2EBDA4,$876A920970688648,$85F791CF96B7B210
      Data.q $E082D4671B40CB8F,$496050656A483925,$796041A8CF0153E5,$D41060DF78823460,$28E01F00864885E9,$33C077664348CD0B,$D10D10088C8C8CA6,$2D0B1EDCE3147A8C,$731D3A74B5F2CFB3,$37B76ED1FFD7F5FD
      Data.q $73C95024253E6292,$C9DB8B214E2B5DF8,$48FFE9F8FADD3F75,$02C8331EE313F104,$8FB4C4F6D9DE1F67,$1C3D9C7E2AB75D12,$1191AEB0D4DEBBFC,$71C1DE5701D3247D,$D7C060FC382AE204,$DE53DF4163DC9338
      Data.q $2EF3ACEFFE13D6DF,$D8B0AE3394C263B8,$8FAB6A01B1A9A152,$0D959D90C53E9F42,$A07A30525134225A,$2D7012C555CEA416,$5D5E4B36A1A75E80,$04321F0C355E7410,$20A66D0F6A05B578,$8B8301C2864E6CDB
      Data.q $BE1FE5CDE73B9CA6,$EB82704D71C7017D,$DEA82A5356035F44,$800AEC28899E058A,$17699918B607AE50,$9A1E7E7809CB7B08,$643368D41CBA268F,$D338090040F88BD0,$3D67107DE1EB82CF,$275D2AC972CE2E7C
      Data.q $46C961D8A9568004,$CFFD032EEB79D51D,$B20DFE38E02C77AF,$1FA2DD9ABA8809FA,$ADAEEA24569F3C10,$DA20A6801AF5732E,$7744041FFA20A2A4,$5571A7BF5E239D57,$B76AE0260011CF82,$EC6A2AB1575E897F
      Data.q $A4AC0138045C2D12,$71C4ED3A3E3CBB71,$6E4D3E00B52B0F5C,$FFC7E0FB9F8B98D6,$782539A204A17CDC,$792F13C5DE701B4E,$8A6F68C1AF16CDF8,$C9130C1AEA159E03,$1BDB06266700472E,$ED301AA34105B025
      Data.q $898966C6EEFC47F6,$E0D07D31B04594EE,$67808071F9BF5769,$9D62C73C10EABB65,$43CBA7787F1D5899,$C7B2F938C92A8240,$F7D0F4A0B2FA6D17,$BE0E52EACA45DDCF,$2D4FB9D0659A431A,$6181678296301ECD
      Data.q $560E0047B0862BA0,$E4908A2807F79400,$8036E3B8026E55C9,$DC0EA8977ED9042D,$9F9527803BF49000,$2A7A42797BA88363,$F15273C04D100DE8,$E4999802FA677838,$6D1C10F3FD6F0299,$55C2A5550EB500AA
      Data.q $FA15BE3A0B57D5A0,$BD04F972634115A5,$8808B3E88096FF99,$B1D1B603DFBC723E,$9929755E0A3FFBBF,$A0E2F48D5A516724,$628144CC000AB0D3,$832560F08426DC26,$639D91D696B010E5,$C93361166A744DC9
      Data.q $B4404D41675C0778,$F59A0205AAF51586,$E786FC9A0F516CB6,$B322A7A012CF84B8,$5420349D88322CD9,$CA77DA56D6D6EA02,$EF379BCF542BC9FB,$4FD57AA357ABD5E1,$104BE2C8E3CF0209,$24CAF7711C2EB055
      Data.q $09765BE0EF9FA202,$174AA2025C7B9344,$A2026AFB64198262,$C26EFB2E7BD44EDF,$341B0D55F5B0265C,$C91AE546892696F7,$75E26EFB2DAD96B9,$18D73BAF7BBF1345,$E4BACEE729DA793F,$FAA19B9A5B9E6401
      Data.q $D3D20C3A541811E8,$2605E887899E29D2,$351A34A31A1A5134,$AB5404546AD49155,$AA814F2C9B2F30A1,$D8B2486EB0C00DB2,$E595D509C8F078A0,$C5DD83CD71FD6FB7,$19817A80E52BC738,$93D7E0767DCA01D8
      Data.q $3AFD7C081AD7F016,$9ED20ACC849FDAB4,$CA76D33C097B47BD,$028C5DB348CBC051,$DCB6A28C600A3344,$5D22EBC3AF2684EF,$5EE802EEAD78EB8D,$3F07748F1A564DD1,$6F74F202C76AB7BF,$313A03396674BDF8
      Data.q $1257D10424A2705D,$73AA00314B649D10,$3274125A90B0584C,$D593329F26C5D7D5,$607865270F5AD230,$E61DAD2C830ED5B0,$1E4035362866A4D2,$75D33423AAF9055B,$138F7E0838028728,$0F87A202042F6EDC
      Data.q $026883EEA63CB60A,$BCE653ACDCEAFDCA,$1307063456DEB1F0,$B2FC3D930D59555A,$0EF5C589FCBB4F6B,$8667814609EDD19D,$43E30B81D2466442,$040FE2B07696DA46,$5A1683A48CDB4216,$35569505926D8A32
      Data.q $1E0FA6319F47BCE4,$D96735A4BDA7972F,$292A82FBCCF25FC6,$AC9410DA1CF03DA5,$9E57C8347E791333,$77600BDDE4D06E13,$992C6E9BFCE63303,$86CB257DE4CBFF76,$A53FA7BCE36D544F,$BFF92D759DF2B3CC
      Data.q $479CEA2090CAE38F,$AB751E1B62635E01,$90C1295179E0214F,$F38590D601EB9DCA,$882131A208B76D44,$BE1D381B4E78004E,$59C35D4CF57AED3A,$809B98E15B3FE4B0,$25C68008A98BD267,$503CA9CDB8CC6902
      Data.q $07320D36560E52DF,$AE23D5860E6507A8,$68B40CCBD39C6F88,$4A8E052C8D958BA5,$43C83F83FD27E06C,$3EE9B713C7516680,$C816DD20F1D2CA4E,$3CE35C2A796A0D12,$2CF322C5011F661C,$7A2B378480C0C688
      Data.q $F4B46956686B502E,$2E27AE4087B9029E,$3B3441F227BA0645,$960832C0044C832B,$506CB393EF4474BD,$2AAD00ADB956FF28,$F024CBCF04090C92,$8E6FA20222C73F2C,$9C686E5CEDA193F3,$927E5A678055CC7B
      Data.q $EC33C448AFFB24DF,$4DE9FFEB2D7C595D,$E74236B177301315,$CCD04CED3A4BE95D,$6B80E577B9BD37FA,$F33D552DAB4E5ABB,$BAD1CCC8CF7F79E2,$8A4A0AA47A386EDD,$E155A80646664107,$487C5D1566562971
      Data.q $7480474B21C41B9D,$4CC81699F90F4992,$70E1C1A3FEDC854F,$27A3EA012B6059D2,$E3870EA5B1685B4C,$06A96667A4C6E2A3,$4350CB4D4DA91D0D,$08DB7A126D0618FC,$7AB81043AE00F58D,$201F0D0A3C27B81D
      Data.q $072A9FE00EFDC678,$0008D7A9A1A7B4DF,$04D4D4B1AC89CBA7,$BAF0A797B2EBC929,$72E0B66C8EB78CB4,$49A07477A7F34F75,$D1769A3A382341AD,$80405CECDFDFF2C2,$E6D6F60FD07C1BD8,$C4232E7E19976403
      Data.q $403F22CA6BC6B02E,$77A2C97D3B034D81,$5EB9DABE0F16B50E,$7815B9B1A2CEE3BE,$47B602DC7A87724D,$A95F0471C8A5DB85,$2F1673639FA6CDAE,$F379F672E312DC5E,$D2C1D161407535E6,$1F0BF17318CECAAF
      Data.q $3991CEAA26FF7C6E,$EFFBBC2EE3E5F664,$AFC2B6410A8C8DD5,$3A90A83B16518286,$A43078C23FF9429C,$2D33063460510FFC,$91F73A0FD6674CFF,$FBF254DE73FF3617,$1D86951956A6F163,$94FAD9273F81FD3C
      Data.q $AB6F45486DA9637A,$F4F343F6E9B4CCEF,$36570EE108250A71,$CBD4F86107B66AC0,$D1F2BFDB907C09E6,$9F73E0F574C6351B,$BA7DE567990B38FA,$323FD494F84A2EEE,$010F49D18EA35E4A,$99E8DBF0F00F9E28
      Data.q $00A9FD341E854908,$13F9DCA95C0166F3,$ECCFC29B04ADA1C0,$9B3C04D13078FA7F,$0D31CCC66F83CF4B,$4157EBA5858DF661,$88909E1F46800990,$4C0EA78B43C3D5AD,$836957F4117A5FE4,$2C5B6CC663CF87AB
      Data.q $1118178CBED71D54,$8800F5C2D7E20B34,$4D615038CA2031DE,$E15646AD9416DCAB,$81C3611035EA7100,$106173E52A2B0B04,$873751447928FB8A,$CFB0242F3CCD1114,$8547A8C82E85AF16,$56AD5A1219EDFDA8
      Data.q $F76298BA88C1B2AA,$038AC9977754E929,$D9545273CC4B476C,$FAD86880967EBE51,$274F5928EDD4E9F8,$AAE20E0C180B7FFB,$BFA059C4D723CC70,$BF3C02955A627B6E,$3906F088E00B0313,$6335FEC73A89E8EE
      Data.q $D05658E791C2D52F,$0A933CBEA8D38477,$95048F31A071A49A,$5CF8087A9D0C9B36,$041DFAD021CAF9C0,$7CC5DA06C5415BDD,$6F81DCF55F2D2F78,$B3A4BF7D278ABAC7,$D2A29CEA693B1D65,$47B56381800923C1
      Data.q $8073B372032D2321,$D6267D42E2661C89,$466DD368AE8EB486,$41AEBD8F5A39B870,$7A4A740143DFAF60,$FEAD7729D8E46E96,$1C0C3241BDF9FDE2,$59A79309D4E93C32,$6E180DFB0AD3296D,$B8F06B2C30E52734
      Data.q $65E5B5D53563BEDD,$CF6AB03C1C5476FB,$C6343534B75F2D8E,$B012767242E65892,$810B5DDF6F230054,$3DE7D13586871F73,$217B9E54742FF50C,$7FEAC8BB083741ED,$EEC8EC763B3CF3BA,$BBA003854A27DF93
      Data.q $3DB1DF6D3FD81CEA,$9A1CFB22D00184FB,$0B5DDBE0FA74E8CD,$C708D59A46F0A0B8,$694EF0F477503CEA,$8AB37CDE07613DD0,$07BC63BB95DFED32,$D6721806AD1829D2,$46221D9DD0059D59,$BA9D69AD920E782D
      Data.q $F1DE8F3EE1F51762,$51E371D8C3EF87D1,$DB347F8258D6E515,$67A359D9341A208A,$393DAFB5DEC1FF3F,$5189B6A9FDFFF67E,$A01130632B253323,$2B0A81C695966257,$DEA1B39F03E02E59,$951E02E052B87CD3
      Data.q $4975F20AD8346746,$C740343E9D6AE969,$60743F9ADC7896C3,$EBE3747F7ECBC8F6,$31DCE4B2A99C430F,$8BE3DABCCD464AE3,$866AD59E0C219E03,$286CE9D38F5E6772,$A546195BBBF0143B,$3EDCD68DB33399D2
      Data.q $422DC9460981AD1A,$522CBC3414127214,$E72B8CE9383838B4,$2731BCB68D8D5D7B,$303706DF1D8C9567,$D7EB600473FD775D,$E3AC7E700D9C5F00,$225AC03DFBD013D7,$903D3169BA03FEB1,$8D44CCBC00F7418C
      Data.q $FDF62C9881932F25,$B7D97A20C920CC37,$8832EE4E93E9851B,$18CCCF47F30BE94E,$82B3DFBE0FD2DDE2,$DA3781E89A006F08,$681719FAD8314150,$759CB26815A40D39,$00571F77BD91DF81,$CB40C89C3C6CDE8D
      Data.q $F65E04ED553C17EA,$A37862155B6201B2,$CC4AED3CA277CD91,$05924464919C506E,$05875C8A9504646D,$D93CD1013200455E,$15E67D94761349C9,$8BF72FF73A13E399,$32C431B1B1AC9AE8,$0CA0636B1A3E55A3
      Data.q $32CEFAA34B4B4EDC,$131A35C1A373C690,$184D8CB0D1468D1A,$71F4567982B573DF,$C6C48C004689928C,$BF4E273CAF5FB234,$5AFE30099BE490BF,$0A28D076B4E04CA4,$BFCBA005BAEA08DB,$618D7B6DC352399F
      Data.q $D241218919887D79,$606DDE73042EA877,$EFA2292A8C0998CE,$7EF73004478A8436,$488FE6FE0D3E57B0,$B3EBA1A677460A5D,$65235FDB0217A08C,$951D2DD2EC6FDBD8,$B19CA613B3D3A755,$872E396AA16494D0
      Data.q $77419A1B1E8EC613,$7F544F563A63C2F9,$E57309849E0AB357,$86BD6F00504FCECA,$E9CC3234598B1485,$603D79F02AA6F603,$6CE7E1C0D1432732,$19BCDADED4B2B75E,$A6A7C9D278506412,$349F871FF673339E
      Data.q $01BD34CCF4D4BAE6,$2B8C59B674317B3D,$46C30581A2C28411,$EADAF9A5B5A53B8F,$CFF37ED61BAD55A3,$FEB1B9B9FF97ABF5,$EE54A681E48E1288,$00C68F77E0418FD7,$81B5892033499DCF,$4007749F08230AEA
      Data.q $AAE1D56A73319CCF,$0860D59282D64ABF,$5E51AF039D4B7744,$FFD9CF1739D7FE56,$7AE7414BBBFCFFEF,$7DB3B9E661B34007,$78090417BBB5D2C9,$EC2A764FB9E0274E,$9CB15DAC360073DA,$D6C98F406B77721C
      Data.q $60DC3DF3A2B67A75,$920986B628355C3D,$A9CC2749EA178637,$A92F1962266C5F3A,$403475D05D962B48,$67319B12A0E12224,$FEE4D13144CC1824,$1BA7C1F8BF8F4404,$956124FC8DA362EC,$51D81B2F4AE7F90D
      Data.q $F7FB6CD4B58F5B79,$9536F43FCB658D87,$F5AA6BDCAF8092ED,$9198CFFD29C5BEB6,$4CFCB4A6E5EE6A37,$55E4D0FA110CAA3E,$2D76C777FEBC4D14,$688FB47F67DC9B7D,$27FC5AAE13B35586,$A903816262A5507F
      Data.q $1CF4E03E3CA9C483,$BE9F1DAAF3F4B8DC,$5DDD1913F9DBAEEF,$B23298D6A8848E10,$E9751C2CCEA6FD6D,$EC8802FEE2CCD6E5,$C0D2831323D5B454,$C2C66538793B340B,$ABB13354C4977685,$A627801DF0531776
      Data.q $390C6D4D46459C02,$EAF216E978035E08,$00B5A155DEBC02B7,$1800360644E3D060,$1F7B87E00037FB95,$55E88078E8C6E812,$18C8752C43696FDF,$7BF45D9EA7D463CE,$0608DDAA1C3D36C7,$5794279E4AF86A33
      Data.q $C559DF49084C6213,$5190D562A9F8E8A8,$DB13CCA5D87EBFA0,$9013400DC7AD0897,$86E0A01A10F9F82A,$C8433EC911C2AA03,$1F91CFA319685D7D,$33C22681C9350317,$2559F65382A84C47,$3655089214AC25F6
      Data.q $F9655DD802740022,$D07A9FBFDFEF0810,$B332D0BAA2CACAC8,$9BA8645E526FFB4C,$149494EFD8699B9B,$BB0081D0F2C60FDA,$20C582C617777DB3,$C62E320EA7B5F51A,$81235C9377331C3E,$2B1C60154AD76431
      Data.q $B74DD019F4CEF4D9,$5BFC624DCEEB6581,$4CEF46D8DE1961DF,$520F3A9B549F8EB1,$BE398E4AA1EF488A,$4812C6D40646FB84,$6B40974D3C057D2D,$E74EDA9BE1806FD9,$6B5C0633862AEB48,$53A509C8CDFBDADE
      Data.q $91B0D06209EBB4B6,$A151C28FFA0AF343,$7AA5F416FA1EA1B1,$3814632C7129F8CB,$0A029469E7F9FA9D,$21318749716A35A6,$A0DA8A5B4C325C2C,$1FBF5E08D92D8153,$D027F2B6A04B7332,$2FF6D54B6C900DE9
      Data.q $84EEDF8FCB673A1D,$725CCCA01342EA1E,$CF25D17F9F1735F9,$EA5AD5A86417E6E5,$89649C16B6B6A641,$9B62820782C8566A,$D390F568D5DD4964,$1C6FD3F3F4E5BFA7,$F7FB3E2BE5D46430,$20111AF8FCB6BB3D
      Data.q $73AD94B01250DDA9,$8DD6DDFC0CA2BF00,$2BEB2B4833BA0C1F,$6B3F4EDFD5D69F00,$58B16C5EA55ABA7A,$9A544E42861A92F4,$85EB68E778ED3317,$F16E41726BC4CF03,$BF2FF3F4339F67B9,$521118EF7BB1B4E8
      Data.q $F26771DE82764D29,$9E08BC820B3DBAD9,$86ED3FF585CFF507,$FEF17CDF1DBAC6E6,$EDF066277FC3102E,$F35DE309EC7A8F25,$8C8DBCA643D149E7,$317586D612837555,$A3EEA2541873C1A2,$FE8FF7DDE9B95837
      Data.q $1041F36F38DFDAF4,$B9B7B992D102B5A7,$6D8F1B2BD37AAEA2,$A3BDBF29DE42FC5F,$9A9D1A0AD705F8DF,$AC96E9C9B5A1F389,$03EAF0D91C16B321,$997198DE52549DD1,$1D47627C7A2783F9,$CF6AA061A7402E6B
      Data.q $7EC3F3F8AF76EFCA,$FE0EEA87237411FB,$3B75F5755C0572E8,$D39783EBBF53DBDE,$6F9BC4F14D745F07,$DBA5D4225AA72633,$AB62723FBF0A65FA,$30EE157BAF993DAB,$1C4B7D3C012F8FC0,$BA1E01DB81C71356
      Data.q $730A8C175D6F6015,$201D2CB0053DFA00,$E843CF3EA09FB94B,$91675689FF6008F9,$C5E09B27252F6E65,$3ECC22CDBA429FC5,$736CAAB85F67527B,$D6B2D47BB7FB1BDD,$799563FF4F93F8D9,$D99C8999C21B6A59
      Data.q $E2AD942D4192FAA0,$1252AC32986950DF,$349C0FDBCEC2A45E,$2929835CCFB72D34,$6C3737B040159BBF,$D89F6BD9F8723FAF,$08BDE3534007681D,$67BF850598754D00,$2033B0298E682621,$2A122C5045E63886
      Data.q $632C64DAB325F68A,$0E27094830668991,$4260FF25E70A546D,$D878DA0C2601094F,$F6FB7DCB051B6DB6,$EB230411D71A00A5,$C043A1912275198C,$AAAAABBBBA32EC8C,$98CF04AD2322E7A2,$B488939E3319E665
      Data.q $E57BB88ED7D3F1F5,$001D0C3DC897E44C,$C0F84E2DFF781473,$EFC3D30611B7E4F7,$400BC90C79A0815A,$2F9E0890A8EAB154,$7653BA4FB4C4F6DF,$B830D32D2EF3B7DE,$2B759F559F8AAABD,$0E99A30D4BDEFAD8
      Data.q $681A653EB8F2B5AA,$8607CEBB0D0A7C86,$30CF2A3424DB8C6B,$23DA0735013BE680,$589837AF9F15FA00,$16FA1DA6C04DDB97,$18E2546B33E90DF6,$2367290A9A18848F,$A408EEF17EBC19F1,$554938CD6262D391
      Data.q $8D98B05AF51B8F1E,$E07A23B1C0651EA4,$345050CC9A359008,$8009E89FA0020CF0,$1DE176FD52C8CF4E,$5B561DFA7D3A4D8F,$15B57502DADAD32A,$8E429C9E9010D2A0,$49AB3E8B506525F7,$0CD2D2D0FCF9F03B
      Data.q $B506ACA044D57575,$2F339605B9E90756,$6B31ECF494F9E2BC,$FD3A0B8E26E4FEBF,$5B7F8206A911D020,$6AC0EBC4356EF602,$B2ED655213F500C8,$CDCFCC1F62110AAA,$96362161CFFF40CF,$BC0E7563BD72870A
      Data.q $E64A5B1485E3D78E,$FE3743920F838AC1,$074CD00213340CCC,$E79D52F61F8BF2E8,$B87CF01306118B74,$B5A6C257940E0EBA,$377A13B3C091DF2B,$94E5194E8F89C3D8,$2AA94C0462270090,$3B25117BA2EA6787
      Data.q $7AC3AAB9446BAB23,$9DC5FBDC6EA96DE3,$D4E2017E37AB3977,$78683850771DAFA4,$3FC9EEFE1F0F35C8,$5FF67230FDB66BDA,$20447317499D065F,$364765DE653C2957,$AF294F8DF934FEBE,$B601FDEB99F0BC8E
      Data.q $BE3B00CF0216A32D,$44FE8BB58A8DE57D,$3A44EDBC76647506,$4804B5B2E4476AA4,$B392B2DD7872D53F,$1191E8DFB3257F1E,$1F13130C582A21ED,$7DCD0B36E99F38C7,$D007B300D9F40044,$0BC10121536D2AF8
      Data.q $D9C01CF7A8219E01,$038FA57341120EBA,$EDEF88846513927C,$13872F4404258059,$1928EC18364B054C,$E6747CEBADA83AF5,$EEFB95279420626D,$86A4135AB9A2F77F,$BC7DA45ACE18D019,$DEDB3BE0FAD68047
      Data.q $106BBB5EC7CB5615,$CCEE363F67F3C9FB,$7A0F8ABC2D5A7749,$9F1DBC009464A828,$96C0BEBA5CCAD495,$143F095A0C7586C0,$1CA32D000AF31DB7,$CCB00A30D8385592,$0C42296E13360028,$6C6C546868BD17C6
      Data.q $11A57E42AFD29417,$9166812C0B12F344,$743D8E819E40A67D,$C763BBE0E33CCBB6,$9051B366C54C1A0E,$06CA012326CCFB8C,$EE91AFBFD4559E0A,$2E28233C145D3877,$87C3E1DE2CA42C2C,$3D1078C220A0A0A1
      Data.q $B144DCF03CDEC91D,$5C9A208D7F0804D0,$BFBB0A344C3B696F,$989F375B89EEE721,$C04F7F7C43106D86,$78DB1077F96463F4,$DD5FE6FC9F3CF03C,$370D09522F4F9F63,$4DA1EFDB4CB6D047,$8EC685F77EB60399
      Data.q $16B020E36A434AAE,$C5EF92667BCD0DBF,$D9652116093719C5,$2CECA74AB790CDFB,$311325FEC2B9778B,$D024E649B53236F4,$31C09075BB21B4EB,$E902348C88D5839D,$69818CC4A99E1F20,$7828374196482331
      Data.q $D99CE38ACAB33A4F,$4C96490F4E7523A8,$3A8021FD48EB7BF0,$7AF74860DEA0772B,$053E8E350DD02D3C,$5353D3737F2B98FD,$CA8268DEA16F3ACF,$FF7FA0A8CDA415C3,$E6D159A8D4085421,$B6900E2854716C40
      Data.q $D816665643364B6E,$EDC09FA7F1F84E1D,$69CA730A6B6487A8,$65DBFEACB0C95F67,$83A596F799BD5D1F,$2753BBAB021AB9BA,$4645EA099B1B026E,$5DE5702764546860,$8DA46C9389A4FDF9,$25401A19BB76E15D
      Data.q $3AB6E87E3233B42C,$9470D06E8189D907,$DEED3E4CA62BFFB4,$5ECB8454EEACD66F,$F6D8A8703D93CE31,$3A405DEC36AFD9D9,$203E1846AC3237C9,$3B61BB584EEC5A0F,$FFFBF9FA581C5654,$3FCA240F28012F58
      Data.q $A9A9A8F5E8637FE2,$54382E2D0D2A8678,$D424B6D70F911CD3,$2442302AD7A3A6F0,$999C60A0B2A36E78,$1DD1FB153B1A3648,$9E025CD977BDB707,$E33B9BBE86F0403F,$B2E6EEC92C81154B,$B3570FFF796C96AF
      Data.q $49CDB6C56F40379C,$411093ECE6B9F9E9,$ECA48CA6345FF485,$E018E59D53E7F1A2,$BDAF77C76061AB59,$091E910FB3DDF159,$9A5C26133BBB6FC3,$7E765B55EDFAF266,$34FD3E5B15D9ED74,$48EBC2838242EDF4
      Data.q $40F65B9CD2B71984,$003A164DD248F0A2,$CCEDFD1BCF4648D0,$1AA20FE938024CEA,$F91803F56BBDAD87,$0AF8C031BE9AC002,$99E867FCE4136632,$D41C8EC69ACFE251,$84C68741BDF86BE3,$4934B1825ACC4C75
      Data.q $FB4F4FB1598D6DE1,$05B9E9333C02AF79,$B3649EF4309E8F8F,$3A01D51B6F67808F,$927FA1056F61F214,$18C789D0DD4F1F51,$65DB53F4B4B60EDE,$08117AF64385510E,$0F038FB70D724B8A,$17C190F0799CBF66
      Data.q $1A4BC1E0D67A97B3,$10E77A21CCF24F90,$564A148C4E3EB9E8,$975C5CF88033C021,$82C78CD011F64732,$E7D828D019207324,$61B0DCDFB4D03004,$A162C58266666403,$D3D2320060C183C6,$F481A783214B6AC0
      Data.q $0746B502E7546A43,$12724B6D0299A306,$18303D551A4625B8,$8F86A67199688206,$4109512CE51952D2,$6D166DD884CC5934,$F180E3678346A653,$469F24E1B8F1431A,$A31A60155B24A9F2,$1E64B183F2479DF6
      Data.q $DDECF7EDD7BF3C09,$309DDA92E58A9B75,$C000D3D14A4014D3,$1E3ADE932B3C1974,$128C1BADB75769B4,$78C2D3425593048F,$99E929D45B2730D7,$2D9A740119375103,$9949FCE156186295,$551E84CC301B1C11
      Data.q $0A68BB86CD704432,$C2C204F69444DDAE,$5AF473A4AA1C3CAB,$43A5B16E8088980D,$5D06742E6717EFC0,$85D97177407535B2,$0BE9F4E930DFE773,$56083F2A1C3D3A35,$D2321C3A1B0C3A4B,$D4353DC8EBB0146C
      Data.q $FB80CB0F56E89EA5,$4CC824E67913166D,$94C60A9F4793814F,$A3D9BAA26A696822,$DD265388C9719C27,$C86780362B3815FB,$484EE2AEEBB7B012,$AF4B7423920F381D,$00CD5F680FA18B02,$6D7E06684519ECB5
      Data.q $FF01226040ADC697,$E51D001029D3A766,$7782E8075A88436D,$8216D135E9E3640E,$D634EAF727E4C3DC,$C99DBB40C7DC35ED,$E08BB29017FB4DCA,$F97C2756E78098B9,$B3C77AB6AC700FCD,$65E705391171FC8F
      Data.q $AAC3FF93BA91205A,$28138295E4D7A816,$286BAB44352109F3,$6AA5A8A0C919A194,$C07E66FF1FDDDEF3,$0486CEF77E23F359,$DFDFA2027EAC028F,$E1172760BFF9F2B7,$C640D2A533764ED6,$762340688267C980
      Data.q $6B66F4182723D9A0,$F81E8FA7AD1F6A2C,$77AFD08B77C57D76,$138B9547497D676D,$515CF715F2BADE82,$1057D7612583E9B1,$53BEBB62618EDEE9,$58032FE3500995B2,$0BAE7FE388250AF5,$A99C41C48C99CE00
      Data.q $719A4F3EC72D025E,$B400D5223266E8AA,$765FAB7887759792,$B20C818D7634E9D2,$3AE8ECAE8BD64546,$7E96954B8836A639,$21B07BBF5FA00A58,$711C4F276FF0BF23,$55A4452651758687,$100AF2D6CA6A9D44
      Data.q $3980E510BC61532D,$CFB76CCC5244D41C,$822CD338100541A7,$CD02404B535C8668,$1586B34055680104,$E334DB86E31235B7,$3B20D8292E966A39,$748DD7166207E40D,$C260D4EB24964D5D,$DB4DB8B5E8D357AC
      Data.q $7740C4212E78AF2A,$67642773B9DA17BB,$2518CF043F635367,$C46306F41F3F3F2E,$5A874AA064AB2538,$B9797906D58B01AD,$9E9E9D1B29B8F1E0,$27AF40C18366594E,$D1005EF583474FEB,$9256FFB2678347EF
      Data.q $F2467F11FED0CD63,$E7F440475CF31237,$CE3240B440938F24,$027B6FBBF5103C44,$EE05532F38FE0F9E,$9197198C5CA23A4B,$E2D8F244718E6F0A,$FDA8E0A5B1E706AF,$E4B01976B2EE0200,$9D327F6EFBC81BDC
      Data.q $11995D362AF39C15,$0D39837A4DEA8DBB,$A6044C94A0A3C943,$844B0DD4ACA9CF08,$8203B6330186CB20,$02954A59C6982941,$B8064BF690327348,$AEA40D18244A3B0A,$29952D71A85B2527,$0774FA5358B29D48
      Data.q $A9C4C06D3C9F8D97,$43A1E55F42853D67,$090B0BFD085B9F90,$F6EE15C6E14B5668,$6980964EC9146514,$0ACB27D08C935835,$B41073358007FD45,$9EA763D55F5334B6,$A18B49BCEC94C7FB,$976903DC32BDA6B5
      Data.q $799454052DBCA012,$05DA42F7B5920CB8,$F2D5EC02D1BF4043,$637042D7F7E00E79,$5CB859AA29650117,$123207D2192C862E,$8302EB43CF551608,$CA65590FAF5E0AF6,$4113F197AF75D356,$9A3439EF51A96445
      Data.q $896DAA26B9340C8A,$A2BD4A9D02F6A6D7,$8B164F88D7EA21C2,$991E02DF69B15D01,$FA85CE2D0CF92267,$636373C04E7C0766,$091FBB1E8B1BF943,$011B7BB82E831055,$D15EDA88226B92CA,$73400F1389768E85
      Data.q $31728ED32398049C,$9377A0325A6E4576,$853A83A519C9A5DE,$D1B0DA6652B61524,$D3F7B23FED8EB80C,$C280D09A7A0FAE5B,$B55970085E0893D9,$CFAF9D6721ECC9EE,$8AD86C822E4C3619,$5F294EE345196C7A
      Data.q $194EBA81949EB4FD,$E8A31C83939DFA70,$3B3DB9CF1AD099BE,$77755C083F723D97,$AD6BF7268D92B3C0,$6AD19D6A8DF0FD58,$E36172B2367E9E2D,$674FF923071AB0B2,$31178D430E4CF255,$713F75DDF84C54AB
      Data.q $A369C02C747806FF,$FB8FE5013AC74600,$310ACC098C8FFE00,$FC3D218666ECB7DC,$50C1896E60C84790,$64EDC003FA68061F,$26D3C24BFE16F8DC,$A29CA4D27C792D32,$6EBF0E9D5AB4F3C1,$447ADBEA720FCB12
      Data.q $B6BD4E6FE4E7ED90,$B03C67B1BBFCEF91,$4C271391C115C966,$38A73860C94C2FCA,$FE9098316E89C4EB,$B32202AC9C4DC2B1,$61F7E92332E7D4D0,$96FDAF341421E1BD,$F822A081174F50C5,$7108ED2DC30A1089
      Data.q $61CABF0A1B6F21DD,$1A4940D1040C7457,$8C7AA368168819B9,$E4677A3A810EF790,$286274B1222BC417,$F1389C4E364E4E48,$DAC40451BCBCBC9C,$56A32D7B5ED73AF0,$6ED7808A60E2C7AB,$028F37272E1653B7
      Data.q $AD5AB41EB2BB0462,$369022EB874F708E,$44C1076583E97D53,$305DAED7675E32C0,$11850BC790F8FC7E,$735DB73198CC6AA1,$56AC04EB939735CD,$515A7E974BA5A1EB,$6D5109D181207151,$3DD7FBDD0778F6E3
      Data.q $7326DD0EAA32C041,$9FFB274C6CAA20BE,$43E3D6073C3BCB21,$A225679248F24A3E,$B3E30D4CE37B9C50,$45E6BF3E9141DFB6,$368CF521824698D0,$7CA8E073C8FD8923,$D48385F5D1518094,$27FFEB6035C67D07
      Data.q $7D8C6BB31ADB6EF2,$5D97103B99259209,$02FEFCE82D9F1960,$E1AFD3765B4AFAB2,$EA43C1F9F5E0DE78,$5FB445E3A7AF5188,$C119E18AF2B636E7,$003D7895B38B5EB5,$9B3384C0F554505F,$0B8C2BC1DAA8AF01
      Data.q $23B5086F41B43FD1,$D001DDAC687CCE96,$4CF49489EB379D67,$0952DAA40D6D6D63,$44B06D67688BCE80,$85D57F417C716D9B,$AF01C2FBFF523639,$D1CCCD487AEEBC03,$7E2C9F63CE729D8E,$0449B5DA831074E5
      Data.q $47289BCD01CBCF28,$99A640BF86FA8267,$17C4DB602629CB80,$D3BD83EFCFEE07A8,$D7D5312F8B9CE8C4,$080C2210E7A367D7,$C04FD2F1F0F50D75,$930DB0162821F3EB,$0A3454E20C170C63,$E0A267E446EEA204
      Data.q $C8669B62B3804319,$BEDA430D1AB416BB,$06A39E7A408C7350,$2EB385E07E837A85,$6BCAFD569A9693EA,$4E8D96803F8F072F,$4BDC7FCB4CAD3024,$1A0F24B9E6506DBD,$A1A1B9E024AF3C11,$6568EDB81F27C5FC
      Data.q $89BF53A2C49121F9,$DBB9BD75D38C9DD5,$EE2DD1C672AFD70B,$E6A9D5F595877F5C,$5AA39AC212391EB8,$B5F152163CBB1720,$84D7A76640E578ED,$A85D25C871DFC910,$61A5C2260E7FB2DC,$DCE8D5D641936618
      Data.q $B7EBBA0A6E1FF9FB,$1DF9C3CA873C14F5,$5FF39181EDFE57FB,$686B0940392BC8FD,$B2635662BF5DEEA2,$1BCB4A73D51701F0,$D4737CDA14102A3A,$FB7E25DDEEBDDB19,$43584024F4183451,$2505FEE2B652DD10
      Data.q $EE44321B60159CA6,$0CBA7AD634249550,$4D65E00A7EB76108,$FD68B724AC58F4D2,$24935802DE6FC013,$BBAED748936F5AFA,$047F16D20E8FE009,$D792803C819EFF40,$3B889B58A227BE01,$05A89E0087DE002D
      Data.q $7A545FF523441778,$C178BE4F1686FFE3,$21061A3D3CE2BCF2,$6AB41A15A1B7DB08,$6E8BAFBADA05B822,$20BBCD2D0FEAA4E7,$8FBB56F3B6853537,$20334D5BB27A9FF4,$E111D6B064756078,$5C4B2181CE0E80CA
      Data.q $0455675C5A8C7DC7,$E393D0906475A800,$734BC821E9BC385A,$B9071BEA80B54A75,$18AA88D3C8B37E90,$D0651E8ED10C8A8A,$F00BEFD91D6CCACC,$3B8688FB1B2E20D2,$E2BBA7D232AEE48C,$1925768E92F94445
      Data.q $DBF6FD2030180D2F,$D69CAE2B8AE77F6F,$CF86B3228700C2E0,$AF46299465AADDF1,$7A241A0D07A40803,$FBA39C0CB3409020,$3EF246C83286FC74,$8B285B9B9A152D35,$4AA8FB7DBEF40C8D,$5C9A40A66340EA08
      Data.q $C8CD4CCFE60BACF4,$9300BD56003FAF01,$3BFF7FEFFDBE4F27,$BB88F15E96EE68FA,$41426071AA87B271,$002250E7987137FE,$8D28A811960276F9,$AEC7274E9D895986,$28302B5DF87A2642,$B6449E9B61CACE0B
      Data.q $C1649DB96EFEC84B,$A19A158CF533A337,$2C01FCE5F05CDF65,$DA5FA5AB7793B705,$BA2FDD557005E47E,$EEA9752147050B88,$ECED3182A758F055,$AB820F9F5AA48398,$B1F9FF0599F1DDAC,$A7EFCF8C5E013400
      Data.q $04ACCB0A8970569E,$5026785A43B6998A,$446B4AC482CA6A88,$E48842CC405F0EB5,$14EA8B56A1CEF48A,$1F4562D67A1E6AB2,$7D3E9D2647A25D88,$3EBD7BE791D0E948,$B451F0F2709D3B70,$753A85F1C788222D
      Data.q $14287E94429E4950,$C59A5DFC55E596E5,$D820C0FE072F6E08,$57E82A0CE8357DB3,$AF4F7D3E9C94F432,$C091189A2CF8ACAE,$D4032320A6F88633,$76CBF03B56578BBF,$E9BE6FC778ADF781,$DCDA411C10204CF7
      Data.q $8232F79347840224,$0280C3870E7ECDB4,$435D62DA4B6B7539,$CB88C127C42B8483,$1615308AE10D96AC,$C71009288C979D7F,$5DF23EE84BDE8B36,$A6112578505BECAE,$BE2338F5CD775E8E,$D17E7B9F4FEA8082
      Data.q $BE298469A002E3D1,$733C04F7F9FBB32D,$4DF50794521E7822,$9E0206E7808CF876,$16AE7832FDE4FEFF,$2D538C1C305EE2C7,$718D93BEE068E627,$2137F93401274930,$5909E5D3AA40F7A7,$B1CD3D66D004C7B4
      Data.q $98BBD89893E3F5D8,$469E414D52A161B0,$CA9B7BAF4BFDF43A,$679B9E967814487E,$752ED95D7732D558,$5D5D2DA090E0E946,$6F7CCCE6B519306D,$D68D666B5661F973,$BCE41CFB062162FC,$AD3D9743DF9B23BE
      Data.q $AFAE8802EE79D19D,$FF5EB3258597FB5C,$013BA9085969C3CA,$F3B2B3C128C78328,$4ADDD00959F412E6,$C7AF1F3F245DF440,$DDFFC003FE48074E,$E0007C69CE495007,$0107EAFB19E058F5,$E02E38017A27DB9E
      Data.q $359D4D9D1A4F23B9,$C611D64C1928EC2A,$9290AD3DAEFD4C94,$D41D9EDC901D1A76,$0E82795968021D35,$027C07E5E975CAA2,$7404296821738D04,$A36CF423A951A53D,$7963E89501E20CD5,$AE412F5DEA86EE23
      Data.q $51A0750B7243AAB5,$4E816A31F5D94385,$23901642B3F02B55,$49E024668012B27F,$2441F2AB0AA30840,$ECAD3B309E7E1CFB,$D9048B11113AF173,$DA6D3698B83E2848,$AB7B99C370DC3703,$E0D8FA030E0A0C1C
      Data.q $86AEDFB5833FCFCB,$9F64410353872391,$B38114EF42D3D3D3,$3A4C42EC2E94BEFC,$6D5AB75C59E04ACB,$D0BA837F4AD2D2D0,$F21B9B9B90757575,$7BC1F0F09EAA2CFD,$F9390A5FE76980FF,$C46B387ABEDD60FD
      Data.q $2199E6B9AE6BCCA0,$C1E773B9DA6C8643,$53CB6B93371BF46E,$440A3060CF6EFF88,$A2FBD07E328043DF,$88BE350C4194610E,$BCB0233404A3E580,$6AEFAFB008BF7A55,$CEF0CCCAB96F0F19,$23C236EBC4562093
      Data.q $C0424F35BC1E4FBE,$B1DF82CFC56C11B1,$CF17C0530F959C1D,$49699D6C4200A481,$B49DCA22A46E29AD,$C22B7C8C1632C28E,$927C0482AACB0403,$650BAE8AF8E1D7E4,$451B111CFB250D75,$6E328E8BD2929B10
      Data.q $930AA159C8160E22,$8F2FDA5667822FDB,$12C959752A5FD445,$02F1E882EAA1ADD0,$32FA31190C8F48BA,$FA0C77575D493183,$97B02A2A5D15F417,$5499629A044F76EC,$316AAA02B8D638AA,$B487ED1011364B60
      Data.q $C7618996347022AC,$6572F400479C8D07,$E78255CDA4377EFF,$60428FDBCF0112F6,$D6FC758FA86467FE,$F6EFDDB970C87F85,$D458DAB36A98282D,$8381CD428576C6D3,$DD0043EBE173E807,$3AD6EC628714D8D4
      Data.q $B6832C0BAC5CE083,$F36AD3A0A5A5A50E,$EAA2E31523CFDB48,$97FAF6BBAE67DADA,$CFF2797F1DDB366C,$BD31D78740C0E381,$245F905C79CBE4B8,$042AF9FCF043AABB,$91DB703F3C04F5CF,$F05647C2233C14C3
      Data.q $AAC8AF0EC58CF9B8,$F09889C2314FFB82,$55434AC1C549AAC3,$9E195C566D13B810,$80291F4F4734C15A,$5F46739279AC0CB3,$FD7713F9BD59DF3B,$E8FFBC0BF94EC4AE,$31F7B8CC97160FE6,$D186952ABCB2305F
      Data.q $B559668008723398,$923E05535835A8DE,$06C36877517AC41A,$C6A3EBA240FAA3BF,$0113E7749C2B659C,$94BCA2EBF486C746,$727EA75345698044,$E9793CFCFA512659,$7100D9C864407DAF,$F804DED200F316F5
      Data.q $01BF729BD271DE20,$1A38E117A8BC9078,$3029B026F80A260D,$C644C308087EB5B5,$13D0A254F9C9DA58,$01370176AA4B1D4F,$D814F468D06496E1,$69C6A7AFA089CB21,$55ECEE36792AF608,$81F860C20341B364
      Data.q $C045126622105028,$31281C8A56678129,$8D951B7C0A72A1D0,$7D4DA60698347AD0,$A73A438EF7862267,$5727C9F27FA6A6A6,$9816E1F7661A3468,$ED6078B43401527C,$7330B5BAED601FFA,$AA8715DDB0A1B9C6
      Data.q $1823268C12A2BCA0,$B88703D19EFA460D,$DCB94410EBAEA06E,$BB6E25C6EF996A1E,$E60E11BE4ADB74DC,$AF5602BCB071F6A8,$F4F4412FF52108DD,$1A3FE8C856CB65B1,$3A8E070105064304,$CB929292ECE78080
      Data.q $93FB9966C5B60300,$4040E85A36D085C5,$00558BAD7A70D295,$7EF4647068D19D75,$AB091B2026DFAE02,$A8023AEB281C20B7,$06126C1887F85F51,$3DAF0126EB19DADA,$E3197531995C119F,$DD4356B96C2A1840
      Data.q $98B962AB37695396,$D39486029E6557F5,$2AF9C5680C678262,$3B9C530CE265B7C2,$F084414AA3B3E833,$CDCD2DADDC040811,$96E6E722166A4B66,$655589E8C0A30896,$65A94666BA26005C,$FB4410A13E855CA1
      Data.q $3E83051652D1E103,$F43497525AE3690F,$41C6574D6B7B4E17,$46CEFD05799A010B,$7E5E7E61C224E09C,$967812F1A7C8DCA8,$191C56431C21EFDD,$A0885BC96AD2040F,$10A42CD6DF449BE8,$7BB54D0F9D9D9D10
      Data.q $D3C0F161433260C1,$04286D224AAD7ED6,$BCF049DD9EC0CDA0,$8696865FF37C0CAC,$3ACEF7AE5CB8E778,$D8845D3AF4D3CCF3,$D5A0B4AC84D4D8D5,$1F427FA4702C2FD2,$AE87ACEEA5C431EE,$D18302F7268B3B29
      Data.q $53EDCE86A4A6A4C0,$B7CB7CDCD4D747D0,$00BBD5DFB3E2D76B,$CEC7EEE9BE818A3A,$140D92D8F7746B55,$92558BE03B34373C,$07DE8DB52153C6DA,$174EEC385E45FFCF,$D389D7A454A94C95,$9AA6A6AB9FF8EA8D
      Data.q $50F4EBD2544A5046,$85D21BD7EDD85850,$50C79C5874649466,$FE94F49A0FBD68D9,$377FCFC1FEFCBFE7,$6642712A4D5F1C87,$2D2F16A43631901E,$42B3AC95947CEEE5,$54C63560D7A466BA,$99C0327AF5A9BFDA
      Data.q $5221AC0A905D0964,$C15400AD5F5D91F8,$979C97498CFB104B,$8329309F73FE725D,$0C7B70C190DB6347,$40684D84CDED1334,$E3210EB7BD411F20,$C64C7F5749402977,$73C090FF00CFEE05,$146637EAD2C2FC23
      Data.q $96CD6B52AF4B3258,$E006CEF007A325BE,$5548513011C1DB83,$0AA219E54A42D2A8,$907F75CACD05B407,$8273E7506DBA8BB4,$34E343C8468B293E,$7348CA062AD17804,$7B6161A539E7599D,$396E650470BD1A00
      Data.q $28AEC2E7EBD9F7E4,$640C6D842FA7A141,$1E0B12824A0A2523,$E0111C6A9101B2A1,$21141E6BD52FDA59,$617D2B71D7EAC3B4,$20A4D2D2D2F8E161,$2E8D350837974E79,$3F1866F2BECCDE4A,$6E5D218C58B06CE5
      Data.q $351AB4FC6511766B,$8D00FE91D02A2E01,$554332BA0143D0AD,$664809E8D181540D,$C0836BC002A9C0F4,$6D90C002982003EB,$211BD68CFA21DFBF,$81C3101E8894FFA9,$20808B3A1CF43E5C,$30300AB7D43BBD1E
      Data.q $1E3B3D0E874308CF,$9A3B142463E92680,$0089D3B028D1048C,$5CFA068C65008E64,$5AA2039DB7D421D4,$B3AC8514E1A9AA03,$9B74CA232AC2133A,$196D71EC83153138,$52A30098E3BB63A0,$7306CD9E6702637A
      Data.q $39D492B9CA4842DE,$70216B991A464C7D,$BBF1249C61CD43A4,$15C7AF68034715B6,$30AF333FB3563FA8,$5428D7548EF90D0B,$E262668776DB6291,$E076BD1515D1E5B0,$ECC0113941130EC4,$73C1CAA8F53AA66C
      Data.q $002BACA1A9B5AE01,$28CD4D62D33D253A,$C1439936605CBA71,$13DFBB25458E645F,$5103A60C2E6C5D24,$85C64AC876E4F76E,$0DE211124B685226,$649E9696C5C67156,$FB850C6A696BF6B1,$0859D07A75FF032E
      Data.q $F79C020457558E90,$8EDF780B627B81D9,$9FDFA6E9BA633CC7,$B9B9B929E0F06432,$674CD2D4D8F77442,$67A24484DCC1947B,$85B2A8C046140414,$BE13C2C96BAA1BFD,$FBE6F0783B2EDC2F,$D8791E47B1FFBBEE
      Data.q $9E15B9B9BA006BD1,$29925038ED31697E,$034388958F761D2A,$247E6FCBF9E089FB,$783F4F2BF97D4412,$462B14C91C73C0FC,$AC7AF9F78B070B59,$44ECD94744AF31C2,$17A0C8C6659A6424,$6A77759E2AAF51B7
      Data.q $D0C4944C5E9D1A6A,$2922153BC47EB181,$EC2DBA696E6870D2,$12C3BA815FA50D7A,$521826553A19B1A7,$D3ECBF7A5E33C56D,$24DF24AEE725CDDF,$DBF72AAF67C0F521,$80A1053ED4D92AEB,$A9F454A6B57DD20D
      Data.q $3D3E7126792CE8CA,$6F57B78E790472B2,$79E0808EA8121EFD,$0F0753632ECF79C0,$D8C1132C315BA393,$F0A33437C2B34187,$4322644BFCB92A93,$B00ABC5700BDCD57,$015B4A9DAA0E26DC,$1FA8B37378075F2A
      Data.q $4E067298CF038BFD,$5022FA73A8DFB2FF,$BC860AA58AA00324,$8297C2582C890108,$9C7DA50576459D9A,$C4E78CE651CCDD34,$1D9CF54F7E4DB8FD,$6D760E595950AD2D,$598B6BAA36DDB831,$4CBECA6E8695A209
      Data.q $B877626E0E884756,$0FB4378E05E555A1,$1464CE9D0A9031A0,$A0CF56434DE89AAC,$567994256A145F41,$CF8AA3354F78D130,$4C4CF080E953C740,$27C9C6FFC8EF1574,$76BBD46159123C9F,$A4DB0C8C75500379
      Data.q $182F0E1C5948E4FF,$27A29D1F0288A6FA,$F1EA63C9EA59297D,$D541D53CFCB0EBD5,$C008516AF8DDFA48,$9797701D464979EB,$4524F51601A1BAA3,$97BD7341D068D4A6,$826CD85C2458EF00,$98A8A8A8BBBEC5E1
      Data.q $153658A3BC81A33C,$F58A1F7E53DFD169,$88F180E3149072DD,$75FEF732E0DED1D5,$2A7FB38E1CFCCD1D,$F9441B7A17496802,$9635A4CA8CA8EF73,$B10384489ABE3164,$FA071C89C7476601,$D088C1F7DAC1AB8C
      Data.q $256791C77486B1DE,$A7F7C7D7BB4CD03F,$5755F9C58EC80FD1,$1A49A8E864BEFC1E,$4DC1A6A91F0E0E8D,$05B42844636AC850,$455195E018939270,$3884A66591E78CDB,$92DE027AD68E0FA9,$74E43BAC6D6B6B68
      Data.q $E664674005758E3A,$64174E9DEAC008E4,$6DDD68F3982392DA,$C733C02BC89A8A56,$7F91DA7A2B34802B,$9DD03E0226252A8B,$9B3D4D8448D3CF9D,$FC937A00202B6C94,$996035FF1684DE26,$A02F603625FA0C5B
      Data.q $6A6C20BC4B70318C,$21F4FC0851DD6E06,$3A9B8E38C5243A38,$5646D2660C08E472,$CC5CE78B8728AF29,$51097142C5252524,$D7D8865743EE50E1,$9D2749CB2DB6A6A5,$9FCC4A2D6EBB5C64,$9C00E0703E801AF4
      Data.q $CEDB7E495419F677,$164FBFD05CF9C03D,$0A06F56AF876CF01,$7BAADBA1E67D5F9E,$B5F6A3C8CD873C13,$6C8F003AB6B59A8D,$9F671B186748F774,$A506595A00C7B624,$9158CB81BAAC8EA9,$EC2674E5CFB750BF
      Data.q $E45DD9D9B6F0D1F5,$2952A61D57C8999F,$08910C80F2F4E3F3,$5B4404A00D2CA59C,$BF3E075FE9782E4A,$6880448BEFB20AF5,$4B6F766A3BF3E821,$7A862C89102828C9,$12E9B420BEC4A031,$D7D5BD8F3EC61395
      Data.q $6AC86213DECE8952,$72D2F59D2BCA2D48,$F5F4CF33241A2A48,$940B1E1101704AB0,$0A9C49856C195A00,$003DD36003067847,$FD13A6A7F8022C37,$92D7F9C8CA2C9102,$7BBA610CFC3D7C91,$D1AD0FD5489CFFA2
      Data.q $0585D1E77246299C,$CE052F3181473175,$D1013340978E4B24,$C0B2C10F3C275602,$7390DFC407C0B285,$4384CC0D061E5A4C,$A4BA0CCAAAA007E5,$67B0E80326A06A1C,$CF1D8CC2E04FB90C,$550F08C113C84447
      Data.q $DA00C95AB9C00DD5,$1D6347973C3A007E,$7FA393DA92AFA185,$D104758323074AA1,$7D4A0EBD633F4882,$3130F3FCA32FE455,$94F7664C05590DFA,$F9F9F9CDF41D1BAA,$AFEC009E5CF5F285,$E5C1A208A0B3A66A
      Data.q $E2D7561E689FF508,$0D980D064C101EA1,$83004D0FA82CF8BC,$CFA79BC02365B44E,$1C3D1017DB402011,$E7808E6D7A417C79,$509CF42BBE8A9D34,$95EFBB758CA2ECDF,$8B431463C8304353,$8FEFAF69E0B4F446
      Data.q $39DB1447EB881E39,$371E2867BC66AA20,$E8FEC27B7D6073CB,$A4F58FD62BFBFB38,$B208ED99BB41F02D,$63FE63678238E274,$488DA33B6DFFC960,$E3F9BF81172BD8CE,$D6C1E1D0BC42A4B6,$2FBEF96542D30658
      Data.q $067494D61DE76E3C,$21A4E0CBFBDDDA99,$7433F60C74016DA5,$9614943B5422011B,$165541097613813C,$0087252D8277E020,$F92D6BB7DF2866E9,$25C720E800AEAEA6,$665D07E7CE0A77A3,$A36E7D88420F792A
      Data.q $10F79466198427FE,$38390E954670232C,$34E837BFCB48CC8C,$C869E2EBC019D7A0,$5EC5FD1A974EAD6F,$01AA5D5042EF5687,$CFF041D744C87BCD,$AC3BA95D6DA6837F,$EC283FA8BFD11D8A,$1931D7A74AAF42A0
      Data.q $ED7E8A64C9825999,$D4BBF0FB43A12489,$EFCDAD9B5631D5D7,$AFEBEAF992349E46,$3B37D7FE801AF626,$24962C05BADCECA7,$4D87489040374249,$35340F61B3580E2D,$E2AAB9E08EBF97D5,$719CF4241DCF31F8
      Data.q $1BB448CF7B9EC0C5,$227F6268D1C5D43B,$4EF5D40CCAF9102E,$086AA17552A00AE2,$E772BD88519AB161,$4AAE52242B21F5E3,$4E883213EF61949F,$96FBC585E0BD2E49,$0009E7CEB9197CDE,$224CFEE0EEB3BCD1
      Data.q $5E344F8870F9075A,$F1A786B1A8EB39F1,$BB94911A2AA79380,$486E35011568E5AB,$64A0A4AD31B65E80,$2F097E5305CB8BE6,$182AC70310E75984,$1098DB131B4A3968,$DF9131E0BD76F724,$20FEC30073C1F00E
      Data.q $F9540355376EDF86,$289EEDA59FC85D45,$7D521EFD7B6ECFFA,$1323504319765146,$57A2719E1A98A08D,$624168823541100B,$6277F1044F81439F,$A7BC0719B4393DB4,$60124A604DF20A0A,$4A8264CCD08DDEF7
      Data.q $C12B1C12AFCCA567,$96A634C12B5412B2,$DF2B360BC1183716,$8A0A384C918F0081,$B7C6E0676F56FAE5,$B929B01164022A77,$96686FA33E7D1456,$1A871DC9FD467EFA,$212F08559F14F028,$577D841F731246AC
      Data.q $604822E7455E5C3B,$BDEC33692111B620,$93D4D44E674BDEF7,$E3B42A0E75550301,$FF464BD500FE34E5,$6A7DDC97E04338BE,$4B681454E05FA435,$16414ABDA223647E,$13CD4045FC1471E8,$38771E10E4A04701
      Data.q $4ED1E445D3E7E01D,$4841137ECA18F8F2,$DDACCA2E9454545D,$6A89692D49CAA76B,$102C517D10101F21,$589E178ED023F64D,$1EF87F20DDDAE715,$773759F54EF84B77,$FBC1D342F7819E08,$78BDC6976AFF57C1
      Data.q $EABA86F965755924,$6CD1896A6B16FDCA,$A5A1A8C036EBD586,$825F20F6E4ECEE11,$9199F60C4C73828F,$D1C7C8CC2C6CB3C0,$54AC93827EF0E12E,$DB6D77E66F65D9FF,$B92A7685DD8411F4,$110151F5E3C10E9C
      Data.q $50946B63D154DF8D,$516A74761C7C7CA1,$F9CA2037B441037D,$999C020D47D80501,$B314AB3A1AB7A861,$73C9039DECC0108E,$BB47700B60F7404A,$895440EB16ADDDFA,$7BBDDC4C707DF58A,$B1BD091E3A995537
      Data.q $593A22C252A5A7A4,$9DBC9463ADE8C92C,$9246EFB2F43D0030,$988EB66F63D669DE,$9D5195F67B00D633,$609AB74806FABA95,$8DFCA0EA705BF7CD,$CF0204E6ADBA1F67,$2B9642778F7E05BD,$A7A7A112E3A04818
      Data.q $F870EE8DC3926C8A,$6AC89C02B121C088,$17A2E838D92EBC1E,$7D93578FF4FBEF17,$D7A9DE72F7D4F61F,$7C84C83E667D411E,$9CE204D7CE35D2D7,$C905812779E38FBA,$3758B5F59CFBB2CA,$A8A43994C419EA7B
      Data.q $BF567D39CBCBD674,$EBD1FCE724667830,$80C9501AE95A4091,$C897B77963F76CB0,$031C4FA007D99EA8,$00BD94C0217488F8,$17E17BF75A217D77,$890EA41DA6F6DC9A,$241CF322C3025A00,$0843555168990F70
      Data.q $690E15466012CDB1,$41641071925E829B,$558335F7EE3C9604,$6B7B07CD4FE304DF,$78754D726AB58090,$5B68929FF8504D26,$07E754B0ECA57565,$53002796E0278F65,$BCFB97CF8FC0F133,$FD37DCD67B23DABE
      Data.q $FCBC689046564F86,$AB6FB1A22EA84C0C,$8316881254B66447,$C6D23A29A0A130A7,$2BD5A1B9C0896474,$487C819060590BBE,$6E2D105B74019080,$59BBC1C77D2391F3,$7DA56CB4C7728E9D,$FBF068D61D5E50AC
      Data.q $EA0FE234DDC80238,$7E2291B77CDDEA75,$EA8EAD5AD001332B,$9054BCF39D02BBA8,$4C990028E453A3A1,$65758A7935B09EA6,$E58090FE4973E1B8,$546780566E8809CB,$3BD738D4E492F8C9,$49A2E911ECCF58A4
      Data.q $7D3B47BD33AF8176,$3BB7B705AC0B2AB6,$07F296873F1B78DA,$65A2349975960981,$B0FEB6F9C043398C,$9299BFA282DCC5E6,$D96C360EA1B1A192,$9681D08D0F46E301,$0DB568B7CBA95627,$25A38D7595756DA6
      Data.q $40D737342B7B56BF,$DB282EDD782E7666,$8AF44A91F56363BB,$613408102EF1A5D2,$7A48C760B5A9543D,$02D18F4740E8442C,$46B481979C7E1913,$FD20A7715E9D9E64,$274129F9CF2FDF1E,$1AD78C69EBCFA590
      Data.q $FD5D3DFB2C760DFF,$25253A8776DDB7E6,$9B4C3106BAA6BF25,$CB5DADD63BEC03B9,$37238540E8235060,$93FEC1F4FA0A0737,$E1C24B3D13ADB909,$1543BAB47A384ACA,$019CCC170030408E,$F999C5CE6D559555
      Data.q $947E1F87D2D494D4,$F23EABE8014EE67E,$3D5A79FABAB4F02C,$CD7BB63D6AE1D78C,$B929AD06FF16DBDB,$862B07A2B7BFF361,$2BF417CB4F22DD51,$9C0346AC68E92082,$751562BD7C286234,$C121385F3FF1F755
      Data.q $CE95206A27406D33,$6D088DC2572EA24A,$206482F5EC9D2929,$C3C994823CD221E5,$48C113155A6B9F53,$2B1251D764822E8B,$FF33C1860DAA5CAD,$9AF19177A5AEC6F2,$A6CE7D0B0C4F57F9,$3259B1D2C23E0C46
      Data.q $0C8D5ECFBC700A50,$F50D9CF8F68CBA10,$B9F483B2B266633A,$783198D14AEC7B1B,$329AC65F9E0BA0C0,$C21185754904AAFB,$043BCA11108C2A06,$6E143065A40941A6,$6812012E82967AC5,$5E01EFE260143B16
      Data.q $3B8E584E3B574418,$801AD351A3256E01,$089D2227F1DABBA7,$FAA4EF958F9AEC6E,$00435D58CF00A0EC,$2B34C49C0B3C0A31,$16BD94F264087700,$4020624527345EA8,$A6F4104C8C1FB9DC,$D3BAA6BB0636BD20
      Data.q $A3B5D2FAE29C77F4,$B9236E92C1052770,$98D68B6C84E04E81,$45863501881C2C1D,$B3486BC4605E6534,$7042AF03A4255242,$E3D427A0D17A0293,$0A017C7B3EB4B006,$030807BD27CFC3FE,$0AF067A90E7810E3
      Data.q $E4F0CA02D30A1FF0,$8756A8EA88BDC831,$4A63005718CFE09D,$5CC73287B358E1D3,$94044EDE1DD43FA0,$69209FD08C18303C,$635868D765066A6B,$360C8B575A58DE1A,$43506CC0E1444346,$36791F63D94F325A
      Data.q $54769D53B518553F,$62F0C1609AB5499D,$A1382A059425F551,$D81506C9E4D38440,$8FBD4586D5486C4C,$72A83AB2F88D09D8,$627B6EC15AEFC325,$5948C0E75440BE1A,$8097B2940C3D8472,$633D544493897FE6
      Data.q $90694F5CED45761E,$982E2ABE5513B838,$B1B630F5D1ADECF3,$9A01679D1DB932CE,$F8E9A7DADE04FE2B,$53DC6520411275D1,$3ADE9B1DDEE0EF1B,$16864AFD85D4DC69,$3077C56CF8362D9A,$20DB59A6643E5FA0
      Data.q $601D2D105195B92E,$460FE7B6E4ED2E14,$B9D8BD4916DA4636,$D64353A5A6A4136B,$3D9FD7CD613AC6DA,$C70D76C92EA26127,$F494F6ADAD1C6A6A,$BCC691F57563E4AC,$B42CCB380A3A20D1,$74554611ECE3723C
      Data.q $77E87C682B6A147A,$DED0637B2E358F53,$A5418EEC120874D2,$FEE0F1AB36AD5956,$30C87870C477D883,$6296E1C216ED77BB,$704C9C92DD74D68A,$E24C5D014F470D8B,$6BBE58A833D2338F,$AA1DEDB6FB666ED7
      Data.q $2A60CC660BFFE070,$632B290B29B4560E,$ED7B1382DB5C8923,$0C31670596EBE802,$E244540BE4170CFB,$B53261935004EB56,$AF717FE7C3BDCA68,$185FEB5D27EDC3DF,$11EF75AF52987A95,$07DDBD42D42A0C15
      Data.q $5079754D82EDF6FB,$4A573C04CBD369B1,$2A40E1CF0284FB0D,$729520444E81D33D,$4D9595977EB75267,$7D36CA9AE06771F3,$1887AFC2744CD2F3,$C9AE31992C4CC8B6,$A923480B6C451332,$8D3F26EE0364027A
      Data.q $E1D056A44262A842,$EA105DD4F55D0674,$598DE9968E5ABAA2,$CF982EA13DA905FD,$ADBCE0A3B4F408ED,$DDF84DFFAE0FAEFC,$214DCC42F6D0ED08,$8248F9A7A0841176,$8036E430005B10DA,$E9A54C21F3A08A57
      Data.q $06455E0F00FDD52B,$791CE3852EAA326D,$BE563968E35044F0,$42601903026F6DC3,$9828E69805381620,$9A560AF254091962,$598F75473CD23057,$C638A7C86884FFD1,$9D088F5457464AF0,$2C23B5486A802BCF
      Data.q $8BC8568E5B41D178,$B9AB9F450647324C,$48C28AAC8DACEDA1,$6DD2126CD098691E,$D4CF044521A17DA1,$0BA4834014008645,$8579E65012A7F62E,$F2CE01B734C91150,$20CE27D9E188411F,$18A5649F184552AC
      Data.q $82EA72E6DAD39669,$AC321E3A8DF9AD0E,$74ACFFF4AA433A5A,$1A7454551A408815,$35C9A9378EFEE436,$D7C891A0ABB7605C,$EDF42E5FA4AEEAE8,$2ACE9E67478F429B,$8D001DA5F1E5B784,$850EC6EB686CF800
      Data.q $FA8E2968FDA45BDA,$18CB012092301BCC,$DF4C11738AF7FB76,$808143EE8C2A85DC,$055FFB140A4B6472,$B7115A57BA21BED1,$E6BEB9C03B0E303F,$C740FD768E27B255,$DBD9EBEB8AC9AE39,$0B8B92BFE78086B2
      Data.q $CBB47D7075EAA3B1,$60FE57881F869B57,$52DBD2F5FB58E020,$8364CB4B6DFFB233,$785863F8BABC133A,$6590DA19366025CD,$B282500A8B12347C,$4777A837542BCF16,$59221A04DF6DB601,$360C7F54D02C5B25
      Data.q $187D81F969F95DAC,$8D2DECBAC1CBBD72,$3999692DDAFAA6AE,$24EA4BC01BEA6B93,$0B9CC951F0DA3596,$2BCB971D92804251,$3D06087E03F9099B,$23B1C34B41A5D160,$3AD006892396D6F6,$955534E9D7A8D6AD
      Data.q $168C2CDCACB365B1,$6AB55A7475AA3319,$1A808C51B4DC6C25,$753BDBB0E00A9041,$68FAA1A9A7AA960D,$D1AB59AB26E3CC75,$2F3C04D005DA93A8,$870E1BF21BD55860,$7DE9CD921A1EA65E,$2B264E925C9AB916
      Data.q $EB97D739DAF88831,$0B9BC9DE3E83CAEA,$F8A44FC04A3856C6,$A3CF1583CF97E1D4,$C298CF0244F3B5E2,$90397BA0007A5481,$F9E10C268A603B4A,$5F66DE8213B1B873,$CC815BD00037C54B,$568C4BD627C4687B
      Data.q $E565638ED2E64822,$9AA690FB94EBD07C,$6C859F47F232DB5D,$2243711C57DE5A15,$C26031471DF9D71C,$5DA402A4DDF513A1,$626B00327CD77000,$BEA01E437844F2F8,$DA0027ADB570CC38,$4D82A92370BC00BF
      Data.q $3D916722FFD8DFA2,$155D6B4F7D8F5E4F,$08A38112AFE82BA7,$0851025E3DF469A2,$27A88388625E1978,$3E6398979E669941,$3A9EC8E74821CAAC,$2349EA5783BD4904,$C7E4B40F7A78E668,$3D8853A0C9F23A75
      Data.q $1A0D2B4CC3220BD0,$383E8636FE3C79BD,$ACA5228570D949F5,$85C6CB50186C045A,$20307D1A0629828C,$78796939F4086BA9,$08B9F92C9B05041E,$37C141A20910079D,$8B19F894723E9233,$3FBFDFEA0C976E81
      Data.q $C9934C6351959594,$D1919190CDCDCD04,$3D8604B3C1932371,$A5B9E08573752F1E,$70C6D81C0E0605A5,$1E80259D1E8FA953,$CD0286989EDBACB3,$B1BA8B80118EB13B,$D6968022579B4AF7,$6F8559BA5B6D22FF
      Data.q $7226EF7252FC2023,$8B7E493FF6C9CB8F,$2FEC78F2A40FC76C,$26A6DD0554E6D2A1,$9ED2671ED069DC60,$8029674E31B06151,$7E7685105143FEBB,$D6A4D4C605F5CEDF,$FD8AF82EF3B556E5,$C7D7CADD69FB3EBB
      Data.q $5C0592533AF73D4E,$B7E07FE6F458568E,$96E6D492CD8167F3,$902695B59152E831,$F6DD6C48CE299C94,$84CF4B482E7D7813,$AAA7EDBDD846A6E6,$BB1BD4E182583ECF,$37DB3DD58BA04043,$568D64C864B7DA7E
      Data.q $4763C982EC765B0F,$21046C1ECA3F1847,$11F24667D92B3412,$35B53DD3CB3FEB2D,$BBFDEA850076D495,$0FBA2673F722ADB7,$CD22600C6AD4A955,$A2E37DE892F9B4D0,$BEB139D939321759,$5354D75470BDC26E
      Data.q $0A07BAA62ABABB41,$71D5863E8B9F04EB,$BF6A9BBB3C096799,$F95B2A5FDBD5E1FD,$F65865FEE7C3A3CF,$C0466897938FD988,$DE4EBD2154F0C2AC,$4F77D0F4B9DFAEE5,$B7F0EEBBB755DBFC,$1012C7F9AFA3B4E3
      Data.q $C3290C6BCE38D9B4,$5BC36478555CC6F3,$4E98E3B6AD19D0D5,$DDA92A6C112A40E4,$1D25A06284F06081,$19C974CEFA89E0E1,$D385628365A7063A,$070213707F5ABA90,$0FEE7A5A9CDFACAF,$CF040463A00CA9CC
      Data.q $BFFB55BD660F1F1E,$F0039E9044746EFC,$886F1AC4370065C8,$11048BFABD25E628,$9911CFA4193771BF,$E45DF6400FA998B1,$BFF59B20CE003BDC,$1B5A9A040C1D0024,$BCF3E617E7A7568E,$6EA844713D415EA8
      Data.q $ACB18C8A0A801270,$93873A5980C9C1CA,$968998466AB0E999,$51C587F42BC73500,$3C20EC6ECAF6C43A,$6068740C15E41DBB,$76C78D0C954EE024,$850B1524210B6F6F,$365492BFD6410E1F,$84CF075AB20B8410
      Data.q $828B3E1A05FC5B06,$065960CBCCF3A484,$9860E1B458E842FF,$48FC4C910F621671,$B3B3B3377E074C84,$E1CB381483C1E0E1,$C955FFEC955DD1BB,$9032CE065800CB44,$D5D50FDFBF535D46,$F09A8D45555550D5
      Data.q $FBD842C99D79F237,$1A4BBF59FA13574F,$720209F76024AFB3,$F800251FD6073CAB,$6CF0AB37496FB206,$EB917FEF585240FC,$A38542E77676D962,$0419B65EAD97B15E,$83DF1A1D26DD99F7,$EA8EA0EF91B65B63
      Data.q $D323DBDDE660894B,$2F49E153F495460F,$7E57EB7DB3E83BD9,$C8D064A32D2DA776,$53C072ED10512753,$A1874E33B9812F2F,$CCF008E820DBFDA5,$DD363434E2B3C02B,$C64190418D336DBC,$80AEAC687AFA86E9
      Data.q $7148CB6CD9965B24,$DEEC0E4326DD9CB9,$196903FD534B5EFA,$47630AD86DDF4939,$43A0621B5EA3030F,$E33C1A39E60A3A13,$3D469A460A700D7B,$A5A4A4056D6D420E,$EB8DD6FCC3D1ED41,$A40885DEDC258EB1
      Data.q $D1D9DAEB881FDF9C,$3E4E13F516FA60EA,$C6E36385E2E3E4F9,$E91DFDC7B56F608D,$E800DAC384A08403,$B89BF66BD012BFEB,$05E5F17CFCABACEE,$BDEDB4D172A8824F,$35628D260B59F63B,$A5F0E47C2E895729
      Data.q $D9A8EEE787EAABBC,$2C6D6A924956F6F2,$9AD65E1BD9F5EF5B,$3F6A63243B941EB3,$C517FA16245B7DAC,$F40C509EB0102554,$19868DAB26749E89,$DA9C008697FC8956,$238E047653AEDFBD,$A3A1CF7E037BD69B
      Data.q $ACE9B64A6782037E,$6621560FFEC000C9,$060FCF0085B8C010,$3CF600EF84EB1118,$56D8A7C00375C045,$CE6F16C88CB8071F,$300B1AFC6F199800,$D9000AFFBF9A8C8C,$B1B8A27DE50F5E94,$167FEDF71978F05B
      Data.q $C867AA9F382021EE,$4FBA399066419E7E,$17320C49C09CD406,$108C620468032E3A,$AB233328EFD20FDE,$F2D33A48002AA07B,$2CD30579A066413E,$0D0885088D904306,$558E9A1E1EFC0142,$D4BAF430BFD18B6C
      Data.q $547AE90CF5440150,$4EE70E5B53CB19DD,$6B2E1A9BA8004C1A,$4ED07435EBD51809,$B51A08CD21E024CB,$34AB49F21D5FDC9E,$E7F846FADAF5C26E,$B3151313C342ABA7,$2970D1A82FA0B93E,$CD66B0C00C867581
      Data.q $A1498F21A628109A,$C896BD2BAE0D5030,$0FF546682331977E,$57AB0C3E1F0F9D64,$141A96FDBF6F86AF,$80BB4C66331E8821,$4D5B701127773A39,$44D9274C4FAA2DC0,$4CDFF40CF6C9DFF2,$79FA0643B1BA3440
      Data.q $2362A60C00639EE8,$DE4F5EF7AE4998D7,$99C2B1513FE41731,$98E5086DD7D89B4C,$463C62380AFD69C7,$FA2EE8030F815800,$769F0A081076C699,$F07D965A060E284A,$6C3A5FBD93225CF6,$E0FBF7EC83F438F4
      Data.q $70B98501832CFFCD,$4B199B9050B1D4F6,$118025A95420A4F6,$6AC7D500381DF72C,$50C9C949069296C0,$460CBE5ABE0C775F,$66CE379D1706188D,$171DE8F33C979930,$76ADB48444D79CB1,$B9BDB46C2BBABDBB
      Data.q $369D5EAB75A7E6B1,$FE3E1695041FEE63,$6108F4E17E5C1572,$084F04F0E6025043,$D939525CC64A7364,$CF7D813AF5076FBB,$BD5B57597CD7EFE6,$E47C9955D6E41219,$74746BD0761C3ADD,$D0D2B6E568164776
      Data.q $F6BB7D819A8C00D0,$1241BD546E5CCEF5,$A479506B0C41B1A0,$A9044AC0C755F48A,$B4B4B7CDB4C54501,$60F9A00D8BE7DF82,$6F7E70B6AD566AF0,$45F5095A719E048D,$D0E5A86B0C7356B1,$BCF051B14D271145
      Data.q $128D79D24FF3C108,$0979396F80B9E138,$36A236AB20BDCA0F,$4BEB38E0AB154E3E,$40C447B8E7C08FFE,$5481D3A9DD84D62A,$FFD9C95248A4644E,$80C5D3A8B6A38597,$1D71B238E5D1A9A7,$DAC6BAAE0288D428
      Data.q $84A77DDC383FDDCA,$11A14D5D15AD71C6,$6250271C4F53D323,$1B3F8056F1B805CF,$D276F013C3910C00,$082247F1FCE4896E,$1336A1A496772FDE,$C58BE5E01F957D40,$03BB2BC985EDB6C1,$F04C3F6DC5D20EE0
      Data.q $75DECFFFEF336F6D,$9B667FDB9D51C780,$4AF725965DEAB4BA,$2760EC60EE4B0631,$92600EC6A3C0B424,$C8048F790908F380,$1D31AA100907840B,$636C77018EE0319E,$2C96CB6CB248BDCB,$999B7B695B7AB24B
      Data.q $AEF2B3BB333BFF77,$E3B7CDFD74658CBA,$3DFFBDECECECECD1,$F1A5297FCF73DCF7,$1CE69D222AAC6D6E,$D157C5068B14E79E,$2F68BAA688F25A13,$C4828DB34AFF6E38,$0535EC4B48C4833A,$ECB54C49CD1B12C8
      Data.q $854E0A7945CA01D6,$E47B75E54569DA67,$251D3B7364C99B78,$CE5052A0D50C62FE,$FDB1A1645613D288,$C8AF6B830FAB16E0,$046C9A3006CACA86,$687841D50808AB40,$384D5A021CCF0C08,$26170E52D4C155A8
      Data.q $4ABC8A9DF592D5A9,$9766FF2C3D7D4D5B,$8DABBC1A283D4ED4,$60D5EE83454DBA15,$8E0ABAAEABDD809A,$C555DA299F42391C,$63AC0469D68AC6C6,$32C8C67C6A8328E7,$9027243C0B466821,$0F6EF77BBE004675
      Data.q $47D1E0D7B5ED7EB0,$FDB87D7E0B04C51F,$F414F2389CBDCFB0,$043FF0E783C7467F,$5C1366300043BF44,$ECE0AEDC085C5D0A,$ACB5C99B8D727AD1,$BCF5E8F05541BD3D,$27D43BAC557FEF3D,$36BEFFD9C105D6B9
      Data.q $445FB6F91D880EE6,$701586DC18BC54DC,$D5E79F5C2EB8EAC1,$68ED5D75E8C87516,$FC3F2BB7DD5B761D,$73ABB8FAF6D4C585,$3A327A32C7D48D6E,$81AD1FEBC2346AAC,$0C28623B1868F8E4,$E3A9147D68864B49
      Data.q $598E17EA1916D23A,$01A1B6B100C81B84,$94848C8F08268CDA,$E01B9B5AB75A74D4,$D47B26ADADBDFEF0,$3F085039085AF299,$86E8F8D6DF493999,$72757A9306778793,$73962C5B372D96CB,$FE3B7DB1FC48C0DD
      Data.q $8D67A6B7D5C26A31,$39EFB61E725E3F4A,$BD0BE8A49D4FD704,$A42E0E56C03A0DB2,$6595E5D800A02A64,$25031FD012B6B660,$02F95FAD36DB0B27,$83BB769F88FEF562,$18E6D8A18CACE482,$084E1C25674DFF65
      Data.q $12106565653085D1,$E9A9AEAED820C21C,$9C9291C24F7526A4,$6563C06411E1E10C,$CFD2B0EAC062E262,$B258531D4F9F963F,$EAF289C69439959F,$B0ED005F82098C4A,$B93FA879A953EF3A,$B7CAB8849E883577
      Data.q $4DDE54AA0A99D3CD,$1F3C1171069BB882,$190EDB025AB9E0A5,$FC37C38CE7FEEDE9,$4C8987A4260C4CAD,$4B82A4D534AE7ABD,$8EF45916A97D074C,$F428E837C903EEB9,$B8F0966972A44F07,$680D012B873421D4
      Data.q $65DE7BF5BF9A5206,$364A9AE692376A6D,$9B3699DBF6190EAF,$F064E490AA8E769B,$80548963A81E0BA3,$BFBAF485FC025FEC,$1FF670083E77A7F4,$2817F1BE001B4F00,$192160157D6D8C49,$CFAFE458001F1B45
      Data.q $E427C01EFB5C8822,$628FE68D44386633,$E9DBB8E0BCAEA996,$72A0CB23E714AA92,$3D5E90C970ADDE09,$04359D165D99675A,$75BBAA63B941C249,$79EF9E8B9C78968B,$5910DB2BC3F5C78F,$18389D7BEFD1F053
      Data.q $94B468C73C6C5A4F,$209EBED4C6B57E2D,$A69A00F223E54D03,$221B6E4BB618F50A,$2E1F760AB4A27C9D,$485A7582069D2086,$D3A7CDE63B818C4D,$A9F7970DE59608EF,$5B2A59F71A00BE54,$9C822CB37B9C7A56
      Data.q $C4B2F7A0F9DA14A5,$3C1C0E4E4E40C4C4,$F120749463829078,$1F3F1A203DEBD7A0,$73B15718D8043099,$79790555555C0047,$4114CF88AF5CA079,$AF6BDAE10B85C2F4,$F09E802DEE7DA80D,$C3BB46617CD236E4
      Data.q $FF5C2F05738E43FF,$813C0012F7A20482,$4C36C91BB64F5EEC,$94EC6DBA20E5618A,$D1044EC00297E6D8,$F6B56B90E635C93B,$DD9D54B673B33EE4,$28F4F765F00D6A35,$5BFC273E03E3A950,$CE76756326822B8F
      Data.q $BD874E0B13F8EEA6,$945756162B57DB61,$897133C17B3299EE,$7524884888B0FA29,$8701553D1C35D705,$3564BF53CBC54A8B,$C3280C86AD1A1BAD,$D75268F494EE8A68,$86BEB1A05AB36055,$7D57EB35EBE5B5DF
      Data.q $35AA165371ACCFF6,$102191F57BE35FBA,$4646462EB142982C,$82EEBACE67339D8E,$C7D571BCDCD59B68,$6C7D6BE4B85F6F0B,$6012B031DE6B6EA2,$A53A82CF1CFAFF3A,$4D12B9ACC9BCA5E3,$10B50D750D3D9C96
      Data.q $37C04F8A67009717,$D858DCD2D27E56EB,$3637376EC388A45F,$98B3A51F0F473B35,$4221412113657E2D,$0A170F08899CB9B9,$F6609B4DDBE00B0A,$C24EF4C45090370D,$D9853B5DEEE64241,$931833E98CC16733
      Data.q $64D581A7A5A428D9,$2FC824F57C9F7FA5,$7D9404B2B3B2602C,$83B373734CB48369,$E7261DBCA9FF5965,$A523A9FD41758678,$3FB4C6C1916A4752,$727380B33C0A6616,$A7FEBD0FAB9B54C8,$C67832260659E040
      Data.q $6C0F95EE5C684D57,$3734EDDB2FAA6DDF,$1FA5DB93FDF1547F,$B24C4A6811CE5065,$EEB8FFBBC2940A3E,$319F56586127E0CB,$DA8BDA4AE05D246E,$75835F3F7BB384ED,$662426BEE32AC95A,$1766D17DBF8988D5
      Data.q $34268C4455049F2D,$F5E01FA86965CE3E,$3C01F713C01B7353,$6E349097C0B807AE,$99E0273E1B0007E7,$3EFCD2412774F7FC,$E0047EB0323663C0,$04417879195D7F51,$F464CDC038FC7F68,$A6D6E6A36863FC5D
      Data.q $018E8C886AA6D6A2,$1C2590C6725171D1,$A403DA6624667DA8,$8C02007752FC3158,$CF885156FD18E0C9,$6BE856CDEFBA0E73,$442C5D943B6626FF,$5AF03B165FDE3D0B,$08A4D0C087C27A6B,$D7A7CB6030AD8B16
      Data.q $49D5DB2FBA18FA97,$C83CCA22C58F3212,$B6C144EFE8356077,$02B3ACA44B662546,$48B1134D1025AB34,$337D9C03C6B518C7,$8CD330574812326E,$8E675A82BDD1E752,$141C6E371E799DF3,$411A408C50531717
      Data.q $8F9F2C7065124A32,$0A6AEAEAE77E269D,$D532B641969591B6,$B1EA99487E1F87F6,$FC434A33007AC763,$FCF04DD8FA596701,$F7F20FF5405FF829,$25AE90086FEBC86B,$2BF9B4AB6C3F17C0,$0277F5FB190022FF
      Data.q $DA204AB72DA451A0,$EDD17D4D83BEA3D0,$F9987A12AD5DBF2A,$80759E39E9E76FA2,$4C52157C9EC5ED36,$B9392F2D2E0FF327,$526139FF599CEAE9,$09C3239213632FEE,$0E82E4E86685C690,$E0BEB15F45562A8A
      Data.q $B1B37BB631BF22A6,$0F47E3B89A5B5A15,$97946F97DD76FDEC,$DBEE1435D726EE95,$EB34DC2B468D7BF2,$608ACE8E3AF507DA,$A208740642BAC1FD,$5A208BACBA204BD7,$C5E8808EFB2CA9A8,$7898FAA581EDB93F
      Data.q $82AF2D281282FEED,$2E92D2430E9DCC5F,$D9EAE5B5E92E2F4C,$3B682753A2836C6A,$43F7FB0384484F8E,$0FF7E47A2C2C6A56,$BE5B5CD4DB9F9454,$DBEAE6C85A74E9D7,$191366CC383787DF,$C1BB724D9394E894
      Data.q $86713AB4119B637D,$C600B0582E151708,$8A8E81217D089C4F,$48B4CC4AAE8CA48C,$9C913B5C7CFE4B3F,$AD5B581C17B9EC9C,$A00BF56ED83236D6,$5757474764BB46ED,$A38B9FFA750EE5D8,$6E917276EB5B8E78
      Data.q $E0209F37E78093A7,$BC80AC59E00758F9,$0EAC9711174BFEAF,$E6477150D2C3BE89,$0BF7EEFB9E5657AC,$747FE2C1839BA625,$57198D8A525CEF69,$0E7D18F685D85F97,$4991216C0646E7F8,$B9A2CF8312E85999
      Data.q $F04EDE795B7974E4,$D7B2696B6DC210B3,$192F76990EA55CEC,$0CC504D5928E91F5,$72A01829F4004E1D,$3D58037F618014A3,$0F9DCF47EB0C601C,$03D1E7F3C002F950,$67EB18562ECFC49F,$C00BBFAE30124F00
      Data.q $0013C4601E34CB2F,$FAFE86AED9159F4B,$DCB608B40F82977E,$C888B096E5B52D65,$94022A63B4E46008,$C09C5D5D028C92B4,$87D15B7638221DB9,$203CDCEA2B656090,$9E690F5F67989799,$DD23D9C01416CCA6
      Data.q $B4C1AA579FC17900,$8D92247CCADC80EB,$C2B2C686021D4A96,$06E950D5DA819000,$D7B520ED69053B0E,$9D23C22E3581C563,$536434AB8B530A8D,$C346B9814D42FE91,$0CE0659E0953C04A,$46554AD0329A803E
      Data.q $F1896091410FC73B,$CA7EFCC70133A29A,$5445A2D16147A3D1,$9EC00466D905816E,$7A6F81035DC91599,$3CD451C63BFD3A7A,$3DD538FC7E3E6023,$0E3008796BA1EFCB,$FD73B96100F60E0E,$638C107BE98FE3F8
      Data.q $48C9514F53D4FC67,$09E39756004D107B,$6D23B9E04877C701,$2822E7267591CFF3,$E7ED1B50676C8F7E,$EFC6012378E4715A,$75FF8296878C8012,$6E723CF44C4B571E,$272DF27843DB774D,$B7FCA105DF2BE78C
      Data.q $633AAC6A423F7C3F,$88B8BD13E6CE7659,$ABE5BF7E97316AD3,$C6239FEDBDDA1FDF,$A5E72BF8D479BC4C,$0E898FA5189F0D67,$C09B60EB13017522,$5ED59B0E46B389F6,$EEE8F0AA72565955,$75535B557DF707A3
      Data.q $FD7725549EB18A5C,$19D69EBA647D866C,$EEA5ADADA961D01C,$9FE898918E1EA42E,$F23F1F4FE6898375,$BEF5BBCEB0E9CB89,$010E4D235312E277,$616292D201BE5EDE,$000853A4026CE8E2,$CD1BD45309D5A30D
      Data.q $06BAEA826C6FA836,$EB4B131D101C39B0,$8F8743CE5392D9EE,$9399BCF528CB26B1,$FDAF9F8BDBFA9EC3,$67B2DE62C5A34DF4,$ABE9633691DF9ECF,$FC0FF196F7FDE85F,$96AC53736369516A,$02488E328BE93FF5
      Data.q $673FB328AA6AAB74,$1E697F7C798A5CDE,$B50A11DC70DD184E,$410A0D150598356E,$75AE1838ABC59624,$EB7DAB043C6195C2,$9DCED761C311C8E4,$48159F8DCDE8DAF4,$974BD3EDB628D62D,$007E9BF6FDBC25BE
      Data.q $F531991CDF4ED9B4,$F1DB29EC9733A1FE,$2E72668A27D4C36A,$356CDB704F41FA37,$23EC7B533E970755,$04F67801D352805C,$AC199E1B15A20A28,$EA7D2DB8E9CE034F,$8929FBFFBB950D73,$9EBE877B45D41EED
      Data.q $6E6E6959DE834C7D,$666461D88445D3EA,$7B363830CFD01D0E,$D2D9870458644844,$0267CEF8DA2AD548,$FCBAF8CF500A6EEF,$30FFFAF1BD4CDF4F,$309A189ECC2A1D1A,$0C34947EE5530AFE,$022F0B891A51B938
      Data.q $BCEB1FD4300E937C,$E8122F00B5CFE08C,$BF009BDB39A993D6,$0E639C9023813D21,$ED8093FC00577319,$E8A971CCE4FD9DC7,$C9F2DD64DF789FA0,$B9C89B8F86D2CBAF,$D134EDC05B1404EC,$C1E63029960850C5
      Data.q $7F45C43ACA213EE3,$7D1CD194D2F8CC8C,$33AD5338D259C0A5,$496C2A6FBCCDB32F,$C785F544C599E1BE,$613D2B8978505A00,$85C59575006F7219,$D7105C7A9886E001,$BC10DE743B3B53E9,$651F41A756E08FF7
      Data.q $CC74467D919E089D,$D0332CB451125262,$1A307191F067DABE,$174418C8AB26578D,$4BECA5EE2994A9EF,$8097EDDBB731601D,$B25972C0040DE741,$5BCB89BDD4050964,$C68378DE37856EB7,$404A23DE3AB53948
      Data.q $BABA846C6C6F93B0,$C5715C0CE673383A,$DC0749F71CB13E15,$FF42FA2F004278A5,$FDAC7A20616D741F,$AE7FB17BC82ADA41,$5249885ECC298895,$86FD10128FE39286,$CEC131A262074402,$84E882EECCCE720E
      Data.q $39A7AAFD730587AC,$19F2C963153CD37B,$1C4C35DD03E674DE,$67E109CFAEEDFDF8,$B1CCD07D33DA4D19,$C3FCD9EB366CD9C1,$26B56ABBDB235F7B,$2A222C2D26263A22,$D8D2AB2CF0FC8223,$0D0DF58C9AEE04AC
      Data.q $072245AD9B761575,$5B2CEFD3E21F526D,$329B92B2B2BF2CB6,$03F172F4350A8A65,$174ECAE0E723BBA2,$98CCCE979DECFAAD,$4D355DC7C3ABCB7B,$0AFB055E0E0F1B1F,$D71D94D3B1DE42CF,$B0DD5918EBD4D468
      Data.q $28F0808F0B0870B0,$DF647850AD8C9815,$84D017F5BFEFE589,$57B1DD5EC38368A7,$73C04E1616931AAB,$D973737207A7B938,$B6CBA9317EFFBFEF,$ADAD1CFDA4A18ABE,$3051832D3336BBAD,$E686DFBC687A3ECF
      Data.q $95760E9D2D2D2646,$D5F8670056DEA0B5,$70C9D68609D2218C,$5C72A932318D39D6,$6DDC83B056904E61,$FCC0B7A3DCC5C5B0,$E919E93106B2AD64,$62484C4869CCFA70,$B7FE3E7E17DE85C4,$60CF51FCDB1EBEAE
      Data.q $B4AAC79CDA0642F8,$BC3F26D3B2680239,$13CCEF5483D26533,$786F174F99B2E140,$612AC8E3FA96F7F8,$D7AD33C08EE69F46,$5150C0DA98766812,$6E343CBE386D60D4,$7D20E2CA653C3BA8,$AF961E82DAD3987A
      Data.q $043A9160C1B1D74A,$73B4D75C72BC7A8E,$E9F45CA5DD8D943F,$6B549475426AE457,$5712B639AFAD2929,$0C63C40A2DFC5B98,$52A37C8F5AE31EC3,$49A490F73E29FF8F,$C97AB00DD3984893,$276F008FFF30035C
      Data.q $61D0118FA7DA1251,$4F460348178015E3,$20E7284CB88CDEF6,$7AFED30110F1CC58,$B0F57A43DC035FE0,$D73970C9967001D7,$81ED4322D9C34335,$4C91E3DE662F5E89,$65022F3D4D308B1D,$4C89ECB381963999
      Data.q $B4DF6B4A7230A313,$231BFDB2BAE28CD7,$9D52904ADCA56801,$2056F24A0933F8F8,$089D72EDCB8B4C1D,$642248A0127B40C4,$B1B1DC80A5929186,$0343A82012874004,$A21F268829A00A66,$A959F65F691B50D5
      Data.q $CBDA8D681A156683,$3455980CB914CB3A,$093A24F687A4B5EF,$2BB7314CA779A104,$5D16C08B104679A8,$F66E1CADEDE3B038,$1F07C1FD1F54D9EC,$B2862A371EF31E88,$A3A373F4D9D9D9D7,$ABA3BC92DD882FA3
      Data.q $F8BC67809D27E4F1,$5809BC0D3C8B1277,$86BCB28A2937C032,$68812EBF44047556,$F786FEA3FB5AC487,$B652D6D94D674414,$596FBCB6F35F86F7,$234EBFA2D6EA0F96,$CED625B23CC7275C,$2DCD94E868B55F04
      Data.q $6E9D57598B694A7D,$B643575F50D8CBB7,$E0BD3650809BE043,$97A7D3E9C246C03B,$C9C95E475250D793,$73913DD1000751C9,$97CB75FC86A68670,$9CA4FE6A361CCBCE,$5175C577188C8FD9,$E9041454686D18FA
      Data.q $76E730DE09E91E74,$8289F4FBB55D5341,$83D1E9F57F36EFC2,$9F07A48A3A9256FB,$5AAFB3CDD65D739B,$ECE39EB415CBFAB2,$4DA6D37DEC6C6C4A,$9C71C23CF67B3D83,$D3DAE9CBAA1E2FB5,$10BC5C4248FCD2DC
      Data.q $AD0C12D437F20BAC,$7373530972E5C606,$705DE39C7A49FB65,$25084168C301F8DC,$7E24CC5DC4DAE02D,$831B290994DE5097,$81B9C3349D3B5D19,$13CE3A34267EE079,$C5D3E281C94CA726,$EFC22C22210CF90C
      Data.q $E0B4366836ED5BE7,$558DCDA0080BEC3D,$B2C3437EA44507CF,$7AADBDA4F5317E04,$286961BF3FB6D963,$CECE88752F5486C2,$96E0F9177EF88EC6,$762C2FFDAA86FCB2,$CE7A5B4D93312B18,$B55AF37E198DED7F
      Data.q $37D7BDCC7E2C222E,$A831BD34A564F89C,$7D828EE780F00687,$A9D144C5C433436D,$340CE81BB1B6BEA3,$4F267CF9BFB9B676,$5F2B77C1CF107D1A,$ADB31D552D3BC65A,$CEA5CF2BFF76BB82,$A2EAD6E2D9AE74FD
      Data.q $52E411B4A8C95CC7,$ED72B48389C1036D,$72896017BF7F0003,$DBF9403E78DE20A1,$A62067D350403464,$8053F594C90BEE00,$83F8012CB5044827,$0C3F3F001DC8993F,$03CE5F7F9C449070,$BE4EC7C725F3FAE4
      Data.q $1B227DBCA4344A86,$E3E24A5E64FA882C,$4F0A5E5860155BE9,$CAEFD8859951D5B3,$ECA5EBCF3BB434EC,$47D203155E5DCD9B,$EC8ABBC7A11D0AB1,$E86B9E79EB5A19B4,$9BC1128BBD636C98,$88D468280B0E8502
      Data.q $9668194CFB32C9BE,$0D16FECF85C2A62E,$D001357FFA0E32CA,$85D84DECF30F8D5A,$B63C0F1E6E2B340C,$FBF66CD99CCDD4A3,$88640E12CACC107D,$6594E969696DE3B1,$A008193C9E4CACEE,$992AEBD0562B1581
      Data.q $4E4BB834E268D468,$B0ABAB56306CA32A,$E96D0AD58BAAB0B0,$B642C71FC139A7D0,$91338A0239DB647B,$864CC2E06FDB2760,$5254CF4EF68C82CA,$CE29C640084FDEC9,$F5B9C8D3D1013A2F,$71DD6CA7431369DD
      Data.q $B7D2F8698FB1BBFA,$1EFC652025DE5E50,$FE45C56E7E79AD6C,$C1A9F9D67BFC0BB6,$CA62363D66C786E8,$5664E5ECD8FD9DE6,$95DFA2024EA58D3D,$477744C0BA57ABBA,$C9CCECB5965D81CE,$999F4A323AFB6455
      Data.q $7190FA4A6A6C399E,$A1A121C1497131D1,$5534356C66C3976E,$DBDE292B2E2F2F9F,$AE25264BCE80D8D4,$A21E8E0A62660C8B,$3DF3F3F39F588D56,$EF2F2F217E809A20,$EEDF8179A2017D37,$89D54ACA67DD3A70
      Data.q $9343F3E52654F1B1,$8CC663095D5955A6,$6463073D33EC1461,$13E26F18980A5364,$7E7B70A511591D0C,$1ADF9C51F0624421,$141D411FFC4C029B,$55C2858587BA19E2,$32661C8E470D5D57,$DDA7881177808652
      Data.q $DC3872E00D4D7532,$7E8FA00808ED9304,$D22C56DBD8DB6F30,$2EC9356189FEA784,$AA9AFB6CA1A1534B,$B23C8C319660AF03,$9B7C10A1A697472B,$025CB05F52C02AEA,$5F3DE6543699A8CF,$3A1B4AA4EF3A1FAD
      Data.q $2D5B441A389A135A,$4122EE72E9845C35,$ACF1D5CB8E7CDEA1,$0D9B91525AEB823A,$B740C8331F14906D,$D389D4A0A8A0AA2B,$60E07F3F43A4B267,$773423A81591CD49,$ACE6399A16458404,$0F217B3F5AA9FADB
      Data.q $AA695E5729613161,$B918B27097035FDC,$94A7200D31B8018C,$5AF6908B3A075EC4,$19120EEBC0415006,$D97DA1FA2A539137,$93CB632095FC0356,$408C6881DAAB4F00,$F398125BFF3C012F,$A5A1D6B965E5CD45
      Data.q $B00D533166C8AAAE,$82832BD5EDA948A0,$659660AF31C11659,$17980624775D4C60,$B481E29448A0FBBC,$D67DE050012D501E,$7978B76D3105B9D9,$7F858CDB181DD3C1,$22CF151274502CF9,$2A4592D2D0B12D93
      Data.q $E411588688E3C10B,$492D20437198EA02,$3C07D068B14E3838,$5750AB13110EB2CB,$71878B2A9639E72C,$F3F4B0CD0B22B356,$F5BDBB5026692324,$9FDBBB97918F5BD6,$2378DE3702929292,$6DD02A4A8C763B1C
      Data.q $8FB681CA53A9D4E3,$9A302E34C07773F7,$7691B8DC6C2E773B,$57A344C881C5CAF8,$ABEF93AD91A56A34,$77343060C2AAAAAA,$F1804C5C70114EA5,$A59E040F8E65896C,$19C7CE463D581173,$DE722BF25C0287B3
      Data.q $096BBD92E03417BD,$C416FE881DA3BE40,$ED1065E1CEB8870C,$68AB31197DADBAF2,$3DC6DCE3EBA1E559,$F6D03E40E880FACF,$E33ED027F27AD063,$81D3A3C8AE1FE8B2,$A7F4E44D6782340F,$1D0800D979BD5E86
      Data.q $2F2BB34997A2020E,$DB5B0D1E439CB1F7,$4C583B1F8E270D5A,$6E96E694B3849536,$7FDFF7CD705F2E29,$3F9FCC867ED271FF,$DD104160D7BA2A7F,$E6E7F72CB38CDCDC,$7FFE58E7217D32E6,$E0BF2FDB76DC349F
      Data.q $6C7E47133A2EEE39,$85B9CDDE9BD42C41,$82D9ACF66630B088,$B0E9FE2587830D62,$799942F5C6A29917,$597860467AB89837,$88E4D893C3AF46C3,$CFED049BDCB8624D,$BA8982EA22268117,$0B8FC74533A7D319
      Data.q $6C1D42A8E8C5A5C5,$175C059A022F99E5,$15CBE2F8BE3BB0E1,$2B45B0763401018D,$97ABC55C39AB44EF,$BB59B8CD025D941A,$8602D8C37CA82603,$6245BC004A769B73,$347290E3739E18A2,$DB3F41D2DFA8EA01
      Data.q $E6FC1AC7C0C3E1DB,$DEEAE22626964BC5,$8EBA510343AB6194,$14A90D0568E0831F,$D8D05DAA2A159B36,$121A10F149690AD2,$3A9CCA89499E883C,$B958B6EE1F413233,$D5778139E9FF1F7D,$F4BCF6ABBADEB175
      Data.q $98D8B02DA63B88F4,$6F4004B9ACD67D78,$647A7488BA000819,$12EC18148871D1C3,$DBD20E3B33DFD09B,$ECB012BF8E7280BE,$7FCCF00DFF334407,$AB4CB89CE724EC00,$E212620EA1A1915C,$976F8E62D2B1EC15
      Data.q $59AEAF833AD64F71,$8D1ED3044759C57A,$A9ED95D794F5CFB4,$147C99F04A96C904,$66D17E510414C994,$219F3D22140C2968,$E48CD2333C1327A5,$C126E8B40C482B1F,$BA331143340D45A8,$4ACF3478EC143070
      Data.q $4B8BCBEA67812CE0,$70641D60BA5A7512,$0BC58434A07090AE,$445E047E3A9A00C8,$B5DAED7CB7979798,$E54A846B359ACFF7,$8D6EDDB9EBD138C3,$5CB5AF2C822CFBEC,$6881FC4F49F6FDFB,$7BE8633198CAC939
      Data.q $FF284CC9ECDE6F36,$75DDCC8E3C69991D,$55E68D1A32E75DD7,$5D2D568820BD56AB,$1678A0209EF0042A,$BBDEF8D1312EDDD9,$00EFECB780606B31,$3441160A380BEF40,$F596A2620F5D1B66,$A00495F6391358E4
      Data.q $F6DA4FA461B4F527,$ECBE1A4D31F6F15C,$915FFB41042B1555,$E01253EA76B9F0B9,$63D64C5DD8CF1CFD,$717167E27B3C0403,$E58FB97C60123BF1,$7CBB39B49BBC3E1C,$6E9B4DA6E3470E63,$FE0582C17AB5F721
      Data.q $F67B3D8439CA3440,$B6F1EE78E6899AF4,$9831A6C6C684E336,$B381D5F08D6704A8,$909DE779DC562447,$EFF21ABDF7EC929C,$B3DE321AE07BF49A,$CBBB046CECC05A3A,$0305D0E0EC17DA08,$5A1D4971C10C971B
      Data.q $DBF13174F5A3EBC9,$0C2E93B7BE4DBD6F,$AAFA0E6745CF91D5,$DF2B8FD5AB509DD5,$4E2E1D812D300EA3,$4EB46A5651AAE0D7,$09C1A623AB76DC09,$51A338102B1AA557,$7644D2ABCA4BC3B1,$EC979FA1621EA684
      Data.q $A6F42ACA75D24F8E,$D31E42D1505C1B94,$0F28DF5420F2AFB1,$27F900A6FD7F2187,$66DE50890909282E,$7E9C3BB028CCD486,$057F0FABE418A79E,$B56474CD33F96F13,$41B56CC0E6E5C039,$A341A2E312099B4B
      Data.q $D27188E0B58FC356,$3F07A9B4C16ECBFD,$78330F3CADA6B65D,$BAE85890C322BB59,$5FD276327AFF43FA,$17981733990D57DE,$838C8006D98E4AFE,$276CF807F998DA93,$4D3F701B90AFC879,$2F61216C5DA6B4C0
      Data.q $0FE4C55BBDC03A76,$ED4217CCFD0B1D97,$93A263E936E57FCA,$C532828C9AF79E38,$F2D4D4B0563982B6,$FE7B767FF64F3A4E,$280CCE332FDE7BCF,$00CE3323152F9DC1,$2D073D01C5A0EA17,$F49BB5E30105B5F5
      Data.q $18E3BD41B4578C56,$0E4C504457CB3809,$5375B42CC2C72566,$E7543E815173A4B3,$06C90AD58C08CE01,$20EE49CCEBE4AC6E,$B8ECBD8A04AD20AA,$40195837C92500E8,$207FB01B2C63C4AB,$52667131313EA320
      Data.q $9326751F1228D252,$291E013519089589,$10DB80997E2F178B,$6E0A650DE7658464,$DD304AEAB4919F79,$AC6C950261309959,$410321CEE3CEB75B,$6C361B0200129AD4,$9696EFF656565158,$7953EA483C721296
      Data.q $9E881241053A1041,$FFC9AFB64B7F7641,$3B7980261D47F537,$34FF05E88137CC01,$EF819DCDE9A147D9,$6E73BC4FB39194AE,$2A7BFE6B39A7F5FF,$A9D63D5DF7D594C6,$5E468B89D0AAB3F0,$8994210C00E76DBB
      Data.q $B0041CE50EAFFA96,$300202FB7DBEDBAE,$34E7C95E4822E1CB,$CCD6BEE42DE08192,$C78D131FD73F3F9F,$FD657AB358E72B7A,$0409B48EB82D374D,$48736742F712D94B,$1A45FCC169B98EDB,$26A454A1E3B94ABA
      Data.q $D1D09E3C41212201,$6E732D3ADB27CB70,$9AF2DB75BAD991BC,$26120B38C8F39AEA,$5CBFC20C94ABB820,$D32D0033B98D7EB7,$C702BC9483E80EFA,$BDE02A98A91D6B23,$34E0CD3BCF1AAF77,$293EFB82C7409555
      Data.q $B7E90ACF4C1510FA,$79334540B52CEFEB,$23D61C0C792F9F64,$D9B30D74BA2926ED,$007A545015E26C0C,$E00ED1AA54D48242,$1BA075DACAD22F51,$57A40B955D461532,$88D5A06793DB06F0,$C7E0A3A2E2063A20
      Data.q $9DAF43613121D458,$7E4FCAC7A3CAD3F7,$08209350E4F3ECF5,$57B4E92E786D065D,$F53494179ECD6544,$1FCE9B27ABD4F0B6,$38B81FE8581038DC,$EFF5805A46BC0077,$C7F956AAE192AF00,$1A15C68009B30069
      Data.q $045AD59B4282E597,$C65C03255A924D2A,$05F77C4F09BD9A03,$32ED08759459B685,$829A004A1D172A0B,$F88AC47ECBA00969,$804EE5C28338CBE0,$681881E107118336,$A3E9E117D770AEA1,$CD2044CD8FA705E6
      Data.q $07715071BA30EC48,$D2B363D032254F5E,$5433AC191A667461,$92145940CB51ACFB,$36703EF1080B14A8,$0E93A8D00533C10E,$077B4B7A2CC051D6,$0F0DD24956582205,$AEAEA5C0EAD89678,$2A8D31187B11A50E
      Data.q $ECECECDA7FAC6782,$AB52ACC10E98E4E9,$501ED667CA51B32C,$B4A8ECA6A032FBCB,$8D13233C10DE5070,$659E652572B95FD7,$FD7D7D616179693F,$AB9F455AB6B6B6D8,$004B1744C2BAA624,$125DDEC970EB7FBA
      Data.q $D187497FFCBF4688,$024CED7B7ABFF6AE,$9D76EC9FAEF34B6C,$9ED8A9172AE1967F,$4038C73716FB44FA,$BCCE9FD3681EF19D,$925D210E00F36B76,$E323232635FA9073,$258FC127929292B1,$74DD37D5E8833F6B
      Data.q $0A0A0A26D8D10513,$BD101109131A203C,$101B37CDF4F737B8,$499F6FF1E1707EA0,$9A9EC461DA634F4F,$44C4C58E7DF72B3F,$F4FA75A0F43E0F0B,$07EFE8D612EE7F69,$9CFAA1B48A3A76EF,$A7782FAD4D0F0984
      Data.q $1EF3BBB8FC1C0A54,$8D4C9A739D3EB020,$84CBF5812A3B3EA7,$B3B2B23DFC7A6299,$0599A9A86EF83821,$5BB606B1603535B5,$0918CD8831DF6EFC,$369D20A524B4D271,$7D5371AF9C2C0870,$F504868402525A74
      Data.q $712900EDB1A11BFE,$7D86C34420B27FA3,$0CA987398B83D6FD,$E3BC1285E56531BA,$DACF7F192F3FA6DC,$D0012776DFC7122B,$D715A07766207E3B,$2FFEF1221F77805E,$01A200DC29674404,$DA00965C97944062
      Data.q $7906EE38102D6C6A,$EBD8461EC8051F21,$8145FB428E932CD7,$A50A3288A6922820,$B2002828385E43F4,$C0127A33DA11072C,$6B0045AD62460416,$BE0173C559C16968,$7EBE4B271CB9C702,$7062F23C16C34FFB
      Data.q $C836C3228221D8C6,$A56D162A09779A00,$B3EFA8EA6C9437C8,$2BCD2D006419FBC2,$5088B86F2CF00A72,$4010B91575E2A24C,$76CB33C112AB9B23,$6C330D841414B695,$37D0AAE80491B0D8,$100A0264785C9316
      Data.q $1D2481BE0465832C,$C86BA44CCB28589E,$6D0700A78FC7E3AF,$EDDC169CA2B170EE,$E2011B79B3660B76,$0E497A7359055E72,$002EEC823D1025C8,$17D1CC7206D95171,$F25F5CD6D9CECED7,$5DB997EB0D4CEFEA
      Data.q $D27D9BAAB8647F35,$45B578E67183777E,$0DFFD4A083AEA550,$E5C96C309450584F,$2B01039CA9D04060,$1D93ED45C2945347,$817F1B8DC6C3470E,$D2E6E6E744D40E72,$F7E1E1E1D1332DFA,$5EAEAEAA1CA4A4A7
      Data.q $FF1F171C496C7D0A,$4FF834F7BFEFFBED,$2693639F7DDBD426,$3F7F5D64CBB8FE4D,$E525450457CDC174,$D9FECAE25C4FC584,$BDDDC707F5D296BE,$B2A33057A7F23AE7,$7D7616BC1AB554C3,$C5F0CC815650501E
      Data.q $8989892DBD59F828,$0DEB68D4777B64AD,$D428D8658A31A346,$F40CB24B56806102,$A12BE79547CCC58B,$A42472311851D8E0,$7061E1DDFE89A6A6,$E0924585042CECAE,$544C4255CE670E1F,$F3D35680C7C62424
      Data.q $FA210371A6449B9F,$7FAB43CD7B2D2AB0,$E4D4B77F93E965B5,$2C85E913DCDEC6A3,$DD46FB92F5F338E5,$F9027D60EA97CEFA,$DC0583AE532BB5BF,$0D783807EFEB0025,$39E0274FFC24EDC0,$FB72F9B86A716BFE
      Data.q $5109219707430CB2,$4623CDF76E09F6B0,$19920C9445A365A4,$D0A016CE4BCC0305,$A2C4D0F059DEA2D7,$E16280CCE74791F3,$5E05F3A9655E7820,$86BD3A7BC55E4AB8,$7F92CBF77962CDB1,$EC64BF67908028EC
      Data.q $B9C2DF3AA46567ED,$E264F5BC364ABB9C,$2520BA3462BF1984,$B03A9D1777806460,$CE27494297B3FF27,$DC52C0C8C337ECC8,$8C05C281DF38BB77,$077975696A684B96,$6A3AAC30C12FDE12,$019AAD1A3257D5CC
      Data.q $50FA7952C1711A4F,$C763B1C9862EDB57,$87D3D3D3E7D3A40A,$2B704683F423C2E3,$E7FA7F67BA40E203,$51F72B60C94421F6,$77BBD80CC6633D67,$3264C8F8B8D1052F,$16BBC0DFC540447D,$BFC3D7183947E841
      Data.q $7F61FF97E8D107B5,$C82CE1B25D0220DC,$AEB0CE9A9FBFA7DD,$26DA1002ED67785B,$9F6923E62F4D8230,$D83078E094131DBE,$C0DA4BAB01644C00,$BCAAEEA7C3D5BAF1,$84CE07395FA7E30C,$535F3B1D63D7D7D4
      Data.q $013F3D174A6E8353,$9287394689A8D132,$DC79FCFE7D104689,$576D7D1BB4926567,$928B81D0F8783B4E,$F9965D03A1D0E795,$59EFB65CE6803BF6,$7512E3C9E15DF84D,$9193FBAED2BB6951,$36B2E5C2CC0882B4
      Data.q $1262055F2D4F1B9A,$E2D30384A5F41B15,$654C1B10156C9B9A,$DD9FA4CF90AB1715,$F1F92B4C6C5691D3,$A905B9A9AEBE441E,$1A3E64A631F47F63,$383EFF60791B1B13,$863233AB6524F275,$DADB5A40CA832D90
      Data.q $560B1D1F406561C0,$1714900D9A1A1DBB,$3665AFB3DB152A03,$D8CD769E13C8880D,$C53E87D53382B2FA,$92F7C5E00DE86FE0,$C64FF3FB6CB07140,$BDEF83BAE6E5BB8E,$C1F059C7FB3623DE,$02DED937F807ECD7
      Data.q $CD6FCFBBABB23171,$4304FD53731D3D96,$B8CAED1187956A54,$C3FE6856FABA6C8D,$264E2F098EEF272B,$62DF07BF625DD76F,$274AF89A6E5C2BE6,$4044DF3A805C0EFD,$A6F6705BC3EAF6F4,$B9B1835F7C64AAFD
      Data.q $6355EE9FB600039E,$2FDDB69C6319B7DB,$52E974B2C919DB5D,$E6AA0624B3B76EC6,$8D5169696AA399CC,$05C3F02E126A351A,$07B7ED03C8ED5D42,$2C6C6C7EE557CAD1,$1111118DBADD6EB7,$F7BDEF76BC680479
      Data.q $170B85F88282823A,$681C33528A4B37F6,$4BAAFBBF8E3BB5A4,$F0011BB6988C482D,$65CA2EFFE455B82B,$DAB36495B4EA1CAB,$725B410D6B9E64B8,$D86A1B3BC6D23A95,$1973B4A09AA5E1D0,$03B7CA7B5971BC57
      Data.q $C8E4797EEDDB8CD1,$56543A919C1C2A91,$F812F1D498B55555,$52EC9A20C97C1281,$6C94E0E23A5A0739,$511F85ADD5D5D5DF,$4B2FBAC8DFC66956,$9CA7522213979CD6,$C0CCA34AFB2CD041,$43FEAC973735286E
      Data.q $88D869C987CDB9EB,$D3B01DDDF07A3A5A,$E2F695044CD6A1EF,$4F7E576ECF04513E,$E02151D4AB695FEF,$F6972E5C08642EFA,$964499326083A1F0,$935DA10B3346D8C9,$E0EC3A95A4EC0528,$1D4AF5E0C181072F
      Data.q $0B9DE64D98346A39,$B8E857A9799FCC16,$54735A2E69CC7709,$D809F426A064DDE0,$E62FEC663689BF25,$2CB9CF076AFC9CB4,$4F79BB595A2E5830,$CF9FBA842E8E01FF,$5FAE984758BA65C9,$E848F148D81D87F5
      Data.q $7462FBB0B409F7C2,$F7745C3BA7A6FE90,$B8ADADADB01F07C1,$63636C6E03060CA9,$468D59EB2B2B26A3,$8308C04B1C71C213,$F2B1F7D8F3CF39CC,$4DCA2EF51055DF86,$024F6A121344CCF9,$A95796596795E2BC
      Data.q $3715F016AD5A8254,$480473D959597BFC,$731E24F246464637,$7F1858585C515151,$94B83AE60FF7FDFF,$5C5D593749731040,$93B71919199DDC5C,$E929F858585059FA,$99CE07E0592F11F3,$B49A4D26E36AD5A1
      Data.q $673399C27333333C,$AED225F87C3E1E56,$F856A40060639CBA,$6F79ECA6063401E1,$8F809CBB19890B4F,$DBD3E6F600CD9764,$883DAE647DD74B9A,$C3F597E074CADDC6,$948CD4D8DCC6EBEE,$1676037087493FCA
      Data.q $18236ECD8A912946,$4C7799EF477605DE,$FA515101111E12D2,$8200399C8D47A39D,$EDD7201EE2AB3C8F,$32C1E2FB06121A1D,$7467D94D00248008,$468D19536B6B68E0,$59B3D9B366AF8FBA,$AE78B2B56AD6162C
      Data.q $4086E3581164E9D3,$993E536A5600009A,$6012CB05069924E5,$0848485BA08009E6,$59008F286868426E,$44445B3DC3C3C2DE,$C3F0FC3DCEFE4F04,$2CDDD0041DFB60FC,$D734875E0C177B38,$6385F9E4C16F7425
      Data.q $BA5AFB8E2D1016D2,$E2051474D007A3F1,$C643E022A938A202,$D24E836C87A85905,$6634814EE8020F81,$8D8D6B5BE7E8CAA1,$B06583B70C1FCE89,$60CB065832C1960C,$66006017FF97B1F9,$00FF9D8CE3371072
      Data.q $AE444E4549000000
      Data.b $42,$60,$82
      etoolbariconstrip:
    EndDataSection
  CompilerEndIf
  CompilerEndIf

EndModule


CompilerIf Defined(ToolBarStandardButton, #PB_Function)=0
  Macro ToolBarStandardButton(hBtn,hIcon,Mode=#PB_ToolBar_Normal,Text="")
    PVX::ToolBarStandardButton(hBtn,hIcon,Mode,Text)
  EndMacro
CompilerEndIf




UseModule PVX





; IDE Options = PureBasic 6.00 LTS (Windows - x64)
; CursorPosition = 113
; FirstLine = 31
; Folding = FfAACE5BAAAAAgAAAB25
; Optimizer
; EnableXP
; DPIAware
; Executable = C:\Users\Paul\Desktop\New folder\tst5.exe
; CompileSourceDirectory
; Compiler = PureBasic 6.00 LTS - C Backend (Windows - x64)
; iOSAppOrientation = 0
; AndroidAppOrientation = 0