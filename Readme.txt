

	C  H  A  S  I  N  G    T  H  E    D  R  A  G  O  N

	Because potions are sooooo goooood.

	- by ghenna (eschlon)

v 1.0 readme, last updated October 15, 2016

Contents
========

0. Updates 
1. Introduction
2. Obligatory Gratitude
3. Toxicity
4. Addiction
5. Requirements & Compatibility
6. Future Plans
7. WTF IS THE WIDGET TELLING ME!!

=== Updates ===

1.0 - Toxicity/Addiction will no longer trigger if you are in a crafting menu (Fixes issues with potion combination in PerMa, and similar)
    - Added option in MCM to toggle toxicity for Cure Disease potions
    - Added Whitelist menu page for fine-grained customization of what items are considered toxic (see below)

=== Introduction ===
Chasing the Dragon aims to add a level of immersion to the alchemy system by adding drawbacks and risks to potion use. Alchemy in Skyrim is simultaneously under and over powered. On the one hand, vanilla potion effects are not very impressive. On the other hand, nothing prevents the Dragonborn from hiding behind a rock and sucking down gallons of healing potions in the middle of a fight.

This mod is an attempt to fix the latter, adding consequences for potion abuse, but does nothing with respect to the former, as there are already a host of excellent mods out there that overhaul the Alchemy system, re-balance potion effects and add new effects. If you're using this mod I highly recommend checking out some of the alchemy mods here on the Nexus.

So what does it actually do? Chasing the Dragon adds two mechanics: Toxicity and Addiction. Specifics are discussed in the appropriate section below, and the experience is customizable via the an MCM menu.

=== Obligatory Gratitude ===
I'd like to thank BralorMarr on Nexus for his Toxicity Mod (not to mention his other great mods), which served as an inspiration for this work. He's a talented modder and I'm a noob. If you're just looking for a light-weight toxicity system and a bit of a different approach, I highly recommend his mod.

I'd also like to thank Chesko (of course) for so many awesome things, but mainly for his Frostfall / Wearable Lanterns widget code, which I use with attribution for the widget in this mod.

=== Toxicity ===
Toxicity is a measure of how dangerous it is to consume a given alchemical concoction. To maximize compatibility toxicity is calculated dynamically as a function of the potion's value. This means the mod doesn't actually care what kind of potion you're consuming, and thus should be maximally compatible with any mod that alters potion effects, modifies the alchemy skill or adds new potions to the game, assuming that the modder correctly added the potion keyword to any new potions. I opted to use potion value rather than some other, more interesting metric (BralrMarr's Toxicity uses an interesting combination of the number, type, magnitude and duration of the potion's effects), because I wanted the user to be able to get an idea of how toxic a given potion would be relatively easily, and value is easily visible in the UI and familiar.

As you consume potions the level of toxicity in your blood increases depending on the calculated toxicity of the potion consumed, and several global modifiers that can be tweaked in the MCM to customize your experience. Current toxicity can be viewed via the toxicity widget, by observing the immerseive cues or by opening the MCM menu.

Toxicity causes several things to happen.
- Above 50% your vision will become progressively more disrupted (i.e. green and blurry effect eases in)
- At 100% or greater toxicity you overdose, stopping all passive regen to health, magicka and stamina until your toxicity decreases below 100%

Reducing & Mitigating Toxicity
- Toxicity is mitigated directly by Poison Resistance, including resistance added via perks, magic, racial abilities, equipment, etc.
- Resist Poison potions contribute to toxicity resistance, but are themselves toxic.
- Cure Poison potions will reduce your toxicity to 0 and are not toxic or addictive (a somewhat happy consequence of them not being considered potions in Vanilla).
- Toxicity gradually diminishes over time, with a default half-life (i.e. current toxicity reduces by half) of 6 hours, configurable in the MCM.

=== Addiction ===
Potency is a measure of how likely it is that a user will form a dependency with a given alchemcial concoction. Potency is calculated dynamically using the same formula as toxicity. This value is the probability that your character will develop an alchemcial addiction after consuming the potion. By default Potency is half of Toxicity, meaning that consuming a potion that adds 30 toxicity carries a 15% chance of addiction. This is, of course, customizable in the MCM menu.

