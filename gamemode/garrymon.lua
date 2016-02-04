local gtypeIneffective = {}
gtypeIneffective[GTYPE_NORMAL] 		= bit.bor( GTYPE_ROCK, GTYPE_STEEL )
gtypeIneffective[GTYPE_FIGHTING] 	= bit.bor( GTYPE_POISON, GTYPE_FLYING, GTYPE_PSYCHIC, GTYPE_BUG, GTYPE_FAIRY )
gtypeIneffective[GTYPE_FLYING] 		= bit.bor( GTYPE_ELECTRIC, GTYPE_ROCK, GTYPE_STEEL )
gtypeIneffective[GTYPE_POISON] 		= bit.bor( GTYPE_POISON, GTYPE_GROUND, GTYPE_ROCK, GTYPE_GHOST )
gtypeIneffective[GTYPE_GROUND]		= bit.bor( GTYPE_GRASS, GTYPE_BUG )
gtypeIneffective[GTYPE_ROCK]		= bit.bor( GTYPE_FIGHTING, GTYPE_GROUND, GTYPE_STEEL )
gtypeIneffective[GTYPE_BUG]			= bit.bor( GTYPE_FIRE, GTYPE_FIGHTING, GTYPE_POISON, GTYPE_FLYING, GTYPE_GHOST, GTYPE_STEEL, GTYPE_FAIRY )
gtypeIneffective[GTYPE_GHOST]		= bit.bor( GTYPE_DARK )
gtypeIneffective[GTYPE_STEEL]		= bit.bor( GTYPE_FIRE, GTYPE_WATER, GTYPE_ELECTRIC, GTYPE_STEEL )
gtypeIneffective[GTYPE_FIRE]		= bit.bor( GTYPE_FIRE, GTYPE_WATER, GTYPE_ROCK, GTYPE_DRAGON )
gtypeIneffective[GTYPE_WATER]		= bit.bor( GTYPE_WATER, GTYPE_GRASS, GTYPE_DRAGON )
gtypeIneffective[GTYPE_GRASS]		= bit.bor( GTYPE_FIRE, GTYPE_GRASS, GTYPE_POISON, GTYPE_FLYING, GTYPE_BUG, GTYPE_DRAGON, GTYPE_STEEL )
gtypeIneffective[GTYPE_ELECTRIC]	= bit.bor( GTYPE_ELECTRIC, GTYPE_GRASS, GTYPE_DRAGON )
gtypeIneffective[GTYPE_PSYCHIC]		= bit.bor( GTYPE_PSYCHIC, GTYPE_STEEL )
gtypeIneffective[GTYPE_ICE]			= bit.bor( GTYPE_FIRE, GTYPE_WATER, GTYPE_ICE, GTYPE_STEEL )
gtypeIneffective[GTYPE_DRAGON]		= bit.bor( GTYPE_STEEL )
gtypeIneffective[GTYPE_DARK]		= bit.bor( GTYPE_FIGHTING, GTYPE_DARK, GTYPE_FAIRY )
gtypeIneffective[GTYPE_FAIRY]		= bit.bor( GTYPE_FIRE, GTYPE_POISON, GTYPE_STEEL )

