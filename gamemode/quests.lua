quest = {}
quest.quests = {}

-------------------------
-- QUEST LOG
-------------------------

local QuestLog = {}
local QuestLog_mt = { __index = QuestLog }

AccessorFunc( QuestLog, "player", "Player" )
AccessorFunc( QuestLog, "id", "ID" )

function QuestLog:Init( pl )
	self.completed = {}
	self.quests = {}
	pl.questLog = self
	self:SetPlayer( pl )
	self:SetID( pl:SteamID() )
	self.completeInternal = function( q )
		self:Complete( q )
	end
end

util.AddNetworkString( "QuestLog:AddQuest" )
function QuestLog:AddQuest( name )
	if not quest.quests[ name ] then
		Error( "Attempt to add non-existent quest ", name )
	end
	local q = {}
	setmetatable( q, quest.quests[name] )
	q.__index = quest.quests[name]
	table.insert( self.quests, q )
	q.owner = self:GetPlayer()
	q.Complete = self.completeInternal
	q:Init()
	net.Start( "QuestLog:AddQuest" )
		net.WriteInt( #self.quests, 16 )
		net.WriteString( name )
		net.WriteString( q.description )
	net.Send( self:GetPlayer() )
end

function QuestLog:Complete( q )
	table.RemoveByValue( self.quests, q )
	self.completed[q.name] = true
	q:OnComplete()
	gamemode.Call( "OnPlayerCompletedQuest", self:GetPlayer(), q.name )
end

function QuestLog:Unload()
	for _, q in pairs(self.quests) do
		q:Unload()
	end
end

--------------------------


function quest.register( name, table )
	quest.quests[ name ] = table
	table.name = name
	if name ~= "base_quest" then
		table.super = quest.quests[ "base_quest" ]
		setmetatable( table, table.super )
		table.__index = table
		table.__tostring = table.super.__tostring
	end
end

function quest.createQuestLog( pl )
	local ql = {}
	setmetatable( ql, QuestLog_mt )
	ql:Init( pl )
	return ql
end

function quest.giveToPlayer( pl, questName )
	pl.questLog:AddQuest( questName )
end

function GM:OnPlayerCompletedQuest( pl, questName )
end

include("quests/base_quest.lua")
include("quests/quest1.lua")