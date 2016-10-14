ScriptName ctd_Config Extends SKI_ConfigBase
{Main CTD Configuration Script}

ctd_PlayerAlias Property PlayerAlias Auto
ctd_MainQuest Property QuestAlias Auto
ctd_MeterWidget Property Meter Auto

bool Property bModActive = False Auto Hidden
bool Property bToxicityActive = True Auto Hidden
bool Property bIModEnabled = True Auto Hidden
bool Property bAddictionActive = True Auto Hidden
float Property fIModMin = 50.0 Auto Hidden
float Property fIModMax = 300.0 Auto Hidden
float Property fToxicityMultiplier = 1.0 Auto Hidden
float Property fToxicityMaximum = 30.0 Auto Hidden
float Property fPotencyMultiplier = 0.5 Auto Hidden
float Property fPotencyMaximum = 15.0 Auto Hidden
float Property fToxicityDecay = 0.2500002 Auto Hidden
float Property fAddictionSpeed = 0.5 Auto Hidden
float property fAddictionThreshold = 0.0 Auto Hidden
bool Property bShowMeter = False Auto Hidden
float Property fMeterAlpha = 100.0 Auto Hidden
float Property fMeterX = 640.0 Auto Hidden
float Property fMeterY = 700.0 Auto Hidden
bool Property bShowMessages = True Auto Hidden
bool Property bCureDiseasePotionsAreToxic = True Auto Hidden

float Property fUpdateInterval = 0.5 AutoReadOnly

float Property PoisonResistance
	float Function Get()
		float fPoisionResist = PlayerAlias.akPlayer.GetActorValue("PoisonResist") / 100.0
		if fPoisionResist > 1
			return 1
		endif
		return fPoisionResist
	EndFunction
EndProperty

int Function GetVersion()
	Return 1 ; Last version
EndFunction

Function ToggleMeter(bool on = False)
	if (on)
		Meter.Alpha = fMeterAlpha
	else
		Meter.Alpha = 0.0
	endif
EndFunction


Event OnConfigInit()
	{Called when this config menu is initialized}
	ModName = "Chasing the Dragon"

	ToggleMeter(False)

	; Creating pages
	Pages = new string[2]
	Pages[0] = "General"
	Pages[1] = "Inventory"
EndEvent

Event OnPlayerLoadGame()
EndEvent

Event OnVersionUpdate(int version)
	{Called when a version update of this script has been detected}
EndEvent

Event OnPageReset(string page)
	{Called when a new page is selected, including the initial empty page}
	if (!page)
		LoadCustomContent("ctd/ctd_logo.dds", 201, 37)
		return
	else
		UnloadCustomContent()
	endIf

	; Building General page...
	If (page == "General")
		SetCursorPosition(0)
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("General Settings")
		AddToggleOptionST("CTD_ACTIVE_TOGGLE", "Chasing the Dragon Active", bModActive)			
		AddTextOption("Current Toxicity", PlayerAlias.fToxicityLevel as string)
		AddTextOption("Current Addiction", QuestAlias.GetState() as string)
		AddTextOption("Current Satisfaction", (QuestAlias.fSatisfaction * 24.0) as string)

		AddHeaderOption("Toxicity Settings")
		AddToggleOptionST("CTD_TOXICITY_TOGGLE", "Enable Alchemical Toxicity", bToxicityActive)		
		AddSliderOptionST("CTD_TOXICITY_MULTIPLIER", "Global Toxicity Multiplier", fToxicityMultiplier, "{1}x")
		AddSliderOptionST("CTD_TOXICITY_MAXIMUM", "Maximum Potion Toxicity", fToxicityMaximum, "{1}%")
		AddSliderOptionST("CTD_TOXICITY_DECAY", "Toxicity Decay Half-life", fToxicityDecay * 24.0, "{1} Hours")
		AddToggleOptionST("CTD_CURE_DISEASE_IS_TOXIC", "Cure Disease Potions are Toxic", bCureDiseasePotionsAreToxic)

		AddHeaderOption("Addiction Settings")
		AddToggleOptionST("CTD_ADDICTION_TOGGLE", "Enable Alchemical Addiction", bAddictionActive)		
		AddSliderOptionST("CTD_ADDICTION_THRESHOLD", "Addiction Toxicity Threshold", fAddictionThreshold, "{1}%")
		AddSliderOptionST("CTD_POTENCY_MULTIPLIER", "Global Potency Multiplier", fPotencyMultiplier, "{1}x")
		AddSliderOptionST("CTD_POTENCY_MAXIMUM", "Maximum Potion Potency", fPotencyMaximum, "{1}%")	
		AddSliderOptionST("CTD_ADDICTION_PROGRESSION", "Addiction Progression Speed", fAddictionSpeed * 24, "{1} hours")	

		SetCursorPosition(1)
		AddHeaderOption("Widget Meter")
		AddToggleOptionST("CTD_METER", "Enable HUD Toxicity Meter", bShowMeter)
		AddSliderOptionST("CTD_METER_X", "Meter X Position", fMeterX, "{1}")
		AddSliderOptionST("CTD_METER_Y", "Meter Y Position", fMeterY, "{1}")
		AddSliderOptionST("CTD_METER_OPACITY", "Meter Opacity", fMeterAlpha, "{1}%")

		AddHeaderOption("Text Messages")
		AddToggleOptionST("CTD_TEXT_TOGGLE", "Toggle Text Notifications", bShowMessages)

		AddHeaderOption("Widget Meter")		
		AddToggleOptionST("CTD_IMOD_TOGGLE", "Enable Visual Toxicity Effect", bIModEnabled)
		AddSliderOptionST("CTD_IMOD_MIN", "Effect Start", fIModMin, "{1}%")
		AddSliderOptionST("CTD_IMOD_MAX", "Effect Max", fIModMax, "{1}%")
		Return
	ElseIf (page == "Inventory")
		Return	
	EndIf
