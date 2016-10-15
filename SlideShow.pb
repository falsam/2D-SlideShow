EnableExplicit

Enumeration Window
  #MainForm  
EndEnumeration

Enumeration Gadget
  #Previous
  #Next
EndEnumeration

Global Event
Global Width, Height
Global Dim Images(4), PreviousImage, CurrentImage, NextImage, x, Count, Flag = #PB_Ignore, Increment = 50, Direction

Declare FirstImage()
Declare PreviousImage()
Declare NextImage()
Declare LastImage()

InitSprite() 
InitKeyboard()
InitMouse()
UseJPEGImageDecoder()

;Quelles sont les dimensions de la fenetre
ExamineDesktops()
Width = DesktopWidth(0)
Height = DesktopHeight(0)

;Affichage de la fenetre
OpenWindow(#MainForm, 0, 0, Width, Height, "FlipBoard", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)

ButtonGadget(#Previous, 10, WindowHeight(#MainForm) - 38, 80, 22, "Previous")
ButtonGadget(#Next, 100, WindowHeight(#MainForm) - 38, 80, 22, "Next")

OpenWindowedScreen(WindowID(0), 0, 0, Width, Height, #True, 0, 40)

;Chargement des images
For x = 0 To 4
  Images(x) = LoadSprite(#PB_Any, "images/image" + x + ".jpg")
  ZoomSprite(Images(x), Width, Height)
Next

;Premiere image
FirstImage()

;Boucle evenementielle
Repeat   
  Repeat
    Event = WindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Previous : PreviousImage()
          Case #Next : NextImage()
        EndSelect
        
      Case #PB_Event_CloseWindow
        End
    EndSelect  
  Until Event=0
  
  ;Les images peuvent défiler à gauche (Direction  = -1) ou à droite (Direction = 1)
  If Flag = #Previous Or Flag = #Next
    x + Increment * Direction
    
    If Abs(x) > Width
      x = 0
      Flag = #PB_Ignore
      
      CurrentImage = Images(Count)
    EndIf
  EndIf
  
  ;Affichage des images
  ClearScreen(RGB(0, 0, 0))
  DisplaySprite(CurrentImage, -x, 0)
  
  If flag = #Previous
    DisplaySprite(PreviousImage, (Width + x) * -1, 0)
  EndIf
  
  If flag = #Next
    DisplaySprite(NextImage, Width - x, 0)
  EndIf
  
  ;Defilement des pages avec le clavier
  ExamineKeyboard()
  If KeyboardReleased(#PB_Key_Home) 
    FirstImage()
  EndIf
  
  If KeyboardReleased(#PB_Key_Left)
    PreviousImage()
  EndIf
  
  If KeyboardReleased(#PB_Key_Right)
    NextImage()
  EndIf
  
  If KeyboardReleased(#PB_Key_End)
    LastImage()
  EndIf
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)

Procedure FirstImage()
  Count = 0
  CurrentImage = Images(0)
  NextImage = Images(1)  
EndProcedure

Procedure PreviousImage()
  If Count > 0
    Flag = #Previous
    Direction = -1
    Count - 1 
    PreviousImage = Images(Count)
  EndIf  
EndProcedure

Procedure NextImage()
  If Count < ArraySize(Images())
    Flag = #Next
    Direction = 1
    Count + 1
    NextImage = Images(Count)
  EndIf   
EndProcedure

Procedure LastImage()
  Count = ArraySize(Images())
  PreviousImage = Images(Count-1)
  CurrentImage = Images(Count)  
EndProcedure
; IDE Options = PureBasic 5.50 (Windows - x86)
; CursorPosition = 27
; Folding = ---
; EnableXP