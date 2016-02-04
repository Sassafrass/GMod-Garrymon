local quests = {}

SOUND_QUEST_COMPLETE = "common/bugreporter_succeeded.wav"
SOUND_QUEST_ACQUIRE = "common/warning.wav"
util.PrecacheSound(SOUND_QUEST_COMPLETE)
util.PrecacheSound(SOUND_QUEST_ACQUIRE)

net.Receive( "QuestLog:AddQuest", function( len )
	local questIndex = net.ReadInt( 16 )
	local questName = net.ReadString()
	local questDescription = net.ReadString()
	table.insert( quests, questIndex, questDescription )
	surface.PlaySound(SOUND_QUEST_ACQUIRE)
end )

net.Receive( "QuestLog:CompletedQuest", function( len )
	surface.PlaySound(SOUND_QUEST_COMPLETE)
end	)