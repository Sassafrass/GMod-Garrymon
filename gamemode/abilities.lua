GTYPE_NORMAL	= 1
GTYPE_FIGHTING 	= 2
GTYPE_FLYING 	= 4
GTYPE_POISON 	= 8
GTYPE_GROUND 	= 16
GTYPE_ROCK 		= 32
GTYPE_BUG 		= 64
GTYPE_GHOST 	= 128
GTYPE_STEEL 	= 256
GTYPE_FIRE 		= 512
GTYPE_WATER 	= 1024
GTYPE_GRASS 	= 2048
GTYPE_ELECTRIC 	= 4096
GTYPE_PSYCHIC	= 8192
GTYPE_ICE 		= 16384
GTYPE_DRAGON 	= 32768
GTYPE_DARK 		= 65536
GTYPE_FAIRY 	= 131072

STAT_ATTACK = 1
STAT_DEFENSE = 2
STAT_SPATTACK = 3
STAT_SPDEFENSE = 4
STAT_SPEED = 5
STAT_ACCURACY = 6
STAT_EVASION = 7
STAT_RANDOM = -1

ABILITY_TYPE_PHYSICAL = 1
ABILITY_TYPE_STATUS = 2
ABILITY_TYPE_CUSTOM = 3

STATUS_ABILITY_TYPE_USER = 1
STATUS_ABILITY_TYPE_TARGET = 2
STATUS_ABILITY_TYPE_PARTY = 3

function GM:DamageFormula( ability, user, target )
	local abilityAttr = GAMEMODE.abilities[ability.key]
	local lvl = user.lvl
	local attack = self:CalculateStat( user, STAT_ATTACK )
	local defense = self:CalculateStat( user, STAT_DEFENSE )
	local base = abilityAttr.power
	local STAB = bit.band( user.gtype, abilityAttr.gtype ) == abilityAttr.gtype and 1.5 or 1
	local t = self:GetTypeEffectiveness( abilityAttr.gtype, target.gtype )
	if t > 1 then
		self:ActionMessage( "It is super effective!" )
	elseif t < 1 then
		self:ActionMessage( "It is ineffective!" )
	elseif t == 0 then
		self:ActionMessage( "It has no effect!" )
	end
	local crit = self:GetCriticalHit( ability.stage )
	local other = 1 -- TODO
	local random = (math.random() * 0.15 + 1)
	local modifier = STAB * t * crit * other * random
	return math.floor(((2 * lvl + 10) / 250 * attack / defense * base + 2) * modifier)
end

-- Hit if greater than 1
function GM:HitFormula( abilityAttr, user, target )
	if abilityAttr.accuracy == -1 then return true end
	local P = abilityAttr.accuracy * self:CalculateStat( user, STAT_ACCURACY ) / 
		self:CalculateStat( target, STAT_EVASION )
	return P >= math.random()
end

local stageCritChances = { 1/16, 1/8, 1/2, 1 }
function GM:GetCriticalHit( abilityStage )
	return math.random() <= stageCritChances[abilityStage+1] and 1.5 or 1
end

local function BaseAbility( type, name, gtype, accuracy, gp, handler )
	return {
		name = name,
		gtype = gtype,
		type = type,
		accuracy = accuracy,
		gp = gp,
		handler = handler
	}
end

local function CustomAbility( name, gtype, accuracy, gp, handler )
	return BaseAbility( ABILITY_TYPE_CUSTOM, name, gtype, accuracy, gp, handler )
end

local HANDLER = {}

function HANDLER:OnHit( user, target )
	local damage = GAMEMODE:DamageFormula( self, user, target )
    target.hp = math.max( target.hp - damage, 0 )
end

local PhysicalAbilityHandler = HANDLER
HANDLER = nil

local function PhysicalAbility( name, gtype, accuracy, gp, power )
	local abilityAttr = BaseAbility( ABILITY_TYPE_PHYSICAL, name, gtype, 
		accuracy, gp, PhysicalAbilityHandler )
	abilityAttr.power = power
    return abilityAttr
end

local HANDLER = {}

function HANDLER:OnHit( user, target )
	local abilityAttr = GAMEMODE.abilities[self.key]
	for i, effect in ipairs( abilityAttr.effects ) do
		local who = effect.who
		if who == STATUS_ABILITY_TYPE_TARGET then
			target.stats[effect.stat].stage = math.Clamp(target.stats[effect.stat].stage + effect.amount, -6, 6)
		elseif who == STATUS_ABILITY_TYPE_USER then
			user.stats[effect.stat].stage = math.Clamp(user.stats[effect.stat].stage + effect.amount, -6, 6)
		elseif who == STATUS_ABILITY_TYPE_PARTY then
			Error( "Not implemented" )
		end
	end
end

local StatusAbilityHandler = HANDLER
HANDLER = nil

local function StatusAbility( name, gtype, accuracy, gp, ... )
    local abilityAttr = BaseAbility( ABILITY_TYPE_STATUS, name, gtype, accuracy, gp, StatusAbilityHandler )
    abilityAttr.effects = {}
    for i = 1, select("#", ...), 3 do
		table.insert( abilityAttr.effects, {
				who = select(i, ...),
				stat = select(i+1, ...),
				amount = select(i+2, ...)
	   		})
    end
    return abilityAttr
end

