local QUEST = {}
QUEST.__index = QUEST
QUEST.description = "A quest."

AccessorFunc( QUEST, "player", "Player" )

function QUEST:IsValid()
	return true
end

function QUEST:GetDescription()
	return self.description
end

function QUEST:Init()
	self._hooks = {}
	self._npcs = {}
end

function QUEST:OnComplete()
end

function QUEST:Unload()
	for hookName, _ in pairs( self._hooks ) do
		hook.Remove( hookName, self )
	end
	for npc, _ in pairs( self._npcs ) do
		npc:RemoveController( self )
	end
end

function QUEST:__tostring()
	return "Quest ["..tostring(self.name).."]"
end

function QUEST:RegisterHook( hookName )
	self._hooks[hookName] = true
	hook.Add( hookName, self, self[hookName] )
end

function QUEST:RegisterNPC( npcKey, controller, setup )
	local npc = GAMEMODE:SpawnNPCForPlayer( npcKey, self:GetPlayer(), setup )
	npc:AddController( self, controller )
	self._npcs[npc] = true
	return npc
end


quest.register( "base_quest", QUEST )