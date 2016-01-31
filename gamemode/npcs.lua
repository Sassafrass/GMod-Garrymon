function GM:SpawnNPCs()
    local professor = ents.Create( "npc_professor" )
    professor:SetID( "Professor Newman" )
    professor:SetPos( Vector(768.174133, 1137.295044, 0.031250) )
    professor:SetAngles( Angle(0, -90, 0) )
    professor:SetKeyValue( "spawnflags", bit.bor( SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK ) )
    professor:Spawn()
    professor:Activate()
    professor:DropToFloor()
end

function GM:OnPlayerTalkToNPC( pl, npc )
end