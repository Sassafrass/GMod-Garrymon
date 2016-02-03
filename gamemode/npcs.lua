NPC_TALK_YIELD = 1 -- THE NPC HAS MORE TO SAY
NPC_TALK_END = 2 -- THE NPC HAS SAID WHAT HE NEEDS TO SAY
NPC_TALK_FINAL = 3 -- THE NPC HAS NO MORE TO SAY

local npcTemplates = {}
npcTemplates["professorGarrycenter"] = {
	class = "npc_professor",
	name = "Professor Newman",
	origin = Vector(768.174133, 1137.295044, 0.031250),
	angles = Angle(0, -90, 0),
}

function GM:SpawnNPCForPlayer( templateKey, pl )

	pl.npcs = pl.npcs or {}
	if pl.npcs[templateKey] then return pl.npcs[templateKey] end

	local template = npcTemplates[ templateKey ]
    local npc = ents.Create( template.class )
    npc:SetID( template.name )
    npc:SetPos( template.origin )
    npc:SetAngles( template.angles )
    npc:SetKeyValue( "spawnflags", bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK ) )

    self:MakeEntityCustomTransmit( npc )
    npc:AddPlayerToTransmit( pl )

    npc:Spawn()
    npc:Activate()
    npc:DropToFloor()

    pl.npcs[templateKey] = npc

    return npc
    
end

function GM:SpawnNPCs()

	-- Spawn global npcs here
	
end

function GM:NPCRegisterTalker( npc, talker )
	npc.talkers = npc.talkers or {}
	npc.talkerIndex = npc.talkerIndex or 1
	table.insert( npc.talkers, talker )
end

function GM:NPCUnregisterTalker( npc, talker )
	if npc.talkers[npc.talkerIndex] == talker then
		npc.talkerIndex = 1
	end
	table.RemoveByValue( npc.talkers, talker )
end

function GM:PlayerTalkToNPC( pl, npc )

	if not npc.talkers then return end

	local startIndex = npc.talkerIndex
	repeat
		local talkStatus = npc.talkers[npc.talkerIndex]:OnNPCTalk( npc, pl )
		if talkStatus ~= NPC_TALK_YIELD then
			break
		else
			npc.talkerIndex = (npc.talkerIndex % #npc.talkers) + 1
			if talkStatus == NPC_TALK_END then break end
		end
	until npc.talkerIndex == startIndex

end