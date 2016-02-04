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

local countertopPosition = Vector( 769.336792, 1093.160522, 40.031250 )

function QUEST:Init()
	self.super.Init( self )
	self:RegisterHook( "OnPlayerCaptureGarrymon" )
	self:RegisterHook( "PlayerUseInteractive" )
	self.npc = self:RegisterNPC( "professorGarrycenter" )
	self.npc:Say( "Please choose your starter Garrymon." )
	self.npcChatIndex = 1
	self.balls = {}
	for i = 1, 3 do
		local ball = ents.Create("garryball")
		ball:SetPos( Vector( countertopPosition.x + (i - 2) * 16, countertopPosition.y, countertopPosition.z + 2.7 ) )
		GAMEMODE:MakeEntityCustomTransmit( ball )
		ball:AddPlayerToTransmit( self:GetPlayer() )
		ball:Spawn()
		ball:Activate()
		table.insert( self.balls, ball )
	end
	self.balls[1]:SetID( "Grass" )
	self.balls[2]:SetID( "Fire" )
	self.balls[3]:SetID( "Water" )
end

local waitForChoiceMessages = {
	"We can continue after you've made your decision.",
	"Please choose your garrymon.",
	"Use the garryball you wish to choose.",
	"Hurry up kid, make up your mind.",
}
function QUEST:OnNPCTalk( npc )
	if npc:GetID() ~= "Professor Newman" then return end
	self.npcChatIndex = (self.npcChatIndex % #waitForChoiceMessages) + 1
	self.npc:Say( waitForChoiceMessages[self.npcChatIndex] )
	return NPC_TALK_END
end

function QUEST:OnPlayerCaptureGarrymon( pl, garrymon )
	if pl ~= self:GetPlayer() then return end
	self.npc:Say( "Excellent choice!" )
	self:Complete()
end

local confirmations = {
	"Are you sure?",
	"Is this the one?",
	"Choose it again to confirm your decision."
}

function QUEST:PlayerUseInteractive( pl, ent )
	if pl ~= self:GetPlayer() then return end
	if table.HasValue( self.balls, ent ) then
		if self.selectedBall then
			self.selectedBall:SetSelected( false )
		end
		self.npcChatIndex = (self.npcChatIndex % #confirmations) + 1
		self.npc:Say( confirmations[self.npcChatIndex] )
		self.selectedBall = ent
		ent:SetSelected( true )
	end
end

function QUEST:Unload()
	self.super.Unload( self )
	for _, ball in pairs( self.balls ) do
		ball:Remove()
	end
end

quest.register( "quest1.2", QUEST )