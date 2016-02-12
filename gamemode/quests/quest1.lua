local professorPos = Vector(768.174133, 1137.295044, 0.031250)
local professorAng = Angle(0, -90, 0)


------------------------------------
-- QUEST 1.1
------------------------------------

local QUEST = {}

QUEST.description = "Find and talk to Professor Newman."

function QUEST:Init()
	self.super.Init( self )
	self.npc = self:RegisterNPC( "professor", self.ControlProfessor, function(npc)
	    npc:SetPos( professorPos )
	    npc:SetAngles( professorAng )
	end )
end

function QUEST:ControlProfessor( prof )
	prof:WaitForTalk()
	prof:Say( "Hello! I am the professor" )
	prof:PlaySequenceAndWait("Wave")
	prof:WaitForTalk()
	self:Complete()
end

function QUEST:OnComplete()
	quest.giveToPlayer( self:GetPlayer(), "quest1.2" )
end

function QUEST:Unload()
	self.super.Unload( self )
end

quest.register( "quest1.1", QUEST )


------------------------------------
-- QUEST 1.2
------------------------------------

local QUEST = {}

QUEST.description = "Choose a starter Garrymon."

local countertopPosition = Vector( 769.336792, 1093.160522, 40.031250 )

function QUEST:Init()
	self.super.Init( self )
	self:RegisterHook( "PlayerUseInteractive" )

	self.npcChatIndex = 1
	self.npc = self:RegisterNPC( "professor", self.ControlProfessor, function(npc)
	    npc:SetPos( professorPos )
	    npc:SetAngles( professorAng )
	end )

	self.npc:Say( "Please choose your starter Garrymon." )
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

local starters = {
	Grass = "Muberry",
	Fire = "Firedash",
	Water = "Umlaut",
}

local waitForChoiceMessages = {
	"We can continue after you've made your decision.",
	"Please choose your garrymon.",
	"Use the garryball you wish to choose.",
	"Hurry up kid, make up your mind.",
}

function QUEST:ControlProfessor( prof )
	local messageIndex = 1
	while true do
		prof:WaitForTalk()
		messageIndex = (messageIndex % #waitForChoiceMessages) + 1
		prof:Say( waitForChoiceMessages[messageIndex] )
	end
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
			if self.selectedBall == ent then
				local gmon = garrymon.Create( starters[ent:GetID()] )
				GAMEMODE:PlayerCaptureGarrymon( self:GetPlayer(), gmon )
				self.npc:Say( "Excellent choice!" )
				self.npc:SetTalk(false)
				self:Complete()
				return
			else
				self.selectedBall:SetSelected( false )
			end
		end
		self.npcChatIndex = (self.npcChatIndex % #confirmations) + 1
		self.npc:Say( confirmations[self.npcChatIndex] )
		self.selectedBall = ent
		ent:SetSelected( true )
	end
end

function QUEST:OnComplete()
	quest.giveToPlayer( self:GetPlayer(), "quest1.3" )
end


function QUEST:Unload()
	self.super.Unload( self )
	for _, ball in pairs( self.balls ) do
		ball:Remove()
	end
end

quest.register( "quest1.2", QUEST )

------------------------------------
-- QUEST 1.3
------------------------------------

local QUEST = {}

QUEST.hidden = true
QUEST.description = "Javier talks to professor."

local javierPos = Vector(987.121765, 1255.026367, 0.031250)

function QUEST:Init()
	self.super.Init( self )

	self.professor = self:RegisterNPC( "professor", self.ControlProfessor, function(npc)
	    npc:SetPos( professorPos )
	    npc:SetAngles( professorAng )
	end )

	self.javier = self:RegisterNPC( "javier", self.ControlJavier, function(npc)
		npc:SetPos( javierPos )
	end )

end

function QUEST:ControlProfessor( prof )
end


util.AddNetworkString( "gmon.LookAt" )
function QUEST:ControlJavier( javier )

	javier:StartActivity( ACT_RUN )
	javier.loco:SetDesiredSpeed( 300 )

	net.Start( "gmon.LookAt" )
		net.WriteEntity( javier )
	net.Send( self:GetPlayer() )
	javier:MoveToPos( Vector(847.167847, 1070.160889, 0.031250) )
	javier:StartActivity( ACT_IDLE )
    javier:Say( "Yo pops, let me get my garrymon!" )
    javier:WaitForTalk()
    javier:FaceNearestPlayer()
    javier:Say( "Who the fuck are you?" )
    javier:WaitForTalk()
    javier:SetID("Javier")
    javier:Say( "I'm Javier. Want to fight?" )
    javier:WaitForTalk()

end

function QUEST:Run()
	self:WaitFor(NPCToReachTarget)
end

function QUEST:Unload()
	self.super.Unload( self )
	for _, ball in pairs( self.balls ) do
		ball:Remove()
	end
end

quest.register( "quest1.3", QUEST )