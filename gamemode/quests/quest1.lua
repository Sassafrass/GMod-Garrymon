local QUEST = {}

QUEST.description = "Find and talk to Professor Newman."

function QUEST:Init()
	self.super.Init( self )
	self:RegisterHook( "OnPlayerTalkToNPC" )
end

function QUEST:OnPlayerTalkToNPC(pl, npc)
	if pl ~= self.owner then return end
	if npc:GetID() == "Professor Newman" then
		self:Complete()
	end
end

function QUEST:OnComplete()
	quest.giveToPlayer( self.owner, "quest1.2" )
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
end

function QUEST:OnPlayerCaptureGarrymon( pl, garrymon )
	if pl ~= self.owner then return end
	self:Complete()
end

function QUEST:Unload()
	self.super.Unload( self )
	hook.Remove( "OnPlayerCaptureGarrymon", self )
end

quest.register( "quest1.2", QUEST )