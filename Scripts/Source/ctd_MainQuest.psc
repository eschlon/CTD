Scriptname ctd_MainQuest extends Quest  
{Chasing the Dragon monitoring quest}

ctd_Config Property Config Auto
ctd_PlayerAlias Property PlayerAlias Auto
ctd_MeterWidget Property Meter Auto

spell Property AddictionStage1 Auto
spell Property AddictionStage2 Auto
spell Property AddictionStage3 Auto
spell Property AddictionStage4 Auto

message Property MessageStage0 Auto
message Property MessageStage1 Auto
message Property MessageStage2 Auto
message Property MessageStage3 Auto
message Property MessageStage4 Auto
message Property MessageUsing Auto

bool Property bIsAddicted = False Auto
float fProgressionProgress = 0.0

int iPrimaryColor = 0xFAC8FF
int iSecondaryColor = 0xFF0000

float _fSatisfaction = 0.0
float Property fSatisfaction
	float Function Get()
		return _fSatisfaction
	EndFunction
	Function Set(float value)
		if value > _fSatisfaction
			_fSatisfaction = value
			if (Config.bShowMeter)
				AdjustMeterSatisfaction()
			endif
			if (Config.bShowMessages)
				MessageUsing.Show()
			endif
		endif
	EndFunction
EndProperty

actor akPlayer
float fThen

Event OnInit()
	akPlayer = Game.GetPlayer()
EndEvent

Event OnPlayerLoadGame()
	akPlayer = Game.GetPlayer()
EndEvent

Function AdjustMeterSatisfaction()
	if (Config.bShowMeter)
		int secondaryColor = iSecondaryColor + Math.floor(255.0 * (fSatisfaction / 1.0))
		Meter.SetColors(iPrimaryColor, secondaryColor)
	endif
EndFunction

float Function ComputePotency(float Value)
	float Potency = 0
	if Value > 0
		Potency = (Math.Log(Value) / Math.Log(10)) * 10 * Config.fPotencyMultiplier
	endif
	if Potency > Config.fPotencyMaximum
		Potency = Config.fPotencyMaximum
	endif
	return Potency * (1.0 - Config.PoisonResistance)
EndFunction

Function PotionBender()
	if (bIsAddicted)
		self.GoToState("Euphoria")
	endif
EndFunction

Function HandleAddiction(float Value)
	if(Config.bAddictionActive && Config.fAddictionThreshold < PlayerAlias.fToxicityLevel)
		float Potency = ComputePotency(Value)

		if (!bIsAddicted && Utility.RandomFloat(0.0, 100.0) < Potency)
			bIsAddicted = True
			fThen = Utility.GetCurrentGameTime()			
			if (Config.bShowMeter)
				AdjustMeterSatisfaction()
			endif			
			self.GoToState("Euphoria")
		elseif (bIsAddicted)
			fSatisfaction = Utility.RandomFloat(0.25, 1.0) * (Potency / Config.fPotencyMaximum)
		endif
	endif
EndFunction

Function ClearAddiction()
		if (bIsAddicted)
			MessageStage0.Show()
		endif
		bIsAddicted = false
		akPlayer.RemoveSpell(AddictionStage1)
		akPlayer.RemoveSpell(AddictionStage2)
		akPlayer.RemoveSpell(AddictionStage3)
		akPlayer.RemoveSpell(AddictionStage4)
		self.UnregisterForUpdateGameTime()
		fProgressionProgress = 0.0
		_fSatisfaction = 0.0
		if (Config.bShowMeter)
			Meter.SetColors(0xC8FFC8, 0x00FF00)
		endif		
		self.GoToState("Clean")		
EndFunction

bool Function ProgressDisease(float fNow)
	_fSatisfaction -= (fNow - fThen)
	if fSatisfaction < 0.0
		fProgressionProgress -= _fSatisfaction
		_fSatisfaction = 0.0
	endif
	if (Config.bShowMeter)
		AdjustMeterSatisfaction()
	endif
	if (fProgressionProgress > Config.fAddictionSpeed)
		return True
	endif
	return False
EndFunction

Auto State Clean
	Event OnBeginState()
	EndEvent
	
	Event OnUpdateGameTime()
	EndEvent

	Event OnEndState()
	EndEvent
EndState

State Euphoria
	Event OnBeginState()
		fProgressionProgress = 0.0		
		MessageStage1.Show()
		akPlayer.AddSpell(AddictionStage1, False)
		akPlayer.RemoveSpell(AddictionStage2)
		akPlayer.RemoveSpell(AddictionStage3)
		akPlayer.RemoveSpell(AddictionStage4)
		self.RegisterForUpdateGameTime(Config.fUpdateInterval)
	EndEvent

	Event OnUpdateGameTime()
		float fNow = Utility.GetCurrentGameTime()
		if ProgressDisease(fNow)
			self.GoToState("Nephrosis")
		endif
		fThen = fNow
	EndEvent

	Event OnEndState()
		self.UnregisterForUpdateGameTime()
	EndEvent
EndState

State Nephrosis
	Event OnBeginState()
		fProgressionProgress = 0.0
		MessageStage2.Show()
		akPlayer.AddSpell(AddictionStage1, False)
		akPlayer.AddSpell(AddictionStage2, False)
		akPlayer.RemoveSpell(AddictionStage3)
		akPlayer.RemoveSpell(AddictionStage4)
		self.RegisterForUpdateGameTime(Config.fUpdateInterval)
	EndEvent

	Event OnUpdateGameTime()
		float fNow = Utility.GetCurrentGameTime()
		if ProgressDisease(fNow)
			self.GoToState("Catalepsy")
		endif
		fThen = fNow
	EndEvent

	Event OnEndState()
		self.UnregisterForUpdateGameTime()
	EndEvent
EndState

State Catalepsy
	Event OnBeginState()
		fProgressionProgress = 0.0
		MessageStage3.Show()
		akPlayer.AddSpell(AddictionStage1, False)
		akPlayer.AddSpell(AddictionStage2, False)
		akPlayer.AddSpell(AddictionStage3, False)
		akPlayer.RemoveSpell(AddictionStage4)
		self.RegisterForUpdateGameTime(Config.fUpdateInterval)
	EndEvent

	Event OnUpdateGameTime()
		float fNow = Utility.GetCurrentGameTime()		
		if ProgressDisease(fNow)
			self.GoToState("Marasmus")
		endif
		fThen = fNow
	EndEvent

	Event OnEndState()
		self.UnregisterForUpdateGameTime()
	EndEvent
EndState

State Marasmus
	Event OnBeginState()
		fProgressionProgress = 0.0
		MessageStage4.Show()
		akPlayer.AddSpell(AddictionStage1, False)
		akPlayer.AddSpell(AddictionStage2, False)
		akPlayer.AddSpell(AddictionStage3, False)
		akPlayer.AddSpell(AddictionStage4, False)
		self.RegisterForUpdateGameTime(Config.fUpdateInterval)
	EndEvent

	Event OnUpdateGameTime()
		float fNow = Utility.GetCurrentGameTime()		
		if ProgressDisease(fNow)
			ClearAddiction()
		endif
		fThen = fNow
	EndEvent

	Event OnEndState()
		self.UnregisterForUpdateGameTime()
	EndEvent
EndState