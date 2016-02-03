local QUEST = {}

QUEST.description = "Find and talk to Professor Newman."

function QUEST:Init()
	self.super.Init( self )
	self.messageIndex = 1
	self.npc = self:RegisterNPC( "professorGarrycenter" )
end

function QUEST:OnNPCTalk( npc )
	if npc:GetID() ~= "Professor Newman" then return end
	if self.messageIndex == 1 then
		npc:Say( "Hello! I am the professor." )
		local layerID = npc:AddGestureSequence( npc:LookupSequence("Wave") )
		npc:SetLayerWeight( layerID, 0.0 )
		npc:SetLayerBlendIn( layerID, 0.5 )
		npc:SetLayerBlendOut( layerID, 0.5 )
		self.messageIndex = 2
		return NPC_TALK_YIELD
	else
		self:Complete()
		return NPC_TALK_FINAL
	end
end

function QUEST:OnComplete()
	quest.giveToPlayer( self:GetPlayer(), "quest1.2" )
end

function QUEST:Unload()
	self.super.Unload( self )
end

quest.register( "quest1.1", QUEST )


local QUEST = {}

QUEST.description = "Choose a starter Garrymon."

function QUEST:Init()
	self.super.Init( self )
	self:RegisterHook( "OnPlayerCaptureGarrymon" )
	self.npc = self:RegisterNPC( "professorGarrycenter" )
	self.npc:Say( "Please choose your starter Garrymon." )
end

function QUEST:OnNPCTalk( npc )
	if npc:GetID() ~= "Professor Newman" then return end
	npc:Say( "We can continue after you've made your decision." )
	return NPC_TALK_END
end

function QUEST:OnPlayerCaptureGarrymon( pl, garrymon )
	if pl ~= self:GetPlayer() then return end
	self.npc:Say( "Excellent choice!" )
	self:Complete()
end

function QUEST:Unload()
	self.super.Unload( self )
	hook.Remove( "OnPlayerCaptureGarrymon", self )
end

quest.register( "quest1.2", QUEST )