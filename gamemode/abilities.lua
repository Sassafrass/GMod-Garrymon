

function GM:DamageFormula( ability, user )
	local lvl = user.lvl
	local attack = user.attack
	local defense = user.defense
	local base = ability.power
	local modifier = 1 -- TODO
	return math.floor(((2 * lvl + 10) / 250 * attack / defense * base + 2) * modifier)
end

-- Hit if greater than 1
function GM:HitFormula( ability, user, target )
	return ability.accuracy * self:CalculateStat( user, STAT_ACCURACY ) / self:CalculateStat( target, STAT_EVASION ) > 1
end

ABILITY_TYPE_PHYSICAL = 1
ABILITY_TYPE_STATUS = 2
ABILITY_TYPE_CUSTOM = 3

STATUS_ABILITY_TYPE_USER = 1
STATUS_ABILITY_TYPE_TARGET = 2
STATUS_ABILITY_TYPE_PARTY = 3

local function CustomAbility( name, accuracy, gp, handler )
	return {
		name = name,
		type = ABILITY_TYPE_CUSTOM,
		accuracy = accuracy,
		gp = gp,
		handler = handler
	}
end

local HANDLER = {}

function HANDLER:OnHit( user, target )
end

function HANDLER:OnTargetTurn( user, target )
end

local PhysicalAbilityHandler = HANDLER
HANDLER = nil

local function PhysicalAbility( name, accuracy, gp, power )
    return {
        name = name,
        type = ABILITY_TYPE_PHYSICAL,
        accuracy = accuracy,
        gp = gp,
        power = power,
        handler = PhysicalAbilityHandler
    }
end

local function StatusAbility( name, accuracy, gp, stat, statType, power )
    return {
        name = name,
        type = ABILITY_TYPE_STATUS,
        statType = statType,
        accuracy = accuracy,
        gp = gp,
        stat = stat,
        power = power
        handler = StatusAbilityHandler
    }
end

GM.abilities = {
	Tackle = PhysicalAbility("Tackle", 1.0, 35, 50),
	Growl = StatusAbility("Growl", 1.0, 40, STAT_ATTACK, STATUS_ABILITY_TYPE_TARGET, -1),
	Scratch = PhysicalAbility("Scratch", 1.0, 35, 40),
	TailWhip = StatusAbility("Tail Whip", 1.0, 35, STAT_DEFENSE, STATUS_ABILITY_TYPE_TARGET, -1),
	LeechSeed = CustomAbility("Leech Seed", 0.9, 10, 40),
	VineWhip = PhysicalAbility("Vine Whip", 1.0, 25, 45),
	PoisonPowder = StatusAbility("Poison Powder", 0.75, 35, ),
}