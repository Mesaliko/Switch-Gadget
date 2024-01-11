;- TOP

;.-------------------------------------------------------------------------------------------------
;|
;|  Title            : ModernSwitchGadget
;|  Version          : v0.9.1 Beta
;|  Author					 : Mesa
;|  Copyright        : 
;|                     
;|  PureBasic        : 5.70+
;|  
;|  Operating System : Windows (XP to W11+), Linux, MacOS
;|  Processor        : x86, x64
;|
;|  API							 : No api used
;|
;|-------------------------------------------------------------------------------------------------
;|
;|  Description      : Module Switch Gadget with a "modern" style + Tab key, Space key and focus
;|
;|  Forum Topic      : https://www.purebasic.fr/french/viewtopic.php?t=18876
;|                     https://www.purebasic.fr/english/viewtopic.php?t=80957
;|  Website          : 
;|
;|  Documentation    : 
;|
;|	Date 						 : 03/2023
;|
;|  Misc.						 : I confess to being inspired (in a shameless way) in large part by the robust 
;|										 code of Stargate's TabBar gadget. So, if you have analyzed his code then mine 
;|										 will be very easy to understand and improve.
;|
;.-------------------------------------------------------------------------------------------------


;.-------------------------------------------------------------------------------------------------
;|
;|  How to  use 		 : 1) Add UseModule ModernSwitchGadget		 
;|									 : 2) Add ModernSwitchGadget(...)
;|  			           : 3) Nothing else, except using the PB standard event type inside the loop : 
;|  				         : 		#PB_EventType_Change, #PB_EventType_Focus, #PB_EventType_LostFocus,
;| 												#PB_EventType_LeftClick, #PB_EventType_RightClick, 
;|												#PB_EventType_LeftDoubleClick, #PB_EventType_RightDoubleClick																																																																...
;|                     
;|  Color theme      : To add or modify a color theme
;|									 : -> Modify the Macro ModernSwitchGadget_UseColorTheme()
;|
;|  Selected gadget  : To modify the way the gadget is selected
;|										 -> Modify the Procedure ModernSwitchGadget_DrawFocus()
;|
;|	Shape						 : To modify the gadget shape
;|									 : 1) Add Constants and Modify the Structures if needed
;|									 : 2) Modify the procedure ModernSwitchGadget_Layout() if needed
;|									 : 3) Modify the Procedure ModernSwitchGadget_Update() if needed 
;|									 : 4) Modify the Procedure ModernSwitchGadget_Draw() 
;|
;.-------------------------------------------------------------------------------------------------


;.-------------------------------------------------------------------------------------------------
;|
;|  Gadget Attributes
;|  ================================================================
;|  		#ModernSwitchGadget_None 
;|  		#ModernSwitchGadget_Border						
;|  		#ModernSwitchGadget_Raised 
;|  		#ModernSwitchGadget_Vertical
;|  		#ModernSwitchGadget_Mirrored         
;|  		#ModernSwitchGadget_Disabled	
;|  	
;|  Gadget States
;|  =================
;|  		#ModernSwitchGadgetState_OFF
;|  		#ModernSwitchGadgetState_ON
;|  	
;|  Gadget Colors
;|  ================================================================
;|  		Theme colors
;|  		#ModernSwitchGadgetColor_Background									;
;|  		#ModernSwitchGadgetColor_ButtonOff
;|  		#ModernSwitchGadgetColor_ButtonOn
;|  		#ModernSwitchGadgetColor_Selected
;|  		#ModernSwitchGadgetColor_BackgroundDisabled
;|  		#ModernSwitchGadgetColor_ButtonDisabled
;|  		Current colors
;|  		#ModernSwitchGadgetColor_CurrentColorBackground
;|  		#ModernSwitchGadgetColor_CurrentColorButtonOn
;|  		#ModernSwitchGadgetColor_CurrentColorButtonOff
;|  		#ModernSwitchGadgetColor_CurrentColorSelected
;|
;| 	Gadget Events
;|  ================================================================
;|			=> Usefull PureBasic EventTypes
;|  			 #PB_EventType_Change, 
;|  			 #PB_EventType_Focus, 
;|  			 #PB_EventType_LostFocus
;|  			 
;|			-> Useless but working PureBasic EventTypes
;|				 #PB_EventType_LeftClick,  #PB_EventType_LeftDoubleClick 
;|				 #PB_EventType_RightClick, #PB_EventType_RightDoubleClick																																																																...
;|
;|  			 
;|	Procedures
;|  ================================================================
;|  UpdateModernSwitchGadget()
;|  FreeModernSwitchGadget()
;|  DisableModernSwitchGadget()
;|
;|  ModernSwitchGadget()
;|
;|  SetActiveModernSwitchGadget() 
;|  GetActiveModernSwitchGadget() 
;|	
;|  GetModernSwitchGadgetAttribute() 
;|	 
;|  SetModernSwitchGadgetData()
;|  GetModernSwitchGadgetData() 
;|	
;|  ChangeModernSwitchGadgetState() 
;|  SetModernSwitchGadgetState() 	
;|  GetModernSwitchGadgetState() 
;|	
;|  SetModernSwitchGadgetColor() 
;|  GetModernSwitchGadgetColor() 
;|  SetModernSwitchGadgetColors()
;|  SetModernSwitchGadgetColorTheme() 
;|  GetModernSwitchGadgetColorTheme()
;|
;.-------------------------------------------------------------------------------------------------


