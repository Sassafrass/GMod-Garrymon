--[[---------------------------------------------------------
Name: Garrymon
Desc: Pokemon in garrysmod
-----------------------------------------------------------]]

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_battleinfo.lua")
include("shared.lua")
include("items.lua")
include("garrymon.lua")

-- Add resources here
--resource.AddFile("materials/ttd/rail.vmt")

local pl

function GM:PlayerInitialSpawn(ply)
	pl = ply
	pl.inventory = {}
	pl.garrymons = {}
 
 	if not self.thread then
		self.thread = coroutine.create( self.Loop )
		local ok, res = coroutine.resume( self.thread, self )
	    if not ok then
	        pl:ChatPrint( res )
	    end
	end
end

function GM:PlayerSpawn(pl)

	pl:SetModel( "models/player/kleiner.mdl" )

end

local name
local javier = {}
javier.garrymons = {}
 
local GAMESTATE_NAME = 1
local GAMESTATE_CHOOSE = 2
local GAMESTATE_PLAYING = 3
local GAMESTATE_WAITFORHEAL = 4
 
local function readInput()
    while true do
        local text = coroutine.yield()
        if text then
            pl:ChatPrint( " > " .. text )
            return text
        end
    end
end

local waitEndTime
local function wait( seconds )
	waitEndTime = CurTime() + seconds
	return coroutine.yield(coroutine.running())
end

function GM:Loop()
    self:SetState( GAMESTATE_NAME )
    name = readInput()
    self:AddChatDelayed( "Professor", "Hello " .. name )
    self:SetState( GAMESTATE_CHOOSE )
    self:SetState( GAMESTATE_PLAYING )
    while true do
        local text = readInput()
        if self.state == GAMESTATE_PLAYING then
            text = string.lower(text)
            if text == "inv" or text == "inventory" then
                self:DisplayInventory()
            end
        end
    end
end
 
local delayedChats = {}
function GM:AddChatDelayed( sayer, chat )
	wait(0.2)
    pl:ChatPrint("<c=255,255,0>"..sayer.."</c>: " .. chat)
end
function GM:ActionMessage( msg )
	wait(0.2)
    pl:ChatPrint("<c=200,50,50>*"..msg.."*</c>")
end
function GM:ChoiceMessage( msg )
	wait(0.2)
    pl:ChatPrint("\t<c=0,255,0>"..msg.."</c>")
end
 
function GM:GiveItem( itemKey )
	wait(0.2)
    table.insert( pl.inventory, itemKey )
    pl:ChatPrint( "<c=100,150,255>Got " .. self.items[ itemKey ].name .. "</c>" )
end
 
