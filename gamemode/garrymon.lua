GARRYTYPE_GRASS = "grass"
GARRYTYPE_WATER = "water"
GARRYTYPE_FIRE = "fire"

local StageMultipliers1 = { 3/2, 4/2, 5/2, 6/2, 7/2, 8/2 }
local StageMultipliers2 = { 4/3, 5/3, 6/3, 7/3, 8/3, 9/3 }

function GM:CalculateStat( gmon, statKey )
	local stat = gmon.stats[ statKey ]
	local multiplier = stat.stage == 0 and 1 or (statKey < STAT_ACCURACY and StageMultipliers1 or StageMultipliers2)[math.abs(stat.stage)]
	if stat.stage < 0 then
		multiplier = -multiplier
	end
	return stat.value * multiplier
end

STAT_ATTACK = 1
STAT_DEFENSE = 2
STAT_SPATTACK = 3
STAT_SPDEFENSE = 4
STAT_SPEED = 5
STAT_ACCURACY = 6
STAT_EVASION = 7

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
	return {key = abilityKey, gp = GM.abilities[abilityKey].gp, minLvl = minLvl}
end
 
local function Garrymon( name, type, hp, attack, defense, spattack, spdefense, speed, abilities, evolves )
    return {
        name = name,
        type = type,
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
    Muberry = Garrymon( "Muberry", GARRYTYPE_GRASS, 45, 49, 49, 65, 65, 45, 
    	  { Ability("Growl"), Ability("Tackle"), Ability("LeechSeed", 7), Ability("VineWhip", 9), 
	    	Ability("PoisonPowder", 13), Ability("SleepPowder", 13), Ability("TakeDown", 15),  Ability("RazorLeaf", 19), 
	    	Ability("SweetScent", 21), Ability("Growth", 25), Ability("DoubleEdge", 27), Ability("WorrySeed", 31), 
	    	Ability("Synthesis", 33), Ability("SeedBomb", 37) }, 
	    	{16, "Thornball", 32, "Whiplash"} ),
    Umlaut = Garrymon( "Umlaut", GARRYTYPE_WATER, 44, 48, 65, 50, 64, 43, 
    	  { Ability("Tackle"), Ability("TailWhip"), Ability("WaterGun", 7), Ability("Withdraw", 10), Ability("Bubble", 13),
			Ability("Bite", 16), Ability("RapidSpin", 19), Ability("Protect", 22), Ability("WaterPulse", 25), Ability("AquaTail", 28), 
			Ability("SkullBash", 31), Ability("IronDefense", 34), Ability("RainDance", 37), Ability("Hydropump", 40) }, 
			{16, "Ampersplash", 36, "Hydrophen"} ),
    Firedash = Garrymon( "Firedash", GARRYTYPE_FIRE, 39, 52, 43, 60, 50, 65, 
    	  { Ability("Scratch"), Ability("Growl"), Ability("Ember", 7), Ability("SmokeScreen", 10), Ability("DragonRage", 16),
    	 	Ability("ScaryFace", 19), Ability("FireFang", 25), Ability("FlameBurst", 28), Ability("Slash", 34), Ability("Flamethrower", 37),
    	 	Ability("FireSpin", 43), Ability("Inferno", 46),
    	 	{16, "Flametheon", 36, "Blazer"} )
}