local gtypeEffective = {}
gtypeEffective[GTYPE_NORMAL] 	= 0
gtypeEffective[GTYPE_FIGHTING] = bit.bor( GTYPE_NORMAL, GTYPE_ICE, GTYPE_ROCK, GTYPE_STEEL )
gtypeEffective[GTYPE_FLYING] 	= bit.bor( GTYPE_GRASS, GTYPE_FIGHTING, GTYPE_BUG )
gtypeEffective[GTYPE_POISON] 	= bit.bor( GTYPE_GRASS, GTYPE_FAIRY )
gtypeEffective[GTYPE_GROUND]	= bit.bor( GTYPE_FIRE, GTYPE_ELECTRIC, GTYPE_POISON, GTYPE_ROCK, GTYPE_STEEL )
gtypeEffective[GTYPE_ROCK]		= bit.bor( GTYPE_FIRE, GTYPE_ICE, GTYPE_FLYING, GTYPE_BUG )
gtypeEffective[GTYPE_BUG]		= bit.bor( GTYPE_GRASS, GTYPE_PSYCHIC, GTYPE_DARK )
gtypeEffective[GTYPE_GHOST]	= bit.bor( GTYPE_PSYCHIC, GTYPE_GHOST )
gtypeEffective[GTYPE_STEEL]	= bit.bor( GTYPE_ICE, GTYPE_ROCK, GTYPE_FAIRY )
gtypeEffective[GTYPE_FIRE]		= bit.bor( GTYPE_GRASS, GTYPE_ICE, GTYPE_BUG, GTYPE_STEEL )
gtypeEffective[GTYPE_WATER]	= bit.bor( GTYPE_FIRE, GTYPE_GROUND, GTYPE_ROCK )
gtypeEffective[GTYPE_GRASS]	= bit.bor( GTYPE_WATER, GTYPE_GROUND, GTYPE_ROCK )
gtypeEffective[GTYPE_ELECTRIC]	= bit.bor( GTYPE_WATER, GTYPE_FLYING )
gtypeEffective[GTYPE_PSYCHIC]	= bit.bor( GTYPE_FIGHTING, GTYPE_POISON )
gtypeEffective[GTYPE_ICE]		= bit.bor( GTYPE_GRASS, GTYPE_GROUND, GTYPE_FLYING, GTYPE_DRAGON )
gtypeEffective[GTYPE_DRAGON]	= bit.bor( GTYPE_DRAGON )
gtypeEffective[GTYPE_DARK]		= bit.bor( GTYPE_PSYCHIC, GTYPE_GHOST )
gtypeEffective[GTYPE_FAIRY]	= bit.bor( GTYPE_FIGHTING, GTYPE_DRAGON, GTYPE_DARK )

local gtypeNoeffect = {}
gtypeNoeffect[GTYPE_NORMAL] 	= GTYPE_GHOST
gtypeNoeffect[GTYPE_FIGHTING] 	= GTYPE_GHOST
gtypeNoeffect[GTYPE_FLYING] 	= 0
gtypeNoeffect[GTYPE_POISON] 	= GTYPE_STEEL
gtypeNoeffect[GTYPE_GROUND]		= GTYPE_FLYING
gtypeNoeffect[GTYPE_ROCK]		= 0
gtypeNoeffect[GTYPE_BUG]		= 0
gtypeNoeffect[GTYPE_GHOST]		= GTYPE_NORMAL
gtypeNoeffect[GTYPE_STEEL]		= 0
gtypeNoeffect[GTYPE_FIRE]		= 0
gtypeNoeffect[GTYPE_WATER]		= 0
gtypeNoeffect[GTYPE_GRASS]		= 0
gtypeNoeffect[GTYPE_ELECTRIC]	= GTYPE_GROUND
gtypeNoeffect[GTYPE_PSYCHIC]	= GTYPE_DARK
gtypeNoeffect[GTYPE_ICE]		= 0
gtypeNoeffect[GTYPE_DRAGON]		= GTYPE_FAIRY
gtypeNoeffect[GTYPE_DARK]		= 0
gtypeNoeffect[GTYPE_FAIRY]		= 0

local gtypeToString = {}
gtypeToString[GTYPE_NORMAL]		= "normal"
gtypeToString[GTYPE_FIGHTING]	= "fighting"
gtypeToString[GTYPE_FLYING]		= "flying"
gtypeToString[GTYPE_POISON]		= "poison"
gtypeToString[GTYPE_GROUND]		= "ground"
gtypeToString[GTYPE_ROCK]		= "rock"
gtypeToString[GTYPE_BUG]		= "bug"
gtypeToString[GTYPE_GHOST]		= "ghost"
gtypeToString[GTYPE_STEEL]		= "steel"
gtypeToString[GTYPE_FIRE]		= "fire"
gtypeToString[GTYPE_WATER]		= "water"
gtypeToString[GTYPE_GRASS]		= "grass"
gtypeToString[GTYPE_ELECTRIC]	= "electric"
gtypeToString[GTYPE_PSYCHIC]	= "psychic"
gtypeToString[GTYPE_ICE]		= "ice"
gtypeToString[GTYPE_DRAGON]		= "dragon"
gtypeToString[GTYPE_DARK]		= "dark"
gtypeToString[GTYPE_FAIRY]		= "fairy"

garrymon = {}

local function countSetBits( i )
	i = i - bit.band(bit.rshift(i, 1), 0x55555555)
    i = bit.band(i, 0x33333333) + bit.band(bit.rshift(i, 2), 0x33333333)
    return bit.rshift(bit.band((i + bit.rshift(i, 4)), 0x0F0F0F0F) * 0x01010101, 24);