function GM:DoChoice( ... )
    local arg={...}
    for i, v in ipairs(arg) do
        self:ChoiceMessage( i .. ". " .. v )
    end
    local choice = tonumber(readInput())
    while not (choice and choice > 0 and choice <= #arg) do
        pl:ChatPrint( "Invalid choice" )
        choice = tonumber(readInput())
    end
    return choice
end

util.AddNetworkString( "BattleUpdate" )
function GM:DisplayFight( gmon, enemy )
	net.Start( "BattleUpdate" )
		net.WriteBool( true )
		net.WriteString( gmon.name )
		net.WriteInt( gmon.lvl, 16 )
		net.WriteInt( gmon.hp, 16 )
		net.WriteInt( gmon.maxhp, 16 )
		net.WriteString( enemy.name )
		net.WriteInt( enemy.lvl, 16 )
		net.WriteInt( enemy.hp, 16 )
		net.WriteInt( enemy.maxhp, 16 )
	net.Send( pl )
end
 
function GM:UseAbility( ability, gmon, enemy )
    self:ActionMessage( gmon.name .. " uses " .. ability.name .. "!" )
    enemy.hp = math.max( enemy.hp - ability.dmg, 0 )
    ability.gp = ability.gp - 1
end
 
function GM:ChooseAttack( abilities )
    local abilityChoices = {}
    for _, ability in ipairs(abilities) do
        table.insert( abilityChoices, ability.name .. " (" .. ability.gp .. "/" .. ability.maxgp .. ")" )
    end
    table.insert( abilityChoices, "Back" )
    while true do
        local choice = self:DoChoice( unpack( abilityChoices ) )
        if choice < #abilityChoices then
            local ability = abilities[choice]
            if ability.gp == 0 then
                self:ActionMessage("Not enough gp")
            else
                return ability
            end
        else return end
    end
end
 
function GM:ChooseItem()
    local itemChoices = {}
    for _, itemKey in ipairs(pl.inventory) do
        table.insert( itemChoices, self.items[itemKey].name )
    end
    table.insert( itemChoices, "Back" )
    local choice = self:DoChoice( unpack( itemChoices ) )
    if choice < #itemChoices then
        return self.items[pl.inventory[choice]]
    else return end
end
 
function GM:ChooseGarrymon()
   
    local garrymonChoices = {}
    for _, gmon in ipairs(pl.garrymons) do
        table.insert( garrymonChoices, gmon.name .. "(" .. gmon.hp .. "/" .. gmon.maxhp .. ")" )
    end
    table.insert( garrymonChoices, "Back" )
    local choice = self:DoChoice(unpack(garrymonChoices) )
    if choice < #garrymonChoices then
        return pl.garrymons[choice]
    else return end
   
end
 
function GM:UseItem( item )
    while true do
        local gmon = self:ChooseGarrymon()
        if gmon then
            if item.type == ITEM_TYPE_POTION then
                if item.potionType == POTION_TYPE_HEALTH then
                    gmon.hp = math.min(gmon.hp + item.healAmount, gmon.maxhp)
                    self:ActionMessage( gmon.name .. " healed " .. item.healAmount .. " points to " .. gmon.hp )
                    break
                elseif item.potionType == POTION_TYPE_HEALTH_PERCENT then
                    local healAmount = math.floor(item.healAmount / 100 * gmon.maxhp)
                    gmon.hp = math.min(gmon.hp + healAmount, gmon.maxhp)
                    self:ActionMessage( gmon.name .. " healed " .. healAmount .. " points to " .. gmon.hp )
                    break
                elseif item.potionType == POTION_TYPE_GP then
                    local ability = self:ChooseAttack( gmon.abilities )
                    if ability then
                        ability.gp = math.min(ability.gp + item.healAmount, ability.maxgp)
                        self:ActionMessage( gmon.name .. "'s " .. ability.name .. " ability's gp was raised " .. item.healAmount .. " points" )
                        break
                    end
                end
            end
        else return end
    end
    table.RemoveByValue( pl.inventory, item.key )
    return true
end
 
function GM:FightMenu( gmon, enemy )
    while true do
        local choice = self:DoChoice( "Attack", "Items", "Pokemon", "Run" )
        if choice == 1 then
            local attack = self:ChooseAttack( gmon.abilities )
            if attack then
                self:UseAbility( attack, gmon, enemy )
                break
            end
        elseif choice == 2 then
            local item = self:ChooseItem()
            print( item )
            if item and self:UseItem( item ) then
                break
            end
        elseif choice == 3 then
        elseif choice == 4 then
            self:ActionMessage("You cannot run")
        end
    end
end
 
local function gainFormula( gmon, fainted )
    a = fainted.wild and 1 or 1.5
    b = math.pow( fainted.lvl, 3 )
    e = gmon.holding == "LuckyEgg" and 1.5 or 1
    v = gmon.lvl > gmon.evolves[1] and 1.2 or 1
    L = fainted.lvl
    s = 1
    return math.floor(a * b * e * L * v / (7 * s))
end
 
function GM:IncreaseStat( gmon, name, key, amount )
    local oldValue = gmon[key]
    gmon[key] = gmon[key] + amount
    self:ActionMessage( name .. " (" .. oldValue .. "</c><c=0,255,0>+" .. amount ..
        "</c><c=255,0,0>) -> </c><c=255,255,0>" .. gmon[key] .. "</c><c=255,0,0>" )
end
 
function GM:GainExperience( gmon, amount )
    self:ActionMessage( gmon.name .. " has gained " .. amount .. " experience" )
    gmon.exp = gmon.exp + amount
    if gmon.exp > gmon.maxexp then
        self:ActionMessage( gmon.name .. " has leveled up!" )
        gmon.maxexp = math.pow( gmon.lvl, 3 )
        self:IncreaseStat( gmon, "Lvl", "lvl", 1 )
        self:IncreaseStat( gmon, "Hp", "maxhp", 4 )
        self:IncreaseStat( gmon, "Att", "attack", 4 )
        self:IncreaseStat( gmon, "Def", "defense", 4 )
        self:IncreaseStat( gmon, "Sp.Att", "spattack", 3 )
        self:IncreaseStat( gmon, "Sp.Def", "spdefense", 2 )
        self:IncreaseStat( gmon, "Spd", "speed", 3 )
        if gmon.lvl > gmon.evolves[1] then
            self:ChoiceMessage( "Do you want " .. gmon.name .. " to evolve?" )
            local choice = self:DoChoice( "Yes", "No" )
            if choice == 1 then
                self:ActionMessage( gmon.name .. " has evolved into " .. gmon.evolves[2] )
                -- TODO handle evolution
            end
        end
    end
end
 
function GM:Fight(gmon, enemy)
    local whoseTurn = gmon
    while true do
        self:DisplayFight( gmon, enemy )
        if gmon.hp <= 0 then
            self:ActionMessage( gmon.name .. " has fainted" )
            --self:GainExperience( enemy, gainFormula( enemy, gmon ) )
            return false
        elseif enemy.hp <= 0 then
            self:ActionMessage( enemy.name .. " has fainted" )
            self:GainExperience( gmon, gainFormula( gmon, enemy ) )
            return true
        end
        if whoseTurn == gmon then
            self:FightMenu( gmon, enemy )
            whoseTurn = enemy
        else
            -- ARTIFICIAL INTELLIGENCE?!
            for _, ability in RandomPairs(enemy.abilities) do
                if ability.gp > 0 then
                    self:UseAbility( ability, enemy, gmon )
                    break
                end
            end
            whoseTurn = gmon
        end
    end
end
 
function GM:BeginFight()
    local gmon = pl.garrymons[1]
    local gmon2 = javier.garrymons[1]
    self:AddChatDelayed(name, "Go "..gmon.name.."! I choose you!")
    self:ActionMessage("You throw your garryball.")
    self:AddChatDelayed("Javier", "I see you chose "..gmon.name..
        ". That's good because I chose "..gmon2.name..".")
    self:ActionMessage("Javier throws his garryball.")
    local win = self:Fight(gmon, gmon2)

	net.Start( "BattleUpdate" )
		net.WriteBool( false )
	net.Send( pl )

    if win then
        self:AddChatDelayed("Javier", "What the fuck? How did I lose to you?")
        wait( 2 )
        self:AddChatDelayed("Javier", "Next time we fight you're going down, I'm going to bust your nut!")
        wait( 2 )
        self:ActionMessage("Javier storms out of the room")
        wait( 2 )
        self:AddChatDelayed("Professor", "You should heal your garrymon before going out.")
        wait( 1 )
        self:AddChatDelayed("Professor", "Type <c=0,255,0>inv</c> to open your inventory and use your healing potion to heal " .. gmon.name .. ".")
        self:SetState( GAMESTATE_WAITFORHEAL )
        wait( 2 )
        self:AddChatDelayed("Professor", "Also, it's dangerous to go alone. Take this" )
        self:ActionMessage( "Got garrydex" )
    else
    end
end
 
function GM:SetState( state )
    if state == GAMESTATE_NAME then
        self:AddChatDelayed("Professor", "Hello! My name is Professor Newman. What is your name?")
    elseif state == GAMESTATE_CHOOSE then
        if self.state == GAMESTATE_NAME then
            self:AddChatDelayed("Professor", "What garrymon would you like to start with?" )
        end
        while true do
            local choice = self:DoChoice( "Muberry", "Umlaut", "Firedash" )
            local playerChoice, rivalChoice
            if choice == 1 then
                playerChoice = self.garrymons.Muberry
                rivalChoice = self.garrymons.Firedash
            elseif choice == 2 then
                playerChoice = self.garrymons.Umlaut
                rivalChoice = self.garrymons.Muberry
            else
                playerChoice = self.garrymons.Firedash
                rivalChoice = self.garrymons.Umlaut
            end
            pl:ChatPrint( "You have chosen " .. playerChoice.name .. " a " .. playerChoice.type .. " type garrymon." )
            pl:ChatPrint( "Are you sure?" )
            local choice = self:DoChoice( "Yes", "No" )
            if choice == 1 then
                table.insert(pl.garrymons, table.Copy(playerChoice))
                table.insert(javier.garrymons, table.Copy(rivalChoice))
                break
            end
        end
    elseif state == GAMESTATE_PLAYING and self.state == GAMESTATE_CHOOSE then
        self:AddChatDelayed("Professor", "Great choice! Here are some starter items..")
        self:GiveItem( "PotionHealing" )
        self:GiveItem( "PotionHealing" )
        self:GiveItem( "BallGarry" )
        self:ActionMessage("An unknown person barges into the room")
        self:AddChatDelayed("???", "Yo pops, let me get my garrymon!")
        self:ActionMessage("The mysterious person grabs one of the garryballs")
        self:ActionMessage("He turns to you with his garryball in hand")
        self:AddChatDelayed("Javier", "I'm Javier. Who the fuck are you? Wanna fight?")
        local choice = self:DoChoice( "Yes", "No" )
        if choice == 2 then
            self:AddChatDelayed("Javier", "You're funny. We're doing this.")
        end
        self:BeginFight()
    end
 
    self.state = state
end
 
function GM:DisplayInventory()
    local display = {}
    for i, itemKey in ipairs(pl.inventory) do
        if not display[itemKey] then
            display[itemKey] = {name = self.items[itemKey].name, count = 1}
        else
            display[itemKey].count = display[itemKey].count + 1
        end
    end
    pl:ChatPrint( "You have: " )
    for _, v in pairs( display ) do
        pl:ChatPrint( v.name .. " x" .. v.count )
    end
    while true do
        local choice = self:DoChoice( "Ok", "Use Item" )
        if choice == 1 then break
        elseif choice == 2 then
            local item = self:ChooseItem()
            if item and self:UseItem( item ) then break end
        end
    end
end
 
function GM:PlayerSay( pl, text, isTeam )
	if waitEndTime then
		waitEndTime = nil
		coroutine.resume( self.thread )
	end
	
    local ok, res = coroutine.resume( self.thread, text )
    if not ok then
        pl:ChatPrint( res )
    end
    return false
end

function GM:Think()
	if waitEndTime and CurTime() >= waitEndTime then
		waitEndTime = nil
		coroutine.resume( self.thread )
	end
end