EndEvent

Function MessageActivation()
	if (bModActive)
		Debug.Notification("Chasing the Dragon is active...")
		Debug.Notification("Toxicity Active: "+(bToxicityActive as string))
		Debug.Notification("Addiction Active: "+ (bAddictionActive as string))			
	else
		Debug.Notification("Chasing the Dragon is inactive...")
	endif		
EndFunction

state CTD_ACTIVE_TOGGLE
	event OnSelectST()
		bModActive = !bModActive
		if (bModActive)
			PlayerAlias.GoToState("Active")
			MessageActivation()
		else
			PlayerAlias.ClearToxicity()
			QuestAlias.ClearAddiction()
			PlayerAlias.GoToState("Inactive")
			QuestAlias.GoToState("Clean")
			MessageActivation()
		endif
		SetToggleOptionValueST(bModActive)		
	endEvent

	event OnDefaultST()
		bModActive = false
		SetToggleOptionValueST(bModActive)	
	endEvent

	event OnHighlightST()
	endEvent
endState

state CTD_TOXICITY_TOGGLE
	event OnSelectST()
		bToxicityActive = !bToxicityActive
		if (bToxicityActive && bModActive)
			PlayerAlias.GoToState("Active")
		else
			PlayerAlias.ClearToxicity()
			PlayerAlias.GoToState("Inactive")
		endif		
		SetToggleOptionValueST(bToxicityActive)
	endEvent

	event OnDefaultST()
		bToxicityActive = false
		SetToggleOptionValueST(bToxicityActive)	
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable alchemical addiction")
	endEvent
endState

state CTD_TEXT_TOGGLE
	event OnSelectST()
		bShowMessages = !bShowMessages
		SetToggleOptionValueST(bShowMessages)		
	endEvent

	event OnDefaultST()
		bShowMessages = false
		SetToggleOptionValueST(bShowMessages)	
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable the toxicity visual effect.")
	endEvent
endState

state CTD_IMOD_TOGGLE
	event OnSelectST()
		bIModEnabled = !bIModEnabled
		SetToggleOptionValueST(bIModEnabled)		
	endEvent

	event OnDefaultST()
		bIModEnabled = false
		SetToggleOptionValueST(bIModEnabled)	
	endEvent

	event OnHighlightST()
		SetInfoText("Enable or disable the toxicity visual effect.")
	endEvent
endState

state CTD_CURE_DISEASE_IS_TOXIC
	event OnSelectST()
		bCureDiseasePotionsAreToxic = !bCureDiseasePotionsAreToxic
		SetToggleOptionValueST(bCureDiseasePotionsAreToxic)		
	endEvent

	event OnDefaultST()
		bCureDiseasePotionsAreToxic = True
		SetToggleOptionValueST(bCureDiseasePotionsAreToxic)	
	endEvent

	event OnHighlightST()
		SetInfoText("Toggle toxicity for potions with the Cure Disease effect. If this is set Cure Disease potions will cause Toxicity effects and trigger Addiction chance (meaning if you drink one it might cure your addiction and then immediately cause you to become addicted again... drinking potions to cure potion addiction was never a good plan). Default True.")
	endEvent
endState