Addictions are diseases, which progress through four stages, becoming progressively worse as you go through withdrawl. By default addiction progresses one stage every 12 hours, with all effects stacking.
- Euphoria - +5% Poison Resistance owing to your increased tolerance to alchemical ingredients.
- Nephrosis - Health, Stamina and Magicka do not regenerate as your liver and kidneys work to detoxify your body.
- Catalepsy - Penalizes all skills by 20 points and skill gain by 10% due to your inability to concentrate and uncontrollable shaking.
- Marasmus - Penalizes all skills by an addtional 20 points, skill gain by an additional 10%, reduces movement speed by 25% and carry weight by 50 due to muscle degeneration and wracking pain.

The easiest way to manage one's addiction is to just have a few potions >;)
- Having any potion will add a certain number of hours of Satisfaction, which pauses the disease progression until it is consumed. This is computed as a function of the potency of the potion and a random element. It can be as little as 0 hours or as much as 1 game day. Satisfaction does not stack. If you drink a potion and get 24 hours of satisfaction, drinking more won't do anything. Potions only add satisfaction if their calculated effect is greater than your current Satisfaction level.
- Going on a potion bender and increasing your toxicity to 100% will reset the disease to the Euphoria stage. You'll feel better, for now.
- Quitting cold turkey will progress you through the various stages of the disease. Once you're in the Marasmus stage you'll stay there until it progresses and then you'll recover. Drinking any potion at this stage will add Satisfaction, pausing the progression and prolonging the condition.
- You can seek help from a shrine, or cure disease spell or effect to remove the disease entirely.
- You can always try a cure disease potion... They're super tasty and totally not bad for you. Right?

=== Requirements & Compatibility ===
This mod requires SKSE (who though it'd be a good idea not to have a log function in the vanilla scripting engine?), and SkyUI 5 (for the widget and menus).

I don't alter any Vanilla forms, and toxicity/potency are calculated dynamically so theoretically it should be fine with whatever. It does rely on potions having the appropriate keywords, so any mods which add potions without the VendorItemPotion keyword will not be recognized. For everything else there's the Whitelist page in the MCM. If you find that certain items (e.g. Poultices/Salves) are misbehaving and/or you want to make a certain specific item non-toxic just add it to the whitelist. CTD will ignore any potion which contains a string on the whitelist. As an example adding "Poultice" to the whitelist would mean that all of the new poultice items added by CACO, which are all named "Poultice - ..." will be ignored.

=== Future Plans & Permissions ===
I consider this mod to be more or less done at this stage. I'd like to do some code cleanup and will try to fix major compatibility bugs as they come to my attention. I had originally considerd messing with Skooma, however at this stage there are a number of high quality Skooma mods out there, and I'd prefer not to bloat CTD with extra scripts and features and instead just let it focus on it's main purpose: adding consequences for potion abuse.

This mod is completely free to to use, create derivative works or hack on provided that
- You give credit
- The resulting derivative work is also free (e.g. non-commercial)
- You include sources (e.g. psc) in any derived work (e.g. share your scripts with the community)

=== WTF IS THE WIDGET TELLING ME!! ===
The widget is just a toxicity meter, it is green and fills up as your toxicity increases. When the widget is full, you're overdosed (100% or greater). There IS NO TOXICITY CAP, so you can go WAY over 100%. It's primarily an indicator of how close you are to triggering the overdose effect. Also keep in mind that toxicity decays on a half-life. If your toxicity is 100% it will drop to 50% after 6 hours (default half-life). After 6 Hours more it will be 25%.  

If you acquire an addiction the widget changes color dynamically to let you know roughly how much Satisfaction you have. Red means your disease is progressing, Purple means you have about a day of Satisfaction buffer, some shade in between means you have some amount less than a day. It's intentionally not easy to judge (you can get the exact value in the MCM if you like).