end
function GM:GetTypeEffectiveness( gtype_ability, gtype_target )
	if bit.band( gtypeNoeffect[gtype_ability], gtype_target ) ~= 0 then return 0 end
	local effectiveness = math.max( countSetBits( bit.band( gtypeEffective[gtype_ability], gtype_target ) ) * 2, 1 )
	effectiveness = effectiveness * 1 / math.max( countSetBits( bit.band( gtypeIneffective[gtype_ability], gtype_target ) ) * 2, 1 )
	return effectiveness
end

function GM:GTypeToString( gtype )
	return gtypeToString[gtype]
end

local StageMultipliers1 = { 3/2, 4/2, 5/2, 6/2, 7/2, 8/2 }
local StageMultipliers2 = { 4/3, 5/3, 6/3, 7/3, 8/3, 9/3 }

function GM:CalculateStat( gmon, statKey )
	local stat = gmon.stats[ statKey ]
	local multiplier = stat.stage == 0 and 1 or (statKey < STAT_ACCURACY and StageMultipliers1 or StageMultipliers2)[math.abs(stat.stage)]
	if stat.stage < 0 then
		multiplier = 1 / multiplier
	end
	if statKey == STAT_EVASION then
		multiplier = 1 / multiplier
	end
	return stat.value * multiplier
end

local function Stat( value )
	return {value = value, stage = 0}
end

local function Stats( attack, defense, spattack, spdefense, speed, accuracy, evasion )
	return {
		Stat( attack ),
		Stat( defense ),
		Stat( spattack ),
		Stat( spdefense ),
		Stat( speed ),
		Stat( accuracy ),
		Stat( evasion )
	}
end

local function Ability( abilityKey, minLvl )
	if not GM.abilities[abilityKey] then return end
	return {key = abilityKey, gp = GM.abilities[abilityKey].gp, minLvl = minLvl or 0, stage = 0}
end
 
local function Garrymon( name, gtype, hp, attack, defense, spattack, spdefense, speed, abilities, evolves )
    return {
        name = name,
        gtype = gtype,
        hp = hp,
        maxhp = hp,
        stats = Stats( attack, defense, spattack, spdefense, speed, 1.0, 1.0 ),
        exp = math.pow( 4, 3 ),
        maxexp = 169,
        lvl = 5,
        evolves = evolves,
        abilities = abilities
    }
end

local function EvolvedGarrymon( name, base, hp, attack, defense, spattack, spdefense, speed )
	local b = GM.garrymons[ base ]
	return Garrymon( name, b.gtype, hp, attack, defense, spattack, spdefense, speed, b.abilities, b.evolves )
end

function garrymon.Create( classKey )
	return table.Copy(GAMEMODE.garrymons[classKey])
end

function GM:PlayerCaptureGarrymon( pl, garrymon )
	local ghand = pl:GetGHand()
	if ghand:IsFull() then
		-- Add to collection instead
	else
		ghand:AddGarrymon( garrymon )
	end
	pl:ChatPrint( "You got " .. garrymon.name )
	gamemode.Call( "OnPlayerCaptureGarrymon", pl, garrymon )
end

function GM:OnPlayerCaptureGarrymon( pl, garrymon )
end

