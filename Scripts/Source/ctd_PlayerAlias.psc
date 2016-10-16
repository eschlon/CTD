Scriptname ctd_PlayerAlias extends ReferenceAlias  
{Alias for the Player Character}

ctd_MeterWidget Property Meter Auto
ctd_Config Property Config Auto
ctd_MainQuest Property QuestAlias Auto

float Property fMinimumToxicity = 0.05 AutoReadOnly

Spell Property ToxicityEffect Auto
Keyword Property VendorItemPotion Auto
MagicEffect Property Antidote Auto
MagicEffect Property CureDisease Auto
MagicEffect Property AlchCureDisease Auto
MagicEffect Property VigilantCureDisease Auto
Message Property ToxicityIncreasedMessage Auto
Message Property ToxicityDecreasedMessage Auto
Message Property ToxicityEffectMessage Auto
ImageSpaceModifier Property ToxicityIMod Auto

float _fToxicityLevel = 0.0
float Property fToxicityLevel
	float Function Get()
		return _fToxicityLevel
	EndFunction
	Function Set(float value)
		if (_fToxicityLevel != value)
			_fToxicityLevel = value
			UpdateMeter()
		endif
	EndFunction
EndProperty

float Property fToxicityPercent
	float Function Get()
		float fPercent = _fToxicityLevel / 100
		if fPercent > 1
			return 1
		endif
		return fPercent		
	EndFunction
EndProperty

Actor Property akPlayer Auto
float fThen
float fIModLevel = 0.0
bool bMonitoringToxicity = False

Event OnInit()
	akPlayer = Game.GetPlayer()
EndEvent

Event OnPlayerLoadGame()
	akPlayer = Game.GetPlayer()
EndEvent

Function UpdateMeter(bool flash = True)
	if (Config.bShowMeter)
		if (flash)
			Meter.StartFlash()
		endif
		Meter.SetPercent(fToxicityPercent)
	endif
EndFunction

bool Function isPotion(Potion akBaseItem)
	if (!akBaseItem)
		return False
	endif
	if (akBaseItem.HasKeyword(VendorItemPotion) && !akBaseItem.IsFood())
		return True
	endif
	return False
EndFunction

Function ClearToxicity()
	akPlayer.RemoveSpell(ToxicityEffect)
	bMonitoringToxicity = False
	fToxicityLevel = 0.0
	ToxicityIMod.Remove()
	self.UnregisterForUpdateGameTime()
	if (Config.bShowMessages)
		ToxicityDecreasedMessage.Show()
	endif
EndFunction

float Function ComputeToxicity(float Value)
	float Toxicity = 0
	if Value > 0
		Toxicity = (Math.Log(Value) / Math.Log(10)) * 10 * Config.fToxicityMultiplier
	endif
	if Toxicity > Config.fToxicityMaximum
		Toxicity = Config.fToxicityMaximum
	endif
	return Toxicity * (1.0 - Config.PoisonResistance)
EndFunction

Function HandleToxicity(float Value = 0.0)
	if (Config.bToxicityActive)
		
		if (Value)
			float Toxicity = ComputeToxicity(Value)
			fToxicityLevel += Toxicity
			if (fToxicityLevel && Config.bShowMessages)
				ToxicityIncreasedMessage.Show(Math.Ceiling(Toxicity), Math.Ceiling(fToxicityPercent * 100))
			endif
		endif

		ApplyIMod()

		if (fToxicityLevel > fMinimumToxicity)
			if (fToxicityLevel >= 100.00 && !akPlayer.HasSpell(ToxicityEffect))
				if (Config.bShowMessages)
					ToxicityEffectMessage.Show()
				endif
				akPlayer.AddSpell(ToxicityEffect, false)
				QuestAlias.PotionBender()
			elseif (fToxicityLevel < 100.0 && akPlayer.HasSpell(ToxicityEffect))
				akPlayer.RemoveSpell(ToxicityEffect)
			endif

			if (!bMonitoringToxicity)
				MonitorToxicity()
			endif
		else
			ClearToxicity()
		endif
	endif
EndFunction

Function ApplyIMod()
	if (Config.bIModEnabled && fToxicityLevel >= Config.fIModMin)
		float min = Config.fIModMin
		float max = Config.fIModMax
		float range = max - min

		if (range > 0)
			fIModLevel = (fToxicityLevel - min) / range
		else
			fIModLevel = 1.0
		endif

		if (fIModLevel > 1.0)
			fIModLevel = 1.0
		endif
		
		ToxicityIMod.PopTo(ToxicityIMod, fIModLevel)
	else
		ToxicityIMod.Remove()
		fIModLevel = 0.0
	endif
EndFunction

Form previousItem = None ; Need this to remove duplicate events

Function MonitorToxicity()
EndFunction

bool Function isToxic(Potion akBaseItem)
	Debug.trace(akBaseItem.getName())
	int iNumEffects = akBaseItem.getNumEffects()
	int n = 0
	while n < iNumEffects
		MagicEffect theEffect = akBaseItem.GetNthEffectMagicEffect(n)
		if (theEffect == Antidote)
			return False
		elseif (!Config.bCureDiseasePotionsAreToxic && (theEffect == AlchCureDisease || theEffect == CureDisease || theEffect == VigilantCureDisease))
			return False
		endif
		n += 1
	endwhile
	int i = 0
	int len = Config.asWhiteList.Length
	string name = akBaseItem.GetName()
	while (i < len)
		debug.trace(Config.asWhitelist[i])
		debug.trace(name)
		if (Config.asWhiteList[i] != "" && StringUtil.Find(name, Config.asWhiteList[i]) >= 0)
			return False
		endif
		i += 1
	endWhile

	return True
endFunction

int Function GetValue(Form akBaseItem)
	return akBaseItem.GetGoldValue()
EndFunction

bool Function isCrafting()
	if (UI.IsMenuOpen("Crafting Menu"))
		return True
	endif
	return False
endFunction

State Active

	Function MonitorToxicity()
		fThen = Utility.GetCurrentGameTime()
		self.RegisterForUpdateGameTime(Config.fUpdateInterval)
		bMonitoringToxicity = True
	EndFunction

	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		if(!akDestContainer && !akItemReference && isPotion(akBaseItem as Potion) && !isCrafting())
			if (akBaseItem == previousItem)
				previousItem = None
				return
			endif
			previousItem = akBaseItem

			if (isToxic(akBaseItem as Potion))
				int Value = GetValue(akBaseItem)	
				HandleToxicity(Value as float)
				QuestAlias.HandleAddiction(Value as float)
			endif
		endif
	EndEvent

	Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
		if (akEffect == Antidote)
			fToxicityLevel = 0.0
			HandleToxicity()
		endif

		if (akEffect == CureDisease || akEffect == VigilantCureDisease)
			QuestAlias.ClearAddiction()
		endif

		if (akEffect == AlchCureDisease)
			QuestAlias.ClearAddiction()
		endif

	EndEvent

	Event OnUpdateGameTime()
		float fNow = Utility.GetCurrentGameTime()
		fToxicityLevel *= Math.Pow(0.5,  ((fNow - fThen) / Config.fToxicityDecay))
		HandleToxicity()

		fThen = fNow
	EndEvent
EndState

State Inactive
EndState