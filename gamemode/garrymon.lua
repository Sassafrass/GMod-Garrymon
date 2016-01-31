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

GM.garrymons = {
    Muberry = Garrymon( "Muberry", GTYPE_GRASS, 45, 49, 49, 65, 65, 45, 
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
    Thornball = Garrymon( "Thornball", GTYPE_GRASS, 60, 62, 63, 80, 80, 60,  GM.garrymons.Muberry.abilities, {32, "Whiplash"} ),
    Whiplash = Garrymon( "Whiplash", GTYPE_GRASS, 80, 82, 83, 100, 100, 80, GM.garrymons.Muberry.abilities),
}