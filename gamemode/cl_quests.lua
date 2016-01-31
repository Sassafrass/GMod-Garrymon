local quests = {}

net.Receive( "QuestLog:AddQuest", function( len )
	local questIndex = net.ReadInt( 16 )
	local questName = net.ReadString()
	local questDescription = net.ReadString()
	table.insert( quests, questIndex, questDescription )
	print( "Got quest ", questDescription )
end )