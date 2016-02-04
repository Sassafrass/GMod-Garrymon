quest = {}
quest.quests = {}

SOUND_QUEST_COMPLETE = "common/bugreporter_succeeded.wav"
SOUND_QUEST_ACQUIRE = "common/warning.wav"
util.PrecacheSound(SOUND_QUEST_COMPLETE)
util.PrecacheSound(SOUND_QUEST_ACQUIRE)

net.Receive( "QuestLog:AddQuest", function( len )
	local questIndex = net.ReadInt( 16 )
	local questName = net.ReadString()
	local questDescription = net.ReadString()
	table.insert( quest.quests, questIndex, questDescription )
	surface.PlaySound(SOUND_QUEST_ACQUIRE)
end )

net.Receive( "QuestLog:CompletedQuest", function( len )
	surface.PlaySound(SOUND_QUEST_COMPLETE)
	local questIndex = net.ReadInt( 16 )
	table.remove( quest.quests, questIndex )
end	)

local color = Color( 255, 255, 255, 255 )
local shadowColor = Color( 0, 0, 0, 255 )
function quest.Paint()
	draw.SimpleTextOutlined( "Quests", "GarrymonLarge", 
		ScrW() * 0.05, ScrH() * 0.1, 
		color, 0, 0, 2, shadowColor )
	for i = 1, #quest.quests do
		draw.SimpleTextOutlined( quest.quests[i], "GarrymonMedium", 
			ScrW() * 0.075, ScrH() * 0.1 + i * ScreenScale(16), 
			color, 0, 0, 2, shadowColor )
	end
end