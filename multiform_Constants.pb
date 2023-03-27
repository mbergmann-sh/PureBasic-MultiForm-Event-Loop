;/ Created with PureVision64 v6.01 x64
;/ Mon, 27 Mar 2023 09:32:13
;/ by Michael Bergmann                





XIncludeFile "C:\PureVision64\Modules\Module_PVGadgets.pbi"

;- Required Image Decoders
UsePNGImageDecoder()



;- Global Variables and Constants
Global BubbleTipStyle=0
Global DPIfixX.d=DesktopResolutionX(),DPIfixY.d=DesktopResolutionY()
Define EventID,MenuID,GadgetID,WindowID

;- Window Constants
Enumeration 1
  #Window_FormSplash
  #Window_FormMAIN
EndEnumeration
#WindowIndex=#PB_Compiler_EnumerationValue


;- Gadget Constants
Enumeration 1
  ;Window_FormSplash
  #Gadget_FormSplash_Image
  #Gadget_FormSplash_Image3
  #Gadget_FormSplash_ButtonEXIT


  ;Window_FormMAIN
  #MenuBar_FormMAIN_Project
  #MenuBar_FormMAIN_splash
  #MenuBar_FormMAIN_about
  #MenuBar_FormMAIN_quit

  #Gadget_FormMAIN_ButtonINFO
  #Gadget_FormMAIN_ButtonOPEN


EndEnumeration
#GadgetIndex=#PB_Compiler_EnumerationValue


;- MenuBar Constants
Enumeration 1
  #MenuBar_FormMAIN
EndEnumeration
#MenuBarIndex=#PB_Compiler_EnumerationValue


;- Image Constants
Enumeration 1
  #Image_FormSplash_Image
  #Image_FormSplash_Image3


EndEnumeration
#ImageIndex=#PB_Compiler_EnumerationValue


;- Load Images
CatchImage(#Image_FormSplash_Image,?_OPT_FormSplash_Image)
CatchImage(#Image_FormSplash_Image3,?_OPT_FormSplash_Image3)


;- Resize Images for 'DPI aware executable'
ResizeImage(#Image_FormSplash_Image,ImageWidth(#Image_FormSplash_Image)*DPIfixX,ImageHeight(#Image_FormSplash_Image)*DPIfixY)
ResizeImage(#Image_FormSplash_Image3,ImageWidth(#Image_FormSplash_Image3)*DPIfixX,ImageHeight(#Image_FormSplash_Image3)*DPIfixY)


DataSection
  _OPT_FormSplash_Image:
  IncludeBinary "Images\gunni.png"
  _OPT_FormSplash_Image3:
  IncludeBinary "Images\wzAminetUploader.png"
EndDataSection