GM.garrymons = {
    Muberry = Garrymon( "Muberry", bit.bor(GTYPE_GRASS, GTYPE_POISON), 45, 49, 49, 65, 65, 45, 
    	  { Ability("Growl"), Ability("Tackle"), Ability("LeechSeed", 7), Ability("VineWhip", 9), 
	    	Ability("PoisonPowder", 13), Ability("SleepPowder", 13), Ability("TakeDown", 15),  Ability("RazorLeaf", 19), 
	    	Ability("SweetScent", 21), Ability("Growth", 25), Ability("DoubleEdge", 27), Ability("WorrySeed", 31), 
	    	Ability("Synthesis", 33), Ability("SeedBomb", 37) }, 
	    	{16, "Thornball", 32, "Whiplash"} ),
    Umlaut = Garrymon( "Umlaut", GTYPE_WATER, 44, 48, 65, 50, 64, 43, 
    	  { Ability("Tackle"), Ability("TailWhip"), Ability("WaterGun", 7), Ability("Withdraw", 10), Ability("Bubble", 13),
			Ability("Bite", 16), Ability("RapidSpin", 19), Ability("Protect", 22), Ability("WaterPulse", 25), Ability("AquaTail", 28), 
			Ability("SkullBash", 31), Ability("IronDefense", 34), Ability("RainDance", 37), Ability("HydroPump", 40) }, 
			{16, "Ampersplash", 36, "Hydrophen"} ),
    Firedash = Garrymon( "Firedash", GTYPE_FIRE, 39, 52, 43, 60, 50, 65, 
    	  { Ability("Scratch"), Ability("Growl"), Ability("Ember", 7), Ability("Smokescreen", 10), Ability("DragonRage", 16),
    	 	Ability("ScaryFace", 19), Ability("FireFang", 25), Ability("FlameBurst", 28), Ability("Slash", 34), Ability("Flamethrower", 37),
    	 	Ability("FireSpin", 43), Ability("Inferno", 46) },
    	 	{16, "Flametheon", 36, "Blazer"} ),
    Caterpie = Garrymon( "Caterpie", GTYPE_BUG, 45, 30, 35, 20, 20, 45,
    	  { Ability("StringShot"), Ability("Tackle"), Ability("BugBite, 15")},
    	    {7, "Metapod", 10, "Butterfree"} ),
    Weedle = Garrymon( "Weedle", bit.bor(GTYPE_BUG, GTYPE_POISON), 40, 35, 30, 20, 20, 50,
    	  { Ability("PoisonSting"), Ability("StringShot"), Ability("BugBite", 15) },
    	    {7, "Kakuna", 10, "Beedrill"} ),
    Pidgey = Garrymon( "Pidgey", bit.bor(GTYPE_NORMAL, GTYPE_FLYING), 40, 45, 40, 35, 35, 56,
    	  { Ability("Tackle"), Ability("SandAttack", 5), Ability("Gust", 9), Ability("QuickAttack", 13), Ability("Whirlwind", 17), 
    	    Ability("Twister", 21), Ability("FeatherDance", 25), Ability("Agility", 29), Ability("WingAttack", 33), Ability("Roost", 37), 
    	    Ability("Tailwind", 41), Ability("MirrorMove", 45), Ability("AirSlash", 49), Ability("Hurricane", 53) },
    	    {18, "Pidgeotto", 36, "Pidgeot"} ),
    Rattata = Garrymon( "Rattata", GTYPE_NORMAL, 30, 56, 35, 25, 35, 72,
    	  { Ability("Tackle"), Ability("TailWhip"), Ability("QuickAttack", 4), Ability("FocusEnergy", 7), Ability("Bite", 10),
    	    Ability("Pursuit", 13), Ability("HyperFang", 16), Ability("SuckerPunch", 19), Ability("Crunch", 22), Ability("Assurance", 25),
    	    Ability("SuperFang", 28), Ability("DoubleEdge", 31), Ability("Endeavor", 34) },
    	    {20, "Raticate"} ),
    Spearow = Garrymon( "Spearow", bit.bor(GTYPE_FLYING, GTYPE_NORMAL), 40, 60, 30, 31, 31, 70,
    	  { Ability("Growl"), Ability("Peck"), Ability("Leer", 5), Ability("FuryAttack", 9), Ability("Pursuit", 13), Ability("AerialAce", 17), 
    	    Ability("MirrorMove", 21), Ability("Agility", 25), Ability("Assurance", 29), Ability("Roost", 33), Ability("DrillPeck", 37) },
    	    {20, Fearow} ),
    Ekans = Garrymon( "Ekans", GTYPE_POISON, 35, 60, 44, 40, 54, 55,
    	  { Ability("Leer"), Ability("Leer"), Ability("PoisonSting", 4), Ability("Bite", 9), Ability("Glare", 12), Ability("Screech", 17), 
    	    Ability("Acid", 20), Ability("SpitUp", 25), Ability("Stockpile", 20), Ability("Swallow", 25), Ability("AcidSpray", 28), 
    	    Ability("MudBomb", 33), Ability("GastroAcid", 36), Ability("Belch", 38), Ability("Haze", 41), Ability("Coil", 44), Ability("GunkShot", 49), },
    	    {20, Arbok} ),
    -- Pikachu = Garrymon( "Pikachu", GTYPE_ELECTRIC, 35, 55, 40, 50, 50, 90,
    -- 	  { Ability("TailWhip"), Ability("ThunderShock"), Ability("Growl", 5), Ability("PlayNice", 7), Ability("QuickAttack", 10), 
    -- 	    Ability("ElectroBall", 13), Ability("ThunderWave", 18), Ability("Feint", 21), Ability("DoubleTeam", 23), 
    -- 	    Ability("Spark", 26), Ability("Nuzzle", 29), Ability("Discharge", 34), Ability("Slam", 37), Ability("Thunderbolt", 42), 
    -- 	    Ability("Agility", 45), Ability("WildCharge", 50), Ability("LightScreen", 53), Ability("Thunder", 58) }),
    Sandshrew = Garrymon( "Sandshrew", GTYPE_GROUND, 50, 75, 85, 20, 30, 40,
    	  { Ability("DefenseCurl"), Ability("Scratch"), Ability("SandAttack", 3), Ability("PoisonSting", 5), 
    	    Ability("Rollout", 7), Ability("RapidSpin", 9), Ability("FuryCutter", 11), Ability("Magnitude", 14), 
    	    Ability("Swift", 17), Ability("FurySwipes", 20), Ability("SandTomb", 23), Ability("Slash", 26), 
    	    Ability("Dig", 30), Ability("GyroBall", 34), Ability("SwordsDance", 38), Ability("Sandstorm", 42), 
    	    Ability("Earthquake", 46) },
    	    {22,Sandslash} ),
    -- Nidoran = Garrymon( "Nidoran♀", GTYPE_POISON, 55, 47, 52, 40, 40, 41,
    -- 	  { Ability("Growl"), Ability("Scratch"), Ability("TailWhip", 7), Ability("DoubleKick", 9), 
    -- 	    Ability("PoisonSting", 13), Ability("FurySwipes", 19), Ability("Bite", 21), Ability("HelpingHand", 25), 
    -- 	    Ability("ToxicSpikes", 31), Ability("Flatter", 33), Ability("Crunch", 37), Ability("Captivate", 43), 
    -- 	    Ability("PoisonFang", 45) },
    -- 	    {16, "Nidorina"} ),
    -- Nidoran = Garrymon( "Nidoran♂", GTYPE_POISON, 46, 57, 40, 40, 40, 50,
    -- 	  { Ability("Leer"), Ability("Peck"), Ability("FocusEnergy", 7), Ability("DoubleKick", 9), 
    -- 	    Ability("PoisonSting", 13), Ability("FuryAttack", 19), Ability("HornAttack", 21), Ability("HelpingHand", 25), 
    -- 	    Ability("ToxicSpikes", 31), Ability("Flatter", 33), Ability("PoisonJab", 37), Ability("Captivate", 43), 
    -- 	    Ability("HornDrill", 45) },
    -- 	    {16, "Nidorino"} ),
    -- Clefairy = Garrymon( "Clefairy", GTYPE_FAIRY, 70, 45, 48, 60, 65, 35,
    -- 	  { Ability("AfterYou"), Ability("DisarmingVoice"), Ability("Growl"), Ability("HealingWish"), 
    -- 	    Ability("Pound"), Ability("Encore"), Ability("Sing", 7), Ability("DoubleClap", 10), 
    --   	    Ability("DefenseCurl", 13), Ability("FollowMe", 16), Ability("Bestow", 19), Ability("WakeUpSlap", 22), 
    -- 	    Ability("Minimize", 25), Ability("StoredPower", 28), Ability("Metronome", 31), Ability("CosmicPower", 34), 
    -- 	    Ability("LuckyChant", 37), Ability("BodySlam", 40), Ability("Moonlight", 43), Ability("Moonblast", 46), 
    -- 	    Ability("Gravity", 49), Ability("MeteorMash", 50), Ability("HealingWish", 55), Ability("AfterYou", 58) } ),
    -- Vulpix = Garrymon( "Vulpix", GTYPE_FIRE, 38, 41, 40, 50, 65, 65,
    -- 	  { Ability("Ember"), Ability("TailWhip", 4), Ability("Roar", 7), Ability("BabyDollEyes", 9), 
    -- 	    Ability("QuickAttack", 10), Ability("ConfuseRay", 12), Ability("FireSpin", 15), Ability("Payback", 18), 
    -- 	    Ability("WillOWisp", 20), Ability("FeintAttack", 23), Ability("Extrasensory", 31), Ability("Safeguard", 34), 
    -- 	    Ability("Flamethrower", 36), Ability("Imprison", 39), Ability("FireBlast", 42), Ability("Grudge", 44), 
    -- 	    Ability("Captivate", 47), Ability("Inferno", 50) ) } ),
	-- Jigglypuff = Garrymon( "Jigglypuff", bit.bor(GTYPE_NORMAL, GTYPE_FAIRY), 115, 45, 20, 45, 25, 20,
	-- 	  ( Ability("Sing"), Ability("DefenseCurl", 3), Ability("Pound", 5), Ability("PlayNice", 8), 
	-- 	  	Ability("DisarmingVoice", 11), Ability("Disable", 15), Ability("DoubleSlap", 18), Ability("Rollout", 21), 
	-- 	  	Ability("Round", 24), Ability("WakeUpSlap", 28), Ability("Rest", 32), Ability("BodySlam", 35), 
	-- 	  	Ability("Mimic", 37), Ability("GyroBall", 40), Ability("HyperVoice", 44), Ability("DoubleEdge", 49) ) ),
	-- Zubat = Garrymon( "Zubat", bit.bor(GTYPE_POISON, GTYPE_FLYING), 40, 45, 35, 30, 40, 55,
	-- 	  { Ability("LeechLife"), Ability("Supersonic", 5), Ability("Astonish", 7), Ability("Bite", 11), 
	-- 	    Ability("WingAttack", 13), Ability("ConfuseRay", 17), Ability("AirCutter", 19), Ability("Swift", 23), 
	-- 	    Ability("PoisonFang", 25), Ability("MeanLook", 29), Ability("Acrobatics", 31), Ability("Haze", 35), 
	-- 	    Ability("Venoshock", 37), Ability("AirSlash", 41), Ability("QuickGuard", 43) },
	-- 	    {22, "Golbat"} ),
	-- Oddish = Garrymon( "Oddish", bit.bor(GTYPE_POISON, GTYPE_GRASS), 45, 50, 55, 75, 65, 30,
	-- 	  { Ability("Absorb"), Ability("SweetScent", 5), Ability("Acid", 9), Ability("PoisonPowder", 13), 
	-- 	    Ability("StunSpore", 14), Ability("SleepPowder", 15), Ability("MegaDrain", 19), Ability("LuckyChant", 23), 
	-- 	    Ability("Moonlight", 27), Ability("GigaDrain", 31), Ability("Toxic", 35), Ability("NaturalGift", 39), 
	-- 	    Ability("Moonblast", 43), Ability("GrassyTerrain", 47), Ability("PetalDance", 51) },
	-- 	    {23, "Gloom"} ),
	Paras = Garrymon( "Paras", bit.bor(GTYPE_BUG, GTYPE_GRASS), 35, 70, 55, 45, 55, 25,
		  { Ability("Scratch"), Ability("StunSpore", 6), Ability("PoisonPowder", 6), Ability("LeechLife", 11), 
		    Ability("FuryCutter", 17), Ability("Spore", 22), Ability("Slash", 27), Ability("Growth", 33), 
		    Ability("GigaDrain", 38), Ability("Aromatherapy", 43), Ability("RagePowder", 49), Ability("XScissor", 54) },
		    {24, "Parasect"} ),
	Venonat = Garrymon( "Venonat", bit.bor(GTYPE_BUG, GTYPE_POISON), 60, 55, 50, 40, 55, 45,
		  { Ability("Disable"), Ability("Tackle"), Ability("Foresight"), Ability("Supersonic", 5), 
		    Ability("Confusion", 11), Ability("PoisonPowder", 13), Ability("LeechLife", 17), Ability("StunSpore", 23), 
		    Ability("Psybeam", 25), Ability("SleepPowder", 29), Ability("SignalBeam", 35), Ability("ZenHeadbutt", 37), 
		    Ability("PoisonFang", 41), Ability("Psychic", 47) },
		    {31, "Venomoth"} ),
	Diglett = Garrymon( "Diglett", GTYPE_GROUND, 10, 55, 25, 35, 45, 95,
		  { Ability("SandAttack"), Ability("Scratch"), Ability("Growl", 4), Ability("Astonish", 7), 
		    Ability("MudSlap", 12), Ability("Magnitude", 15), Ability("Bulldoze", 18), Ability("SuckerPunch", 23), 
		    Ability("MudBomb", 26), Ability("EarthPower", 29), Ability("Dig", 34), Ability("Slash", 37), 
		    Ability("Earthquake", 40), Ability("Fissure", 45) },
		    {26, "Dugtrio"} ),
	Meowth = Garrymon( "Meowth", 40, 45, 35, 40, 40, 90,
		  { Ability("Growl"), Ability("Scratch"), Ability("Bite", 6), Ability("FakeOut", 9), 
		    Ability("FurySwipes", 14), Ability("Taunt", 25), Ability("PayDay", 30), Ability("Slash", 33), 
		    Ability("NastyPlot", 38), Ability("Assurance", 41), Ability("Captivate", 46), Ability("NightSlash", 49), 
		    Ability("Feint", 50) },
		    {53, "Persian"} ),
	Psyduck = Garrymon( "Psyduck", 50, 52, 48, 65, 50, 55, 
		  { Ability("Scratch"), Ability("WaterSport"), Ability("TailWhip", 4), Ability("WaterGun", 8), 
		    Ability("Confusion", 11), Ability("FurySwipes", 15), Ability("WaterPulse", 18), Ability("Disable", 22), 
		    Ability("Screech", 25), Ability("AquaTail", 29), Ability("ZenHeadbutt", 32), Ability("Soak", 36), 
		    Ability("PsychUp", 39), Ability("Amnesia", 43), Ability("HydroPump", 46), Ability("WonderRoom", 50), },
		    {33, "Golduck"} ),
	Mankey = Garrymon( "Mankey", GTYPE_FIGHTING, 40, 80, 35, 35, 45, 70,
		  { Ability("Covet"), Ability("Leer"), Ability("LowKick"), Ability("Scratch"), 
		    Ability("FocusEnergy"), Ability("FurySwipes", 9), Ability("KarateChop", 13), Ability("SeismicToss", 17), 
		    Ability("Screech", 21), Ability("CrossChop", 37), Ability("Thrash", 41), Ability("Punishment", 45), 
		    Ability("CloseCombat", 49), Ability("FinalGambit", 53) },
		    {28, "Primeape"} ),
	Growlithe = Garrymon( "Growlithe", GTYPE_FIRE, 55, 70, 45, 70, 50, 60,
		  { Ability("Bite"), Ability("Roar"), Ability("Ember", 6), Ability("Leer", 8), 
		    Ability("OdorSleuth", 10), Ability("HelpingHand", 12), Ability("FlameWheel", 17), Ability("Reversal", 19), 
		    Ability("FireFang", 21), Ability("TakeDown", 23), Ability("FlameBurst", 28), Ability("Agility", 28), 
		    Ability("Retaliate", 32), Ability("Flamethrower", 34), Ability("Crunch", 39), Ability("HeatWave", 41), 
		    Ability("Outrage", 43), Ability("FlareBlitz", 45) },
		    {59, "Arcanine"} ),
	-- Poliwag = Garrymon( "Poliwag", GTYPE_WATER, 40, 50, 40, 40, 40, 90,
	-- 	  { Ability("WaterSport"), Ability("WaterGun", 5), Ability("Hypnosis", 8), Ability("Bubble", 11), 
	-- 	    Ability("DoubleSlap", 15), Ability("RainDance", 18), Ability("BodySlam", 21), Ability("BubbleBeam", 25), 
	-- 	    Ability("MudShot", 28), Ability("BellyDrum", 31), Ability("WakeUpSlap", 35), Ability("HydroPump", 38), 
	-- 	    Ability("MudBomb", 41) },
	-- 	    {25, "Poliwhirl"})
	-- Abra = Garrymon( "Abra", GTYPE_PSYCHIC, 25, 20, 15, 105, 55, 90,
	-- 	  { Ability("Teleport", 1) },
	-- 	  {16, "Kadabra"} ),
	-- Machop = Garrymon( "Machop", GTYPE_FIGHTING, 70, 80, 50, 35, 35, 35, 
	-- 	  { Ability("Leer"), Ability("LowKick"), Ability("FocusEnergy", 3), Ability("KarateChop", 7), 
	-- 	    Ability("Foresight", 9), Ability("LowSweep", 13), Ability("SeismicToss", 15), Ability("Revenge", 19), 
	-- 	    Ability("KnockOff", 21), Ability("VitalThrow", 25), Ability("WakeUpSlap", 27), Ability("DualChop", 31), 
	-- 	    Ability("Submission", 33), Ability("BulkUp", 37), Ability("CrossChop", 39), Ability("ScaryFace", 43), 
	-- 	    Ability("DynamicPunch", 45) },
	-- 	    {28 "Machoke"} ),
	-- Bellsprout = Garrymon( "Bellsprout", bit.bor(GTYPE_GRASS, GTYPE_POISON), 50, 75, 35, 70, 30, 40,
	-- 	  { Ability("VineWhip"), Ability("Growth", 7), Ability("Wrap", 11), Ability("SleepPowder", 13), 
	-- 	    Ability("PoisonPowder", 15), Ability("StunSpore", 17), Ability("Acid", 23), Ability("KnockOff", 27), 
	-- 	    Ability("SweetScent", 29), Ability("GastroAcid", 35), Ability("RazorLeaf", 39), Ability("Slam", 41), 
	-- 	    Ability("WringOut", 47) },
	-- 	    {21, "Weepinbell"} ),
	Tentacool = Garrymon( "Tentacool", bit.bor(GTYPE_WATER, GTYPE_POISON), 40, 40, 35, 50, 100, 70,
		  { Ability("PoisonSting"), Ability("SuperSonic", 4), Ability("Constrict", 7), Ability("Acid", 10), 
		    Ability("ToxicSpikes", 13), Ability("WaterPulse", 16), Ability("Wrap", 19), Ability("AcidSpray", 22), 
		    Ability("BubbleBeam", 25), Ability("Barrier", 28), Ability("PoisonJab", 31), Ability("Brine", 34), 
		    Ability("Screech", 37), Ability("Hex", 40), Ability("SludgeWave", 43), Ability("HydroPump", 46), 
		    Ability("WringOut", 49) }, 
		    {30, "Tentacruel"} ),
	-- Geodude = Garrymon( "Geodude". bit.bor(GTYPE_ROCK, GTYPE_GROUND), 40, 80, 100, 30, 30, 20,
	-- 	  { Ability("DefenseCurl"), Ability("Tackle"), Ability("MudSport", 4), Ability("RockPolish", 6), 
	-- 	    Ability("Rollout", 10), Ability("SmackDown", 18), Ability("Bulldoze", 22), Ability("SelfDestruct", 24), 
	-- 	    Ability("StealthRock", 28), Ability("RockBlast", 30), Ability("Earthquake", 34), Ability("Explosion", 36), 
	-- 	    Ability("DoubleEdge", 40), Ability("StoneEdge", 42) },
	-- 	    {25, "Graveler"} ),
	Ponyta = Garrymon( "Pontya", GTYPE_FIRE, 50, 85, 55, 65, 65, 90,
		  { Ability("Growl"), Ability("Tackle"), Ability("TailWhip", 4), Ability("Ember", 9), 
		    Ability("FlameWheel", 13), Ability("Stomp", 17), Ability("FlameCharge", 21), Ability("FireSpin", 25), 
		    Ability("TakeDown", 29), Ability("Inferno", 33), Ability("Agility", 37), Ability("FireBlast", 41), 
		    Ability("Bounce", 45), Ability("FlareBlitz", 49) },
		    {40, "Rapidash"} ),
	Slowpoke = Garrymon( "Slowpoke", bit.bor(GTYPE_WATER, GTYPE_PSYCHIC), 90, 65, 65, 40, 40, 15,
		  { Ability("Curse"), Ability("Yawn"), Ability("Tackle"), Ability("Growl", 5), 
		    Ability("WaterGun", 9), Ability("Confusion", 14), Ability("Disable", 19), Ability("Headbutt", 23), 
		    Ability("WaterPulse", 28), Ability("ZenHeadbutt", 32), Ability("SlackOff", 36), Ability("Amnesia", 41), 
		    Ability("Psychic", 45), Ability("RainDance", 49), Ability("PsychUp", 54), Ability("HealPulse", 58), },
		    {37, "Slowbro"} ),
	-- Magnemite = Garrymon( "Magnemite", bit.bor(GTYPE_ELECTRIC, GTYPE_STEEL), 25, 35, 70, 95, 55, 45,
 --          { Ability("Tackle"), Ability("Supersonic", 5), Ability("ThunderShock", 7), Ability("SonicBoom", 11), 
 --            Ability("ThunderWave", 13), Ability("MagnetBomb", 17), Ability("Spark", 19), Ability("MirrorShot", 23), 
 --            Ability("MetalSound", 25), Ability("ElectroBall", 29), Ability("", ), Ability("", ), 
 --            Ability("", ), Ability("", ), Ability("", ), Ability("", ), 
 --            Ability("", ), })



}

-- Evolved garrymons

GM.garrymons.Thornball = EvolvedGarrymon( "Thornball", "Muberry", 60, 62, 63, 80, 80, 60 )
GM.garrymons.Whiplash = EvolvedGarrymon( "Whiplash", "Thornball", 80, 82, 83, 100, 100, 80 )