NPC_TALK_YIELD = 1 -- THE NPC HAS MORE TO SAY
NPC_TALK_END = 2 -- THE NPC HAS SAID WHAT HE NEEDS TO SAY
NPC_TALK_FINAL = 3 -- THE NPC HAS NO MORE TO SAY

function GM:SpawnNPCForPlayer( npcClass, pl, setup )

	pl.npcs = pl.npcs or {}
	if pl.npcs[npcClass] then return pl.npcs[npcClass] end

    local npc = ents.Create( "npc_" .. npcClass )
    npc:SetKeyValue( "spawnflags", bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK ) )

    if setup then
    	setup(npc)
    end

    self:MakeEntityCustomTransmit( npc )
    npc:AddPlayerToTransmit( pl )

    npc:Spawn()
    npc:Activate()
    npc:DropToFloor()

    pl.npcs[npcClass] = npc

    return npc, true
    
end

function GM:SpawnNPCs()

	-- Spawn global npcs here
	
end