state CTD_METER
	event OnSelectST()
		bShowMeter = !bShowMeter
		SetToggleOptionValueST(bShowMeter)

		ToggleMeter(bShowMeter)

		Meter.WidgetName 	= "CTD Meter"
		Meter.FillDirection = "right"
		Meter.PrimaryColor 	= 0xC8FFC8
		Meter.SecondaryColor = 0x00FF00
		Meter.FlashColor 	= 0xFFFFFF
		Meter.HAnchor 		= "center"
		Meter.VAnchor 		= "center"
		Meter.Width  		= 225.2
		Meter.Height 		= 12.5
		Meter.X 			= fMeterX
		Meter.Y 			= fMeterY
	endEvent

	event OnDefaultST()
		bShowMeter = false
		ToggleMeter(bShowMeter)
		SetToggleOptionValueST(bShowMeter)	
	endEvent

	event OnHighlightST()
		SetInfoText("Show Chasing the Dragon HUD Meter")
	endEvent
endState

state CTD_METER_X
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fMeterX)
		SetSliderDialogDefaultValue(215.0)
		SetSliderDialogRange(0.0, 1280.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fMeterX = value
		Meter.X = value
		SetSliderOptionValueST(value, "{1}")
	EndEvent

	Event OnHighlightST()
	EndEvent
endState

state CTD_METER_Y
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fMeterY)
		SetSliderDialogDefaultValue(215.0)
		SetSliderDialogRange(0.0, 720.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fMeterY = value
		Meter.Y = value
		SetSliderOptionValueST(value, "{1}")
	EndEvent

	Event OnHighlightST()
	EndEvent
endState

state CTD_METER_OPACITY
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fMeterAlpha)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	EndEvent

	Event OnSliderAcceptST(float value)
		Meter.Alpha = value
		fMeterAlpha = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
	EndEvent
endState

state CTD_ADDICTION_THRESHOLD
	Event OnSliderOpenST()
		SetSliderDialogStartValue(0.0)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	EndEvent

	Event OnSliderAcceptST(float value)
		fAddictionThreshold = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Alchemical addiction toxicity threshold. This defines the minimum toxicity required before it is possible to suffer an alchemical addiction. Default 0% (no threshold).")
	EndEvent
endState

state CTD_ADDICTION_PROGRESSION
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fAddictionSpeed * 24.0)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.5, 24.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fAddictionSpeed = value / 24.0
		SetSliderOptionValueST(value, "{1} Hours")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Alchemical addiction progression rate. This is the number of hours before an alchemical addiction progresses to the next stage. Default 12 Hours.")
	EndEvent
endState

state CTD_IMOD_MIN
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fIModMin)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(10)
	EndEvent

	Event OnSliderAcceptST(float value)
		fIModMin = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Toxicity level at which the visual effect begins to ease in. Default 50%.")
	EndEvent
endState

state CTD_IMOD_MAX
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fIModMax)
		SetSliderDialogDefaultValue(300.0)
		SetSliderDialogRange(100.0, 1000.0)
		SetSliderDialogInterval(50)
	EndEvent

	Event OnSliderAcceptST(float value)
		fIModMax = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Toxicity level at which the visual effect is at maximum. The greater the difference between this value and the minimum value the smoother the ease in. Default 300%.")
	EndEvent
endState

state CTD_TOXICITY_MULTIPLIER
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fToxicityMultiplier)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.1)
	EndEvent

	Event OnSliderAcceptST(float value)
		fToxicityMultiplier = value
		SetSliderOptionValueST(value, "{1}x")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Global multiplier for potion toxicity. At 1X a 10g potion has a toxicity of 10 and it scales logarithmically (e.g. 10g = 10 toxicity, 100g = 20 toxicity, 1000g = 30 toxicity)")
	EndEvent
endState

state CTD_TOXICITY_MAXIMUM
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fToxicityMaximum)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fToxicityMaximum = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Global maximum for toxicity. Potions with calcluated toxicity above this value will use this value instead.")
	EndEvent
endState

state CTD_TOXICITY_DECAY
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fToxicityDecay * 24.0)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.5, 24.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fToxicityDecay = value / 24.0
		SetSliderOptionValueST(value, "{1} Hours")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Half-life for toxicity decay. This is the amount of time it takes in game hours for your toxicity to decay by 50%.")
	EndEvent
endState

state CTD_POTENCY_MULTIPLIER
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fPotencyMultiplier)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.1)
	EndEvent

	Event OnSliderAcceptST(float value)
		fPotencyMultiplier = value
		SetSliderOptionValueST(value, "{1}x")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Global multiplier for potion potency. At 0.5X a 10g potion has a potency of 5 and it scales logarithmically (e.g. 10g = 5 potency, 100g = 10 potency, 1000g = 20 potency)")
	EndEvent
endState

state CTD_POTENCY_MAXIMUM
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fPotencyMaximum)
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	EndEvent

	Event OnSliderAcceptST(float value)
		fPotencyMaximum = value
		SetSliderOptionValueST(value, "{1}%")
	EndEvent

	Event OnHighlightST()
		SetInfoText("Global maximum for potency. Potions with calcluated potency above this value will use this value instead.")
	EndEvent
endState