GM.abilities = {
    Absorb = CustomAbility("Absorb", GTYPE_GRASS, 1.0, 25, AbsorbHandler),
    Acid = CustomAbility("Acid", GTYPE_POISON, 1.0, 30, AcidHandler),
    AcidArmor = StatusAbility("Acid Armor", GTYPE_POISON, -1, 20, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, 2),
    AcidSpray = CustomAbility("Acid Spray", GTYPE_POISON, 1.0, 20, AcidSprayHandler),
    Acrobatics = PhysicalAbility("Aceobatics", GTYPE_FLYING, 1.0, 15, 55),
    Acupressure = StatusAbility("Acupressure", GTYPE_NORMAL, -1, 30, STATUS_ABILITY_TYPE_TARGET, STAT_RANDOM, 2),
    AerialAce = PhysicalAbility("Aerial Ace", GTYPE_FLYING, -1, 20, 60),
    Aeroblast = CustomAbility("Aeroblast", GTYPE_FLYING, 0.95, 5, 100),
    Agility = StatusAbility("Agility", GTYPE_PSYCHIC, -1, 30, STATUS_ABILITY_TYPE_USER, STAT_SPEED, 2),
    AquaTail = PhysicalAbility("Aqua Tail", GTYPE_WATER, 0.90, 10, 90),
    Bite = PhysicalAbility("Bite", GTYPE_DARK, 1.0, 25, 60), 
    Bubble = CustomAbility("Bubble", GTYPE_WATER, 1.0, 30, BubbleHandler),
    DoubleEdge = PhysicalAbility("Double-Edge", GTYPE_NORMAL, 1.0, 15, 120),
    DragonRage = CustomAbility("Dragon Rage", GTYPE_DRAGON, 1.0, 10, DragonRageHandler), 
    Ember = CustomAbility("Ember", GTYPE_FIRE, 1.0, 25, EmberHandler),
    FireFang = PhysicalAbility("Fire Fang", GTYPE_FIRE, 0.95, 15, 65),
    FireSpin = CustomAbility("Fire Spin", GTYPE_FIRE, 0.85, 15, FireSpinHandler), 
    FlameBurst = CustomAbility("Flame Burst", GTYPE_FIRE, 1.0, 15, FlameBurstHandler), 
    Flamethrower = CustomAbility("Flamethrower", GTYPE_FIRE, 1.0, 15, FlamethrowerHandler), 
    Growl = StatusAbility("Growl", GTYPE_NORMAL, 1.0, 40, STATUS_ABILITY_TYPE_TARGET, STAT_ATTACK, -1),
    Growth = StatusAbility("Growth", GTYPE_NORMAL, -1, 20, STATUS_ABILITY_TYPE_USER, STAT_SPATTACK, 1, STATUS_ABILITY_TYPE_USER, STAT_SPDEFENSE, 1),
    HydroPump = CustomAbility("Hydro Pump", GTYPE_WATER, 0.80, 5, HydroPumpHandler),
    Inferno = CustomAbility("Inferno", GTYPE_FIRE, 0.50, 5, InfernoHandler),
    IronDefense = StatusAbility("Iron Defense", GTYPE_STEEL, -1, 15, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, 2),
    LeechSeed = CustomAbility("Leech Seed", GTYPE_GRASS, 0.9, 10, LeechSeedHandler),
    PoisonPowder = CustomAbility("Poison Powder", GTYPE_POISON, 0.75, 35, PoisonPowderHandler),
    Protect = CustomAbility("Protect", GTYPE_NORMAL, -1, 10, ProtectHandler),
    RainDance = CustomAbility("Rain Dance", GTYPE_WATER, -1, 5, RainDanceHandler),
    RapidSpin = CustomAbility("Rapid Spin", GTYPE_NORMAL, 1.0, 40, RapidSpinHandler),
    RazorLeaf = PhysicalAbility("Razor Leaf", GTYPE_GRASS, 0.95, 25, 55),
    ScaryFace = StatusAbility("Scary Face", GTYPE_NORMAL, 1.0, 10, STATUS_ABILITY_TYPE_TARGET, STAT_SPEED, -2),
    Scratch = PhysicalAbility("Scratch", GTYPE_NORMAL, 1.0, 35, 40),
    SeedBomb = PhysicalAbility("Seed Bomb", GTYPE_GRASS, 1.0, 15, 80),
    SkullBash = PhysicalAbility("Skull Bash", GTYPE_NORMAL, 1.0, 10, 130),
    Slash = PhysicalAbility("Slash", GTYPE_NORMAL, 1.0, 20, 70),
    SleepPowder = CustomAbility("Sleep Powder", GTYPE_GRASS, 0.75, 15, SleepPowderHandler),
    Smokescreen = StatusAbility("Smokescreen", GTYPE_NORMAL, 1.0, 20, STATUS_ABILITY_TYPE_TARGET, STAT_ACCURACY, -1),
    SweetScent = StatusAbility("Sweet Scent", GTYPE_NORMAL, 1.0, 20, STATUS_ABILITY_TYPE_TARGET, STAT_EVASION, -1),
    Synthesis = CustomAbility("Synthesis", GTYPE_GRASS, -1, 5, SynthesisHandler),
    Tackle = PhysicalAbility("Tackle", GTYPE_NORMAL, 1.0, 35, 50),
    TailWhip = StatusAbility("Tail Whip", GTYPE_NORMAL, 1.0, 35, STATUS_ABILITY_TYPE_TARGET, STAT_DEFENSE, -1),
    TakeDown = PhysicalAbility("Take Down", GTYPE_NORMAL, 0.85, 20, 90),
    VineWhip = PhysicalAbility("Vine Whip", GTYPE_GRASS, 1.0, 25, 45),
    WaterGun = CustomAbility("Water Gun", GTYPE_WATER, 1.0, 25, WaterGunHandler),
    WaterPulse = CustomAbility("Water Pulse", GTYPE_WATER, 1.0, 20, WaterPulseHandler),
    Withdraw = StatusAbility("Withdraw", GTYPE_WATER, -1, 40, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, 1), 
    WorrySeed = CustomAbility("Worry Seed", GTYPE_GRASS, 1.0, 10, WorrySeedHandler),
}