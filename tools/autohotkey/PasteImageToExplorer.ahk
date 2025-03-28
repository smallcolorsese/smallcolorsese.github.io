#Persistent
#SingleInstance
#InstallMouseHook
#InstallKeybdHook
#KeyHistory  499
~^v::
    if(PastePicToDir.CLIPBOARD_ISPIC)
        PastePicToDir.pastePic()
    return
;检测粘贴板变化和数据类型
OnClipboardChange:
{
    PastePicToDir.CLIPBOARD_ISPIC:=A_EventInfo=2?true:false
    return
}
;----------------------------------------------------------------------------------------------------------操作类
Class  PastePicToDir
{
    ;是图片还是其他类型
    static CLIPBOARD_ISPIC:=false
    ;Func 粘贴图片到文件夹
    pastePic()
    {
        ;获取当前文件夹句柄
         desDir:=Handle.Explorer_GetPath() "\ahk_" Util.getTimeStr() ".png"
         if(InStr(desDir, "Error"))
             return
        ;改变鼠标形态
        Util.SetSystemCursor()
        path:=Util.save_pic(desDir)
        Util.RestoreCursors()
        return
    }
}
;----------------------------------------------------------------------------------------------------------操作类
;----------------------------------------------------------------------------------------------------------实现获取当前句柄类
Class Handle
{
    Explorer_GetPath(hwnd="") ;调用该方法就可以获取当前句柄
    {
            If !(window := this.Explorer_GetWindow(hwnd))
                Return  "Error"
            If (window="desktop")
                Return A_Desktop
            path := window.LocationURL
            path := RegExReplace(path, "ftp://.*@","ftp://")
            StringReplace, path, path, file:///
            StringReplace, path, path, /, `\, All
            ;Return path
            ; thanks to polyethene
            Loop
                If RegExMatch(path, "i)(?<=%)[da-f]{1,2}", hex)
                    StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
                Else Break
            Return path
    }
    Explorer_GetAll(hwnd="")
    {
        Return this.Explorer_Get(hwnd)
    }
    Explorer_GetSelected(hwnd="")
    {
          Return this.Explorer_Get(hwnd,true)
    }
    Explorer_GetWindow(hwnd="")
      {
        ; thanks to jethrow for some pointers here
        WinGet, Process, ProcessName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
        WinGetClass class, ahk_id %hwnd%
        If (Process!="explorer.exe")
            Return
        If (class ~= "(Cabinet|Explore)WClass")
          {
            for window in ComObjCreate("Shell.Application").Windows
            If (window.hwnd==hwnd)
                Return window
          }
        Else If (class ~= "Progman|WorkerW")
            Return "desktop" ; desktop found
      }
    Explorer_Get(hwnd="",selection=false)
      {
        If !(window := this.Explorer_GetWindow(hwnd))
            Return ErrorLevel := "Error"
        If (window="desktop")
        {
          ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
          If !hwWindow ; #D mode
              ControlGet, hwWindow, HWND,, SysListView321, A
          ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
          base := SubStr(A_Desktop,0,1)=="" ? SubStr(A_Desktop,1,-1) : A_Desktop
          Loop, Parse, files, `n, `r
            {
              path := base "" A_LoopField
              IfExist %path% ; Ignore special icons like Computer (at least for now)
                  ret .= path "`n"
            }
        }
        Else
        {
          If selection
              collection := window.document.SelectedItems
          Else
              collection := window.document.Folder.Items
          for item in collection
          ret .= item.path "`n"
        }
        Return Trim(ret,"`n")
    }
}
;----------------------------------------------------------------------------------------------------------实现获取当前句柄类
;----------------------------------------------------------------------------------------------------------Util类
class Util
{
    ;保存图片到临时文件夹并返回文件
    save_pic(filename:="")
    {
        imageUtil.gdiplusStartup() ;开始GDI
        pBitmap:=imageUtil.from_clipboard()
;        msgBox % "pBitmap:" pBitmap
        if(pBitmap<0) ;获取粘贴板数据
            return ;
        if(!filename)
            filename:=A_temp "\ahk_ocr_" A_YYYY "-" A_MM "-" A_DD "-" A_Hour "-" A_Min "-" A_Sec ".png"
        filename:=imageUtil.put_file(pBitmap,filename)
        imageUtil.gdiplusShutdown() ;关闭GDI
        return filename
    }
    ;获取时间的字符串 yyyy-MM-dd HH:mm:ss
    getTimeStr()
    {
      return A_YYYY "-" A_MM "-" A_DD "_" A_Hour "-" A_Min "-" A_Sec
    }
    ;Func 设置鼠标指针形态为忙等待
    SetSystemCursor()
    {
        IDC_ARROW := 32512
        hCursor  := DllCall( "LoadCursorFromFile", "Str", "C:\Windows\Cursors\aero_working.ani")
        DllCall("SetSystemCursor", "UInt", hCursor, "Int", IDC_ARROW)
    }
    ;Func 设置鼠标指针形态为正常形态
    RestoreCursors()
    {
        SPI_SETCURSORS := 0x57
        DllCall("SystemParametersInfo", "UInt", SPI_SETCURSORS, "UInt", 0, "UInt", 0, "UInt", 0)
    }
}
;----------------------------------------------------------------------------------------------------------Util类
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++图像操作类
class imageUtil{
    ;获取粘贴板数据返回bitmap的指针 pBitmap ，非图片时报错
    from_clipboard() {
      ; Open the clipboard with exponential backoff.
      loop
         if DllCall("OpenClipboard", "ptr", A_ScriptHwnd)
            break
         else
            if A_Index < 6
               Sleep (2**(A_Index-1) * 30)
            else throw Exception("Clipboard could not be opened.")
      ; Fallback to CF_BITMAP. This format does not support transparency even with put_hBitmap().
      if !DllCall("IsClipboardFormatAvailable", "uint", 2)
      {
        DllCall("CloseClipboard")
         return -1
       }
      if !(hbm := DllCall("GetClipboardData", "uint", 2, "ptr"))
      {
         DllCall("CloseClipboard")
         return -2
      }
      DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", pBitmap:=0)
      DllCall("DeleteObject", "ptr", hbm)
      DllCall("CloseClipboard")
      return pBitmap
    }
    ;缩放图片传入bitmap的指针，scale缩放 [200,200] 或者1.5倍
    BitmapScale(ByRef pBitmap, scale) {
      if not (IsObject(scale) && ((scale[1] ~= "^\d+$") || (scale[2] ~= "^\d+$")) || (scale ~= "^\d+(\.\d+)?$"))
         throw Exception("Invalid scale.")
      ; Get Bitmap width, height, and format.
      DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", width:=0)
      DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", height:=0)
      DllCall("gdiplus\GdipGetImagePixelFormat", "ptr", pBitmap, "int*", format:=0)
      if IsObject(scale) {
         safe_w := (scale[1] ~= "^\d+$") ? scale[1] : Round(width / height * scale[2])
         safe_h := (scale[2] ~= "^\d+$") ? scale[2] : Round(height / width * scale[1])
      } else {
         safe_w := Ceil(width * scale)
         safe_h := Ceil(height * scale)
     }
      ; Avoid drawing if no changes detected.
      if (safe_w = width && safe_h = height)
         return pBitmap
      ; Create a new bitmap and get the graphics context.
      DllCall("gdiplus\GdipCreateBitmapFromScan0"
               , "int", safe_w, "int", safe_h, "int", 0, "int", format, "ptr", 0, "ptr*", pBitmapScale:=0)
      DllCall("gdiplus\GdipGetImageGraphicsContext", "ptr", pBitmapScale, "ptr*", pGraphics:=0)
      ; Set settings in graphics context.
      DllCall("gdiplus\GdipSetPixelOffsetMode",    "ptr", pGraphics, "int", 2) ; Half pixel offset.
      DllCall("gdiplus\GdipSetCompositingMode",    "ptr", pGraphics, "int", 1) ; Overwrite/SourceCopy.
      DllCall("gdiplus\GdipSetInterpolationMode",  "ptr", pGraphics, "int", 7) ; HighQualityBicubic
      ; Draw Image.
      DllCall("gdiplus\GdipCreateImageAttributes", "ptr*", ImageAttr:=0)
      DllCall("gdiplus\GdipSetImageAttributesWrapMode", "ptr", ImageAttr, "int", 3) ; WrapModeTileFlipXY
      DllCall("gdiplus\GdipDrawImageRectRectI"
               ,    "ptr", pGraphics
               ,    "ptr", pBitmap
               ,    "int", 0, "int", 0, "int", safe_w, "int", safe_h ; destination rectangle
               ,    "int", 0, "int", 0, "int",  width, "int", height ; source rectangle
               ,    "int", 2
               ,    "ptr", ImageAttr
               ,    "ptr", 0
               ,    "ptr", 0)
      DllCall("gdiplus\GdipDisposeImageAttributes", "ptr", ImageAttr)
      ; Clean up the graphics context.
      DllCall("gdiplus\GdipDeleteGraphics", "ptr", pGraphics)
      DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
      return pBitmap := pBitmapScale
    }
    ;把bitmap输出为文件的 bitmap指针（pBitmap） ，filepath:目标位置 比如 c:\xx.png，返回文件位置
    put_file(pBitmap, filepath := "", quality := "") {
      ; Thanks tic - https://www.autohotkey.com/boards/viewtopic.php?t=6517
      extension := "png"
      imageUtil.select_codec(pBitmap, extension, quality, pCodec, ep, ci, v)
      ; Write the file to disk using the specified encoder and encoding parameters with exponential backoff.
      loop
         if !DllCall("gdiplus\GdipSaveImageToFile", "ptr", pBitmap, "wstr", filepath, "ptr", pCodec, "ptr", (ep) ? &ep : 0)
            break
         else
            if A_Index < 6
               Sleep (2**(A_Index-1) * 30)
            else throw Exception("Could not save file to disk.")
      return filepath
    }
    select_codec(pBitmap, extension, quality, ByRef pCodec, ByRef ep, ByRef ci, ByRef v) {
        ; Fill a buffer with the available image codec info.
        DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", count:=0, "uint*", size:=0)
        DllCall("gdiplus\GdipGetImageEncoders", "uint", count, "uint", size, "ptr", &ci := VarSetCapacity(ci, size))
        ; struct ImageCodecInfo - http://www.jose.it-berater.org/gdiplus/reference/structures/imagecodecinfo.htm
        loop {
           if (A_Index > count)
              throw Exception("Could not find a matching encoder for the specified file format.")
           idx := (48+7*A_PtrSize)*(A_Index-1)
        } until InStr(StrGet(NumGet(ci, idx+32+3*A_PtrSize, "ptr"), "UTF-16"), extension) ; FilenameExtension
        ; Get the pointer to the clsid of the matching encoder.
        pCodec := &ci + idx ; ClassID
        ; JPEG default quality is 75. Otherwise set a quality value from [0-100].
        if (quality ~= "^-?\d+$") and ("image/jpeg" = StrGet(NumGet(ci, idx+32+4*A_PtrSize, "ptr"), "UTF-16")) { ; MimeType
           ; Use a separate buffer to store the quality as ValueTypeLong (4).
           VarSetCapacity(v, 4), NumPut(quality, v, "uint")
           ; struct EncoderParameter - http://www.jose.it-berater.org/gdiplus/reference/structures/encoderparameter.htm
           ; enum ValueType - https://docs.microsoft.com/en-us/dotnet/api/system.drawing.imaging.encoderparametervaluetype
           ; clsid Image Encoder Constants - http://www.jose.it-berater.org/gdiplus/reference/constants/gdipimageencoderconstants.htm
           VarSetCapacity(ep, 24+2*A_PtrSize)            ; sizeof(EncoderParameter) = ptr + n*(28, 32)
              NumPut(    1, ep,            0,   "uptr")  ; Count
              DllCall("ole32\CLSIDFromString", "wstr", "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", "ptr", &ep+A_PtrSize, "uint")
              NumPut(    1, ep, 16+A_PtrSize,   "uint")  ; Number of Values
              NumPut(    4, ep, 20+A_PtrSize,   "uint")  ; Type
              NumPut(   &v, ep, 24+A_PtrSize,    "ptr")  ; Value
        }
     }
   ;开始GDI
   gdiplusStartup()
   {
        DllCall("LoadLibrary", "str", "gdiplus")
        VarSetCapacity(si, A_PtrSize = 4 ? 16:24, 0) ; sizeof(GdiplusStartupInput) = 16, 24
           NumPut(0x1, si, "uint")
        DllCall("gdiplus\GdiplusStartup", "ptr*", pToken:=0, "ptr", &si, "ptr", 0)
   }
   ;关闭GDI释放内存
   gdiplusShutdown()
   {
       DllCall("gdiplus\GdiplusShutdown", "ptr", pToken)
       DllCall("FreeLibrary", "ptr", DllCall("GetModuleHandle", "str", "gdiplus", "ptr"))
   }
}
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++图像操作类

