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

function GM:OnPlayerTalkToNPC( pl, npc )
end