;.-------------------------------------------------------------------------------------------------
;|
;|  License Mesa.
;|  The license Mesa is, do what you like but make the World better, easier and enjoyable.
;|
;|
;|
;| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;| SOFTWARE.
;| 
;.-------------------------------------------------------------------------------------------------




;-  >M<  .:Declare Module:.
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯



DeclareModule ModernSwitchGadget
	
	CompilerIf #PB_Compiler_IsMainFile
		EnableExplicit
	CompilerEndIf
	
	
	
	;-.  1     .:Constantes:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	; Gadget Attributes
	EnumerationBinary Attributes
		#ModernSwitchGadget_None 
		#ModernSwitchGadget_Border						
		#ModernSwitchGadget_Raised 
		#ModernSwitchGadget_Vertical
		#ModernSwitchGadget_Mirrored         
		#ModernSwitchGadget_Disabled	
	EndEnumeration
	
	; Gadget States
	Enumeration States
		#ModernSwitchGadgetState_OFF
		#ModernSwitchGadgetState_ON
	EndEnumeration
	
	;Gadget Color Types
	Enumeration Color_Types
		;Theme colors
		#ModernSwitchGadgetColor_Background									;
		#ModernSwitchGadgetColor_ButtonOff
		#ModernSwitchGadgetColor_ButtonOn
		#ModernSwitchGadgetColor_Selected
		#ModernSwitchGadgetColor_BackgroundDisabled
		#ModernSwitchGadgetColor_ButtonDisabled
		;Current colors
		#ModernSwitchGadgetColor_CurrentColorBackground
		#ModernSwitchGadgetColor_CurrentColorButtonOn
		#ModernSwitchGadgetColor_CurrentColorButtonOff
		#ModernSwitchGadgetColor_CurrentColorSelected
	EndEnumeration
	
	; Gadget Events; No Public EventType 
	Enumeration Events #PB_EventType_FirstCustomValue
		#ModernSwitchGadget_EventType_Updated      ; The gadget has updated (internal)																						      
	EndEnumeration
	
	
	;-.  2     .:Structures:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	Structure ModernSwitchGadget_Layout
		;RoundedBox layout
		x.i			; The position and size of the RoundedBox in the current drawing output. 
		y.i
		w.i
		h.i
		arcx.i	;The radius of the rounded corners in the x and y direction. 
		arcy.i
		
		;Cicle button layout
		xc.i		; The position and size of the circle = button on/off
		yc.i
		r.i
	EndStructure
	
	Structure ModernSwitchGadget
		Number.i                          ; Gadget ID, position and size
		NumberDummyGadget.i								;	StringGadget with a size=0: Trick to use keyboard (Tab and Space keys)
		X.i
		Y.i
		W.i
		H.i
		W2.i															; W*2 used for antialiasing
		H2.i															; H*2	used for antialiasing
		Window.i													; Window parent ID
		ImageID.i													; Image twice as large as needed for antialiasing
		AAImageID.i												; Image will be scaled to the correct size while taking advantage of antialiasing
		DataValue.i												; Used with GadgetData()
		Attributes.i											; Attributes
		State.i														; 0=Left=OFF, 1=Right=ON
		Disabled.i												; 0=Enabled,  1=Disabled
		Focus.i														;	0=No Focus,	1=Focus
		ColorBackground.i									; Background Color
		ColorButtonOn.i										;	Button color when gadget is ON
		ColorButtonOff.i									; Button color when gadget is OFF
		ColorBackgroundDisabled.i					; Special color when the gadget is disabled
		ColorButtonDisabled.i							; Special color when the gadget is disabled
		ColorSelected.i										; Special color when the gadget is selected
		CurrentColorBackground.i					; Current colors
		CurrentColorButtonOn.i
		CurrentColorButtonOff.i
		CurrentColorButton.i
		CurrentColorSelected.i
		MarginButton.i										; Button margin on the left/right
		UpdatePosted.i										; 0=Do nothing, 1=Do a gadget update 																	; 	
		Events.i													; EventData() with a custom Event
		Layout.ModernSwitchGadget_Layout	; Layout
		ColorThemeName$
	EndStructure
	
	
	;-.  3     .:Initializations:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	; NOTHING... because there are NO GLOBAL variables
	; Everything is in the GadgetData
	; And "initializations" are made inside the Procedure ModernSwitchGadget()
	
	
	;-.  4a   .:Declaration Procedures:. 
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	;Update and redraw the gadget
	Declare.i UpdateModernSwitchGadget(Gadget.i)
	
	;Free the gadget
	Declare.i FreeModernSwitchGadget(Gadget.i)
	
	;Disable the gadget and change colors
	Declare.i DisableModernSwitchGadget(Gadget.i, Value.i)
	
	;Create the gadget
	Declare.i ModernSwitchGadget(Gadget, x, y, w, h, Attributes, Window, ColorTheme$="STANDARD")
	
	; 	Attributes:
	;   -----------	
	; 	#ModernSwitchGadget_None 
	; 	#ModernSwitchGadget_Border						
	; 	#ModernSwitchGadget_Raised 
	; 	#ModernSwitchGadget_Vertical
	; 	#ModernSwitchGadget_Mirrored 
	; 
	; 	ColorTheme$:
	;   ------------
	; 	"STANDARD"
	; 	"DARK"
	
	
	
	;Set active gadget.
	Declare.i SetActiveModernSwitchGadget(Gadget.i) 
	
	;Get wether active gadget.
	Declare.i GetActiveModernSwitchGadget(Gadget.i) 
	
	;Get an attribute value.
	Declare.i GetModernSwitchGadgetAttribute(Gadget.i, Attribute.i) 
	
	;Set/Change the data value of the gadget. 
	Declare.i SetModernSwitchGadgetData(Gadget.i, DataValue.i)
	
	;Get the data value of the gadget.
	Declare.i GetModernSwitchGadgetData(Gadget.i) 
	
	;Change the state of the gadget (ON/OFF).
	Declare.i ChangeModernSwitchGadgetState(Gadget.i, ChangeFocusState.i = #True) 
	
	;Set the state of the gadget (ON/OFF).
	Declare.i SetModernSwitchGadgetState(Gadget.i, State.i) 	
	
	;Get the state of the gadget.
	Declare.i GetModernSwitchGadgetState(Gadget.i) 
	
	;Set/Change gadget color by type
	Declare.i SetModernSwitchGadgetColor(Gadget.i, Type.i, ColorRGBA.i) 
	
	;Get gadget color by type
	Declare.i GetModernSwitchGadgetColor(Gadget.i, Type.i) 
	
	;Set/Change gadget all colors in once
	Declare.i SetModernSwitchGadgetColors(Gadget.i, ColorBackgroundRGBA.i, ColorButtonOffRGBA.i, ColorButtonOnRGBA.i, ColorSelectedRGBA.i)
	
	;Set/Change gadget color theme
	Declare.i SetModernSwitchGadgetColorTheme(Gadget.i, ColorTheme.s) 
	
	;Get color theme name
	Declare.s GetModernSwitchGadgetColorTheme(Gadget.i) 
	
EndDeclareModule





;-  >M<  .:Module:.
;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯


Module ModernSwitchGadget
	
	
	;-.  4b   .:Procedures & Macros:. 
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	;-.  4.1  .:Private procedures for internal calculations ! Not for use !:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	;StartDrawing
	Procedure.i ModernSwitchGadget_StartDrawing(*ModernSwitchGadget.ModernSwitchGadget)
		ProcedureReturn StartDrawing(ImageOutput(*ModernSwitchGadget\ImageID))
	EndProcedure
	
	;StopDrawing
	Procedure.i ModernSwitchGadget_StopDrawing(*ModernSwitchGadget.ModernSwitchGadget)
		StopDrawing()
	EndProcedure
	
	;AntiAliasing
	Procedure.i ModernSwitchGadget_Antialiasing(*ModernSwitchGadget.ModernSwitchGadget)
		
		With *ModernSwitchGadget 
			
			;Stop drawing because of the antialiasing which is made in resizing the image
			ModernSwitchGadget_StopDrawing(*ModernSwitchGadget)
			
			;Antialiasing by resizing the image
			\AAImageID=CopyImage(\ImageID,#PB_Any)
			ResizeImage(\AAImageID,\W,\H)
			
			ModernSwitchGadget_StartDrawing(*ModernSwitchGadget)
			
		EndWith
		
	EndProcedure
	
	;Layout
	Procedure.i ModernSwitchGadget_Layout(*ModernSwitchGadget.ModernSwitchGadget)
		
		If *ModernSwitchGadget\Disabled = #False
			
			Protected x, y, w, h, arcx, arcy, xc, yc, r
			
			With *ModernSwitchGadget
				
				x=0
				y=0
				w=\w2
				h=\h2
				
				Select \State
					Case #ModernSwitchGadgetState_OFF
						;OFF
						If (\Attributes & #ModernSwitchGadget_Vertical) * (\Attributes & #ModernSwitchGadget_Mirrored)
							arcx=\w:arcy=\w:xc=\w:yc=\h*2-\w:r=\w-\MarginButton					
						ElseIf 	\Attributes & #ModernSwitchGadget_Vertical
							arcx=\w:arcy=\w:xc=\w:yc=\w:r=\w-\MarginButton
						ElseIf \Attributes & #ModernSwitchGadget_Mirrored
							arcx=\h:arcy=\h:xc=\w*2-\h:yc=\h:r=\h-\MarginButton
						Else
							arcx=\h:arcy=\h:xc=\h:yc=\h:r=\h-\MarginButton
						EndIf
						
					Case #ModernSwitchGadgetState_ON
						;ON
						If \Attributes & #ModernSwitchGadget_Vertical * \Attributes & #ModernSwitchGadget_Mirrored
							arcx=\w:arcy=\w:xc=\w:yc=\w:r=\w-\MarginButton
						ElseIf \Attributes & #ModernSwitchGadget_Vertical
							arcx=\w:arcy=\w:xc=\w:yc=\h*2-\w:r=\w-\MarginButton
						ElseIf \Attributes & #ModernSwitchGadget_Mirrored
							arcx=\h:arcy=\h:xc=\h:yc=\h:r=\h-\MarginButton		
						Else
							arcx=\h:arcy=\h:xc=\w*2-\h:yc=\h:r=\h-\MarginButton
						EndIf
				EndSelect
				
				
				\Layout\x = x
				\Layout\y = y
				\Layout\w = w
				\Layout\h = h
				\Layout\arcx = arcx
				\Layout\arcy = arcy
				\Layout\xc = xc
				\Layout\yc = yc
				\Layout\r = r
				
			EndWith
			
		EndIf
		
	EndProcedure
	
	;Set Focus ON/OFF
	Procedure.i 	ModernSwitchGadget_SetFocus(*ModernSwitchGadget.ModernSwitchGadget, Focus.i = #True)
		
		With *ModernSwitchGadget
			
			Select  Focus
					
				Case #True
					\Focus = #True
					SetActiveGadget(\NumberDummyGadget)
					SetGadgetText(\NumberDummyGadget, "")
					
				Case #False
					\Focus = #False
					
			EndSelect
			
		EndWith
		
	EndProcedure
	
	;Events
	Procedure.i ModernSwitchGadget_Examine(*ModernSwitchGadget.ModernSwitchGadget)
		
		With *ModernSwitchGadget
			
			If \Disabled = #False
				Select EventType()
						
					Case #PB_EventType_LeftDoubleClick 
						\State = \State!1
						ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
						PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Change, 0)
						PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Focus, 0)
						
					Case #PB_EventType_LeftClick 
						\State = \State!1
						ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
						PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Change, 0)
						PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Focus, 0)
						
				EndSelect
			EndIf	
			
		EndWith
		
	EndProcedure
	
	;Internal gadget update
	Procedure.i ModernSwitchGadget_Update(*ModernSwitchGadget.ModernSwitchGadget) 
		
		With *ModernSwitchGadget
			
			;Colors
			If \Disabled
				\CurrentColorBackground = \ColorBackgroundDisabled
				\CurrentColorButtonOff = \ColorButtonDisabled
				\CurrentColorButtonOn = \ColorButtonDisabled
				\CurrentColorSelected = \ColorButtonDisabled
				If \State = #ModernSwitchGadgetState_OFF
					\CurrentColorButton = \ColorButtonDisabled
				Else
					\CurrentColorButton = \ColorButtonDisabled
				EndIf
			Else
				\CurrentColorBackground = \ColorBackground
				\CurrentColorButtonOff = \ColorButtonOff
				\CurrentColorButtonOn = \ColorButtonOn
				\CurrentColorSelected = \ColorSelected
				If \State = #ModernSwitchGadgetState_OFF
					\CurrentColorButton = \CurrentColorButtonOff
				Else
					\CurrentColorButton = \CurrentColorButtonOn
				EndIf
				
			EndIf
			
			;Layout
			ModernSwitchGadget_Layout(*ModernSwitchGadget)
			
			
			*ModernSwitchGadget\UpdatePosted = #False
			
		EndWith
		
	EndProcedure
	
	;Draw focus = Just draw a circle as focus
	Procedure.i ModernSwitchGadget_DrawFocus(*ModernSwitchGadget.ModernSwitchGadget)
		
		With *ModernSwitchGadget
			
			Circle(\Layout\xc,\Layout\yc,\Layout\r - DesktopScaledX(6), \CurrentColorSelected)
			
		EndWith
		
	EndProcedure
	
	;Draw the gadget
	Procedure.i ModernSwitchGadget_Draw(*ModernSwitchGadget.ModernSwitchGadget)
		
		With *ModernSwitchGadget
			
			DrawingMode(#PB_2DDrawing_AllChannels)
			RoundBox(\Layout\x,\Layout\y,\Layout\w,\Layout\h,\Layout\arcx,\Layout\arcy, \CurrentColorBackground)
			DrawingMode(#PB_2DDrawing_AlphaBlend)
			RoundBox(\Layout\x,\Layout\y,\Layout\w,\Layout\h,\Layout\arcx,\Layout\arcy,\CurrentColorBackground)
			Circle(\Layout\xc,\Layout\yc,\Layout\r,\CurrentColorButton)
			If \Focus
				ModernSwitchGadget_DrawFocus(*ModernSwitchGadget)	
			EndIf
			
			ModernSwitchGadget_Antialiasing(*ModernSwitchGadget)
			
			SetGadgetState(\Number, ImageID(\AAImageID));
			
			If IsImage(\AAImageID) 
				FreeImage(\AAImageID)
				\AAImageID = 0
			EndIf
			
		EndWith
		
	EndProcedure
	
	;Send an update event (used with Setters and Getters)
	Procedure.i ModernSwitchGadget_PostUpdate(*ModernSwitchGadget.ModernSwitchGadget) 
		
		If *ModernSwitchGadget\UpdatePosted = #False
			*ModernSwitchGadget\UpdatePosted = #True
			PostEvent(#PB_Event_Gadget, *ModernSwitchGadget\Window, *ModernSwitchGadget\Number, #ModernSwitchGadget_EventType_Updated, -1)
		EndIf
		
	EndProcedure
	
	;Keyboard Dummy gadget CallBack (hidden StringGadget onboard) => Tab Key and Spacebar
	Procedure.i ModernSwitchGadget_Keyboard_Callback()
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(EventGadget())
		
		If *ModernSwitchGadget = #Null
			ProcedureReturn
		EndIf
		
		
		With *ModernSwitchGadget
			
			Select EventType()
					
				Case #PB_EventType_Focus           
					ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Focus, 0)
					
					
				Case #PB_EventType_LostFocus        
					ModernSwitchGadget_SetFocus(*ModernSwitchGadget, #False)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_LostFocus, 0)
					
				Case #PB_EventType_Change          
					\State = \State!1
					ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
					ModernSwitchGadget_PostUpdate(*ModernSwitchGadget)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Change, 0)
			EndSelect
			
		EndWith
		
	EndProcedure
	
	;Callback
	Procedure.i ModernSwitchGadget_Callback() 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(EventGadget())
		
		If *ModernSwitchGadget = #Null
			ProcedureReturn
		EndIf
		
		If EventType() >= #PB_EventType_FirstCustomValue
			*ModernSwitchGadget\Events = EventData()
			
			Select EventType()
					
				Case #ModernSwitchGadget_EventType_Updated
					If ModernSwitchGadget_StartDrawing(*ModernSwitchGadget)
						ModernSwitchGadget_Update(*ModernSwitchGadget)
						ModernSwitchGadget_Draw(*ModernSwitchGadget)
						ModernSwitchGadget_StopDrawing(*ModernSwitchGadget)
					Else
						*ModernSwitchGadget\UpdatePosted = #False
					EndIf
					
			EndSelect
			
		Else
			
			If ModernSwitchGadget_StartDrawing(*ModernSwitchGadget)
				ModernSwitchGadget_Examine(*ModernSwitchGadget)
				ModernSwitchGadget_Update(*ModernSwitchGadget)
				ModernSwitchGadget_Draw(*ModernSwitchGadget)
				ModernSwitchGadget_StopDrawing(*ModernSwitchGadget)
			EndIf
			
		EndIf
		
	EndProcedure
	
	
	;-.  4.2  .:Public Procedures for the Gadget:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	
	;Update and redraw the gadget
	Procedure.i UpdateModernSwitchGadget(Gadget.i)
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		If ModernSwitchGadget_StartDrawing(*ModernSwitchGadget)
			ModernSwitchGadget_Update(*ModernSwitchGadget)
			ModernSwitchGadget_Draw(*ModernSwitchGadget)
			ModernSwitchGadget_StopDrawing(*ModernSwitchGadget)
		EndIf
		
	EndProcedure
	
	;Free the gadget
	Procedure.i FreeModernSwitchGadget(Gadget.i)
		
		If Not IsGadget(Gadget)
			ProcedureReturn
		EndIf
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With *ModernSwitchGadget
			
			SetGadgetData(Gadget, #Null)
			UnbindGadgetEvent(\Number, @ModernSwitchGadget_Callback())
			FreeGadget(Gadget)
			
			SetGadgetData(\NumberDummyGadget, #Null)
			UnbindGadgetEvent(\NumberDummyGadget, @ModernSwitchGadget_Keyboard_Callback())
			FreeGadget(\NumberDummyGadget)
			
			If \ImageID
				FreeImage(\ImageID)
			EndIf
			If \AAImageID
				FreeImage(\AAImageID)
			EndIf
			
			ClearStructure(*ModernSwitchGadget, ModernSwitchGadget)
			FreeMemory(*ModernSwitchGadget)
			
		EndWith
		
	EndProcedure
	
	;Disable the gadget and change colors
	Procedure.i DisableModernSwitchGadget(Gadget.i, Value.i)
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With	*ModernSwitchGadget
			
			Select Value
					
				Case 0
					\Disabled = 0
					
				Case 1
					\Disabled  = 1
					\Focus = #False
					
			EndSelect
			
		EndWith
		
		ModernSwitchGadget_PostUpdate(*ModernSwitchGadget)
		
	EndProcedure
	
	;Select the color theme
	Macro ModernSwitchGadget_UseColorTheme()
		
		Select UCase(ColorTheme$)
				
			Case "", "STANDARD"
				*ModernSwitchGadget\ColorBackground = $FFBC7000
				*ModernSwitchGadget\ColorButtonOn = $FFFFFFFF
				*ModernSwitchGadget\ColorButtonOff = $FFFFFFFF
				*ModernSwitchGadget\ColorBackgroundDisabled = $FF808080								;
				*ModernSwitchGadget\ColorButtonDisabled = $FFC0C0C0	
				*ModernSwitchGadget\ColorSelected = $FFBC7000
				
			Case "DARK"
				*ModernSwitchGadget\ColorBackground = $FF000000
				*ModernSwitchGadget\ColorButtonOn = $FFAAAAAA
				*ModernSwitchGadget\ColorButtonOff = $FFAAAAAA
				*ModernSwitchGadget\ColorBackgroundDisabled = $FF808080								;
				*ModernSwitchGadget\ColorButtonDisabled = $FFC0C0C0	
				*ModernSwitchGadget\ColorSelected = $FFFFFFFF
				
			Default
				;Like "", "STANDARD"
				*ModernSwitchGadget\ColorBackground = $FFBC7000
				*ModernSwitchGadget\ColorButtonOn = $FFFFFFFF
				*ModernSwitchGadget\ColorButtonOff = $FFFFFFFF
				*ModernSwitchGadget\ColorBackgroundDisabled = $FF808080								;
				*ModernSwitchGadget\ColorButtonDisabled = $FFC0C0C0
				*ModernSwitchGadget\ColorSelected = $FFBC7000
		EndSelect
		
	EndMacro
	
	;Create the gadget
	Procedure.i ModernSwitchGadget(Gadget, x, y, w, h, Attributes, Window, ColorTheme$="STANDARD")
		
		; 	Attributes:
		;   -----------	
		; 	#ModernSwitchGadget_None 
		; 	#ModernSwitchGadget_Border						
		; 	#ModernSwitchGadget_Raised 
		; 	#ModernSwitchGadget_Vertical
		; 	#ModernSwitchGadget_Mirrored 
		; 
		; 	ColorTheme$:
		;   ------------
		; 	"STANDARD"
		; 	"DARK"
		
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = AllocateMemory(SizeOf(ModernSwitchGadget))
		Protected Result.i, OldGadgetList.i, DummyGadget.i
		
		InitializeStructure(*ModernSwitchGadget, ModernSwitchGadget)
		OldGadgetList = UseGadgetList(WindowID(Window))
		
		;Create CheckBox gadget with a size=0: Trick To use keyboard (Tab And Space keys)
		DummyGadget = StringGadget(#PB_Any, -20, 0, 0, 0, "")
		
		;Create the gadget with attributes Border/Raised
		If Attributes & #ModernSwitchGadget_Border
			Result = ImageGadget(Gadget, X, Y, W, H, 0, #PB_Image_Border)
		ElseIf Attributes & #ModernSwitchGadget_Raised
			Result = ImageGadget(Gadget, X, Y, W, H, 0, #PB_Image_Raised)
		Else
			Result = ImageGadget(Gadget, X, Y, W, H, 0)
		EndIf
		
		UseGadgetList(OldGadgetList)
		If Gadget = #PB_Any
			Gadget = Result
		EndIf
		SetGadgetData(Gadget, *ModernSwitchGadget)
		SetGadgetData(DummyGadget, *ModernSwitchGadget)
		
		;Fills the structures
		With *ModernSwitchGadget
			
			;Gadget
			\Number = Gadget
			\NumberDummyGadget = DummyGadget
			\X = x
			\Y = y
			\W = w
			\H = h
			\W2 = w*2
			\H2 = h*2
			\Window = Window																						
			\Attributes = Attributes
			\ImageID =	CreateImage(#PB_Any,\W2,\H2,32,#PB_Image_Transparent)
			\MarginButton = DesktopScaledX(6)
			
			;Layout
			\Layout\x = \X
			\Layout\y = \Y
			\Layout\w = \W
			\Layout\h = \H
			
			;Theme
			\ColorThemeName$ = ColorTheme$
			
		EndWith
		
		;Color Theme
		ModernSwitchGadget_UseColorTheme()
		
		;Bind Dummy Gadget CallBack
		BindGadgetEvent(DummyGadget, @ModernSwitchGadget_Keyboard_Callback())
		;Bind Gadget CallBack
		BindGadgetEvent(Gadget, @ModernSwitchGadget_Callback())
		
		UpdateModernSwitchGadget(Gadget)
		
		
		ProcedureReturn Result
		
	EndProcedure
	
	
	;-.  4.3  .:Set & Get Procedures:.
	;¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
	
	;Set active gadget.
	Procedure.i SetActiveModernSwitchGadget(Gadget.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
		ModernSwitchGadget_PostUpdate(*ModernSwitchGadget)
		
	EndProcedure
	
	;Get wether active gadget.
	Procedure.i GetActiveModernSwitchGadget(Gadget.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		ProcedureReturn *ModernSwitchGadget\Focus
		
	EndProcedure
	
	
	;Get an attribute value.
	Procedure.i GetModernSwitchGadgetAttribute(Gadget.i, Attribute.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		Select Attribute
			Case 	#ModernSwitchGadget_Vertical,
			     	#ModernSwitchGadget_Border,						
			     	#ModernSwitchGadget_Raised, 
			     	#ModernSwitchGadget_Mirrored,         
			     	#ModernSwitchGadget_Disabled
				
				If *ModernSwitchGadget\Attributes & Attribute
					ProcedureReturn #True
				Else
					ProcedureReturn #False
				EndIf
				
			Default
				ProcedureReturn -1
				
		EndSelect
		
	EndProcedure
	
	;Set/Change the data value of the gadget. 
	Procedure.i SetModernSwitchGadgetData(Gadget.i, DataValue.i)
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		Protected *ModernSwitchGadget2.ModernSwitchGadget = GetGadgetData(*ModernSwitchGadget\NumberDummyGadget)
		
		*ModernSwitchGadget\DataValue = DataValue
		*ModernSwitchGadget2\DataValue = DataValue
		
	EndProcedure
	
	;Get the data value of the gadget.
	Procedure.i GetModernSwitchGadgetData(Gadget.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		ProcedureReturn *ModernSwitchGadget\DataValue
		
	EndProcedure
	
	;Change the state of the gadget (ON/OFF).
	Procedure.i ChangeModernSwitchGadgetState(Gadget.i, ChangeFocusState.i = #True) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With *ModernSwitchGadget
			
			Select \State
					
					;OFF->ON
				Case #ModernSwitchGadgetState_OFF
					\State = #ModernSwitchGadgetState_ON
					If ChangeFocusState
						ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
					EndIf
					
					;ON->OFF
				Case #ModernSwitchGadgetState_ON
					\State = #ModernSwitchGadgetState_OFF	
					If ChangeFocusState
						ModernSwitchGadget_SetFocus(*ModernSwitchGadget, #False)
					EndIf
					
			EndSelect
			
			ModernSwitchGadget_PostUpdate(*ModernSwitchGadget)
			PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Change, 0)
			PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Focus, 0)
			
		EndWith
		
	EndProcedure
	
	;Set the state of the gadget (ON/OFF).
	Procedure.i SetModernSwitchGadgetState(Gadget.i, State.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With *ModernSwitchGadget
			
			Select State
					
				Case #ModernSwitchGadgetState_OFF,#ModernSwitchGadgetState_ON
					\State = State	
					ModernSwitchGadget_SetFocus(*ModernSwitchGadget)
					ModernSwitchGadget_PostUpdate(*ModernSwitchGadget)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Change, 0)
					PostEvent(#PB_Event_Gadget, \Window, \Number, #PB_EventType_Focus, 0)				
					
			EndSelect
			
		EndWith
		
	EndProcedure
	
	;Get the state of the gadget.
	Procedure.i GetModernSwitchGadgetState(Gadget.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		ProcedureReturn *ModernSwitchGadget\State
		
	EndProcedure
	
	;Set/Change gadget color by type
	Procedure.i SetModernSwitchGadgetColor(Gadget.i, Type.i, ColorRGBA.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		Select Type
				
			Case #ModernSwitchGadgetColor_Background
				*ModernSwitchGadget\ColorBackground = ColorRGBA
			Case #ModernSwitchGadgetColor_ButtonOff
				*ModernSwitchGadget\ColorButtonOff = ColorRGBA
			Case #ModernSwitchGadgetColor_ButtonOn
				*ModernSwitchGadget\ColorButtonOn = ColorRGBA	
			Case #ModernSwitchGadgetColor_Selected
				*ModernSwitchGadget\ColorSelected = ColorRGBA
			Case 	#ModernSwitchGadgetColor_BackgroundDisabled
				*ModernSwitchGadget\ColorBackgroundDisabled = ColorRGBA
			Case #ModernSwitchGadgetColor_ButtonDisabled
				*ModernSwitchGadget\ColorButtonDisabled = ColorRGBA
				
		EndSelect
		
		ModernSwitchGadget_PostUpdate(GetGadgetData(Gadget))
		
	EndProcedure
	
	;Get gadget color by type
	Procedure.i GetModernSwitchGadgetColor(Gadget.i, Type.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		Select Type
				
				;Theme colors
			Case #ModernSwitchGadgetColor_Background
				ProcedureReturn *ModernSwitchGadget\ColorBackground
			Case #ModernSwitchGadgetColor_ButtonOff
				ProcedureReturn *ModernSwitchGadget\ColorButtonOff
			Case #ModernSwitchGadgetColor_ButtonOn
				ProcedureReturn *ModernSwitchGadget\ColorButtonOn
			Case #ModernSwitchGadgetColor_Selected	
				ProcedureReturn *ModernSwitchGadget\ColorSelected
			Case 	#ModernSwitchGadgetColor_BackgroundDisabled
				ProcedureReturn *ModernSwitchGadget\ColorBackgroundDisabled
			Case 	#ModernSwitchGadgetColor_ButtonDisabled
				ProcedureReturn *ModernSwitchGadget\ColorButtonDisabled
				
				;Current colors
			Case 	#ModernSwitchGadgetColor_CurrentColorBackground
				ProcedureReturn *ModernSwitchGadget\CurrentColorBackground
			Case  	#ModernSwitchGadgetColor_CurrentColorButtonOn
				ProcedureReturn *ModernSwitchGadget\CurrentColorButtonOn
			Case  	#ModernSwitchGadgetColor_CurrentColorButtonOff
				ProcedureReturn *ModernSwitchGadget\CurrentColorButtonOff
			Case  	#ModernSwitchGadgetColor_CurrentColorSelected
				ProcedureReturn *ModernSwitchGadget\CurrentColorSelected
				
		EndSelect
		
	EndProcedure
	
	
	;Set/Change gadget all colors in once
	Procedure.i SetModernSwitchGadgetColors(Gadget.i, ColorBackgroundRGBA.i, ColorButtonOffRGBA.i, ColorButtonOnRGBA.i, ColorSelectedRGBA.i)
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		*ModernSwitchGadget\ColorBackground = ColorBackgroundRGBA
		*ModernSwitchGadget\ColorButtonOff = ColorButtonOffRGBA
		*ModernSwitchGadget\ColorButtonOn = ColorButtonOnRGBA	
		*ModernSwitchGadget\ColorSelected = ColorSelectedRGBA
		
		ModernSwitchGadget_PostUpdate(GetGadgetData(Gadget))
		
	EndProcedure
	
	;Set/Change gadget color theme
	Procedure.i SetModernSwitchGadgetColorTheme(Gadget.i, ColorTheme.s) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With	*ModernSwitchGadget
			
			;Color Theme
			Select UCase(ColorTheme)	
				Case "", "STANDARD"
					\ColorThemeName$ = ColorTheme
					\ColorBackground = $FFBC7000
					\ColorButtonOn = $FFFFFFFF
					\ColorButtonOff = $FFFFFFFF
					\ColorBackgroundDisabled = $FF808080								;
					\ColorButtonDisabled = $FFC0C0C0
					\ColorSelected = $FFBC7000
					
				Case "DARK"
					\ColorThemeName$ = ColorTheme
					\ColorBackground = $FF000000
					\ColorButtonOn = $FFAAAAAA
					\ColorButtonOff = $FFAAAAAA
					\ColorBackgroundDisabled = $FF808080								;
					\ColorButtonDisabled = $FFC0C0C0
					\ColorSelected = $FFFFFFFF
					
				Default
					DebuggerError("Color Theme Unknown !")
					
			EndSelect
			
		EndWith
		
		ModernSwitchGadget_PostUpdate(GetGadgetData(Gadget))
		
	EndProcedure 
	
	;Get color theme name
	Procedure.s GetModernSwitchGadgetColorTheme(Gadget.i) 
		
		Protected *ModernSwitchGadget.ModernSwitchGadget = GetGadgetData(Gadget)
		
		With	*ModernSwitchGadget
			
			;Color Theme
			Select \ColorThemeName$
				Case "", "STANDARD",  "DARK"
					ProcedureReturn \ColorThemeName$
					
				Default
					;DebuggerError("Color Theme Unknown !")
					ProcedureReturn "Color Theme Unknown !"
			EndSelect
			
		EndWith
		
	EndProcedure 
	;- BOTTOM
	;- END
EndModule
;-


;- Example
CompilerIf #PB_Compiler_IsMainFile
	
	Enumeration 1
		#imgGadget
		#imgGadgetDARK
		#imgGadgetV
		#imgGadgetM
		#imgGadgetMV
		#imgGadgetDisabled
		#btn
	EndEnumeration
	
	Macro CheckerBoard(cb_imgIn,cb_szBlock) ; netmaestro 2023
		cb_chex = CreateImage(#PB_Any,2,2,24,#White)
		StartDrawing(ImageOutput(cb_chex))
		Plot(1,0,$C8C8C8):Plot(0,1,$C8C8C8)
		StopDrawing()
		ResizeImage(cb_chex,cb_szBlock*2,cb_szBlock*2,#PB_Image_Raw)
		StartVectorDrawing(ImageVectorOutput(cb_imgIn))
		VectorSourceImage(ImageID(cb_chex),255,cb_szBlock*2,cb_szBlock*2,#PB_VectorImage_Repeat)
		FillVectorOutput()
		StopVectorDrawing()
		FreeImage(cb_chex)
	EndMacro
	
	
	;Test DPI
	Define W
	ExamineDesktops()
	W=DesktopWidth(0)/2
	
	
	Define.i cb_bkgnd, cb_chex ; Checkerboard background
	
	If OpenWindow(0, 0, 0, W, 400, "ModernSwitchGadget Tests", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		; 	If OpenWindow(0, 0, 0, DesktopUnscaledX(W), DesktopUnscaledY(400), "ModernSwitchGadget Tests", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
		cb_bkgnd=CreateImage(#PB_Any,w,400)         ; checkerboard background
		checkerboard(cb_bkgnd,10)										;       "          "
		ImageGadget(0,0,0,w,400,ImageID(cb_bkgnd))	;       "          "
		DisableGadget(0,1)
		
		
		UseModule ModernSwitchGadget
		
		ModernSwitchGadget(#imgGadget, 10, 60, 60, 30, #ModernSwitchGadget_None,0);
		ModernSwitchGadget(#imgGadgetDARK,  10, 100, 60, 30, #ModernSwitchGadget_None,0,"DARK")
		ModernSwitchGadget(#imgGadgetV, 100, 60, 30, 60, #ModernSwitchGadget_Vertical,0)
		ModernSwitchGadget(#imgGadgetM, 10, 160, 60, 30, #ModernSwitchGadget_Mirrored,0)
		ModernSwitchGadget(#imgGadgetMV, 100, 160, 30, 60, #ModernSwitchGadget_Vertical|#ModernSwitchGadget_Mirrored,0)
		ModernSwitchGadget(#imgGadgetDisabled, 10, 200, 40, 20, #ModernSwitchGadget_None,0);
		
		ButtonGadget(#btn,10,240,60,30,"ok")
		
		
		GadgetToolTip(#imgGadget, "STANDARD")
		GadgetToolTip(#imgGadgetDARK, "DARK")
		GadgetToolTip(#imgGadgetV, "VERTICAL (and customized)")
		GadgetToolTip(#imgGadgetM, "MIRRORED")
		GadgetToolTip(#imgGadgetMV, "VERTICAL & MIRRORED")
		GadgetToolTip(#imgGadgetDisabled, "Disabled")
		
		SetActiveModernSwitchGadget(#imgGadget)
		
		DisableModernSwitchGadget(#imgGadgetDisabled, #True);ok
		
		SetModernSwitchGadgetColor(#imgGadgetV, #ModernSwitchGadgetColor_Background, $801977F3);ok
		SetModernSwitchGadgetColor(#imgGadgetV, #ModernSwitchGadgetColor_ButtonOn, $FF3FDC30)	 ;ok
		SetModernSwitchGadgetColor(#imgGadgetV, #ModernSwitchGadgetColor_ButtonOff, $800D26FF) ;ok
		SetModernSwitchGadgetColor(#imgGadgetV, #ModernSwitchGadgetColor_Selected, $806E2B5C)
		
		
		
		Define Event
		
		Repeat
			
			Event = WaitWindowEvent()
			
			Select Event
					
				Case #PB_Event_Gadget
					;- Events
					Select EventGadget()
						Case #imgGadget
							Select EventType()
									;No Test custom event => No public custom events
									
									;Test PB events
								Case #PB_EventType_Change
									Debug "#imgGadget Changed"
									Select GetModernSwitchGadgetState(#imgGadget)
										Case #ModernSwitchGadgetState_ON
											Debug "ON"
											DisableModernSwitchGadget(#imgGadgetDisabled, #False)
										Case #ModernSwitchGadgetState_OFF
											Debug "OFF"
											DisableModernSwitchGadget(#imgGadgetDisabled, #True)
									EndSelect
									
								Case #PB_EventType_LeftClick 
									;Debug "LeftClick";ok
									
								Case #PB_EventType_RightClick
									;Debug "RightClick";ok
									
								Case #PB_EventType_LeftDoubleClick
									;Debug "DoubleClick";ok
									
								Case #PB_EventType_RightDoubleClick
									;Debug "RightDoubleClick";ok
									
								Case #PB_EventType_Focus
									;Debug "Focus #imgGadget";ok
									
								Case #PB_EventType_LostFocus
									;Debug "LostFocus #imgGadget";ok
									
							EndSelect
							
						Case #btn
							Select EventType()
								Case #PB_EventType_LeftClick
									Debug "Button Left Click"		
							EndSelect
							
					EndSelect
			EndSelect
			
		Until Event = #PB_Event_CloseWindow
	EndIf
	
CompilerEndIf

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 18
; Folding = ------
; EnableAsm
; EnableXP
; CompileSourceDirectory