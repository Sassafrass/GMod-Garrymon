

function GM:DamageFormula( abilityAttr, user, target )
	local lvl = user.lvl
	local attack = user.attack
	local defense = user.defense
	local base = abilityAttr.power
	local modifier = 1 -- TODO
	return math.floor(((2 * lvl + 10) / 250 * attack / defense * base + 2) * modifier)
end

-- Hit if greater than 1
function GM:HitFormula( abilityAttr, user, target )
	return abilityAttr.accuracy * self:CalculateStat( user, STAT_ACCURACY ) / self:CalculateStat( target, STAT_EVASION ) > 1
end

ABILITY_TYPE_PHYSICAL = 1
ABILITY_TYPE_STATUS = 2
ABILITY_TYPE_CUSTOM = 3

STATUS_ABILITY_TYPE_USER = 1
STATUS_ABILITY_TYPE_TARGET = 2
STATUS_ABILITY_TYPE_PARTY = 3

local function BaseAbility( type, name, gtype, accuracy, gp, handler )
	return {
		name = name,
		gtype = gtype,
		type = type,
		accuracy = accuracy,
		gp = gp,
		handler = handler
	}

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
	for i, effect in ipairs( self.effects ) do
		local who = effect.who
		if who == STATUS_ABILITY_TYPE_TARGET then
			target.stats[effect.stat].stage = target.stats[effect.stat].stage + effect.amount
		elseif who == STATUS_ABILITY_TYPE_USER then
			user.stats[effect.stat].stage = user.stats[effect.stat].stage + effect.amount
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
    local arg = {...}
    for i = 1, #arg, 3 do
    	table.insert( abilityAttr.effects, {
			who = arg[i],
			stat = arg[i+1],
			amount = arg[i+2]
   		})
    end
    return abilityAttr
end

GM.abilities = {
    --Absorb = CustomAbility("Absorb", 1.0, 25, 20, AbsorbHandler),
    --Acid = CustomAbility("Acid", 1.0, 30, 40, AcidHandler),
    AcidArmor = StatusAbility("Acid Armor", GTYPE_POISON, -1, 20, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, +2),
    --AcidSpray = CustomAbility("Acid Spray", 1.0, 20, AcidSprayHandler),
    Acrobatics = PhysicalAbility("Aceobatics", 1.0, 15, 55),
    Acupressure = StatusAbility("Acupressure", -1, 30, STATUS_ABILITY_TYPE_TARGET, STAT_RANDOM, +2),
    AerialAce = PhysicalAbility("Aerial Ace", -1, 20 60),
    --Aeroblast = CustomAbility("Aeroblast", 0.95, 5, 100),
    Agility = StatusAbility("Agility", -1, 30, STATUS_ABILITY_TYPE_USER, STAT_SPEED, +2)
    --LeechSeed = CustomAbility("Leech Seed", 0.9, 10, LeechSeedHandler),
    VineWhip = PhysicalAbility("Vine Whip", 1.0, 25, 45),
    --PoisonPowder = CustomAbility("Poison Powder", 0.75, 35, PoisonPowderHandler),
    --SleepPowder = CustomAbility("Sleep Powder", 0.75, 15, SleepPowderHandler),
    TakeDown = PhysicalAbility("Take Down", 0.85, 20, 90),
    RazorLeaf = PhysicalAbility("Razor Leaf", 0.95, 25, 55),
    SweetScent = StatusAbility("Sweet Scent"1.0, 20, STATUS_ABILITY_TYPE_TARGET, STAT_EVASION, -1),
    Growth = StatusAbility("Growth", -1, 20, STATUS_ABILITY_TYPE_USER, STAT_SPATTACK, +1, STATUS_ABILITY_TYPE_USER, STAT_SPDEFENSE, +1),
    DoubleEdge = PhysicalAbility("Double-Edge", 1.0, 15, 120),
    --WorrySeed = CustomAbility("Worry Seed", 1.0, 10, WorrySeedHandler),
    --Synthesis = CustomAbility("Synthesis", -1, 5, SynthesisHandler),
    SeedBomb = PhysicalAbility("Seed Bomb", 1.0, 15, 80),
    --Ember = CustomAbility("Ember", 1.0, 25, 40, EmberHandler),
    Smokescreen = StatusAbility("Smokescreen", 1.0, 20, STATUS_ABILITY_TYPE_TARGET, STAT_ACCURACY, -1),
    --DragonRage = CustomAbility("Dragon Rage", 1.0, 10, DragonRageHandler), 
    ScaryFace = StatusAbility("Scary Face", 1.0, 10. STATUS_ABILITY_TYPE_TARGET, STAT_SPEED, -2),
    FireFang = PhysicalAbility("Fire Fang", 0.95, 15, 65),
    --lameBurst = CustomAbility("Flame Burst", 1.0, , 70, FlameBurstHandler), 
    Slash = PhysicalAbility("Slash", 1.0, 20, 70),
    --Flamethrower = CustomAbility("Flamethrower", 1.0, 15, 90 FlamethrowerHandler), 
    --FireSpin = CustomAbility("Fire Spin", 0.85, 15, 35, FireSpinHandler), 
    --Inferno = CustomAbility("Inferno", 0.50, 5, 100, InfernoHandler),
    --WaterGun = CustomAbility("Water Gun", 1.0, 25, 40, WaterGunHandler),
    Withdraw = StatusAbility("Withdraw", -1, 40, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, +1), 
    --Bubble = CustomAbility("Bubble", 1.0, 30, 40, BubbleHandler),
    Bite = PhysicalAbility("Bite", 1.0, 25, 60), 
    --RapidSpin = CustomAbility("Rapid Spin", 1.0, 40, 20, RapidSpinHandler),
	--Protect = CustomAbility("Protect", -1, 10, ProtectHandler),
	--WaterPulse = CustomAbility("Water Pulse", 1.0, 20, 60, WaterPulseHandler),
	AquaTail = PhysicalAbility("Aqua Tail", 0.90, 10, 90),
	SkullBash = PhysicalAbility("Skull Bash", 1.0, 10, 130),
	IronDefense = StatusAbility("Iton Defense", -1, 15, STATUS_ABILITY_TYPE_USER, STAT_DEFENSE, +2),
	--RainDance = CustomAbility("Rain Dance", -1, 5, RainDanceHandler),
	--HydroPump = CustomAbility("Hydro Pump", 0.80, 5, 110, HydroPumpHandler),
	Growl = StatusAbility("Growl", 1.0, 40, STATUS_ABILITY_TYPE_TARGET, STAT_ATTACK, -1),
	Tackle = PhysicalAbility("Tackle", 1.0, 35, 50),
	Scratch = PhysicalAbility("Scratch", 1.0, 35, 40),
	TailWhip = StatusAbility("Tail Whip", 1.0, 35, STATUS_ABILITY_TYPE_TARGET, STAT_DEFENSE, -1),
