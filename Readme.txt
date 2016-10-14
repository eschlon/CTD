

	C  H  A  S  I  N  G    T  H  E    D  R  A  G  O  N

	Because potions are sooooo goooood.

	- by ghenna (eschlon)

v 0.9 readme, last updated September 23 2014

Contents
========

1. Introduction
2. Obligatory Gratitude
3. Toxicity
4. Addiction
5. Requirements & Compatibility
6. Future Plans
7. WTF IS THE WIDGET TELLING ME!!


=== Introduction ===
Chasing the Dragon aims to add a level of immersion to the alchemy system by adding drawbacks and risks to potion use. Alchemy in Skyrim is simultaneously under and over powered. On the one hand, vanilla potion effects are not very impressive. On the other hand, nothing prevents the Dragonborn from hiding behind a rock and sucking down gallons of healing potions in the middle of a fight.

This mod is an attempt to fix the latter, adding consequences for potion abuse, but does nothing with respect to the former, as there are already a host of excellent mods out there that overhaul the Alchemy system, re-balance potion effects and add new effects. If you're using this mod I highly recommend checking out some of the alchemy mods here on the Nexus.

So what does it actually do? As of this release, CTD adds two mechanics Toxicity and Addiction. Specifics are discussed in the appropriate section below, and the experience is customizable via the an MCM menu.

=== Obligatory Gratitude ===
I'd like to thank BralorMarr on Nexus for his Toxicity Mod (not to mention his other great mods), which served as an inspiration for this work. He's a talented modder and I'm a noob. If you're just looking for a light-weight toxicity system and a bit of a different approach, I highly recommend his mod.

I'd also like to thank Chesko (of course) for so many awesome things, but mainly for his Frostfall / Wearable Lanterns widget code, which I use with attribution for the widget in this mod.

=== Toxicity ===
Toxicity is a measure of how dangerous it is to consume a given alchemical concoction. To maximize compatibility toxicity is calculated dynamically as a function of the potion's value. This means the mod doesn't actually care what kind of potion you're consuming, and thus should be maximally compatible with any mod that alters potion effects, modifies the alchemy skill or adds new potions to the game, assuming that the modder correctly added the potion keyword to any new potions. I opted to use potion value rather than some other, more interesting metric (Toxicity uses an interesting combination of the number, type, magnitude and duration of the potion's effects), because I wanted the user to be able to relatively easily get an idea of how toxic a given potion would be, and value is easily visible and familiar.

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
This mod requires SKSE (who though it'd be a good idea not to have a log function in the vanilla scripting engine?), and SkyUI (for the widget).

I don't alter any Vanilla forms, and toxicity/potency are calculated dynamically so theoretically it should be fine with whatever. It does rely on potions having the appropriate keywords, so mods which change vanilla potions or add potions won't work if the keywords are not present (or if they're worth 0 gold).

Also keep in mind this is a) my first mod and b) primarily tested by me streaming/playing so there may be some issues I haven't foreseen.

=== Future Plans ===
When I first started modding I had no damned idea what I was doing. I still don't really, but I do have some unreleased bits that I'm half working on when I have the time and inclination.
- Skooma in Skyrim is both a food and pretty useless. This is a travesty. It'd be silly to make an addiction mod without doing something about that.
- Being poisoned is primarily an annoying visual effect. I'd like to make poisonous creatures add to your toxicity.
- The widget is a work in progress. I think it works for what it is, but would like to mess with it if I have time and can find a copy of Flash for cheap.

=== WTF IS THE WIDGET TELLING ME!! ===
The widget is just a toxicity meter, it is green and fills up as your toxicity increases. When the widget is full, you're overdosed (100% or greater). There IS NO TOXICITY CAP, so you can go WAY over 100%. It's primarily an indicator of whether or not your have the overdose effect.

If you acquire an addiction the widget changes color dynamically to let you know roughly how much Satisfaction you have. Red means your disease is progressing, Purple means you have about a day of Satisfaction buffer, some shade in between means you have some amount less than a day. It's intentionally not easy to judge (you can get the exact value in the MCM if you like).