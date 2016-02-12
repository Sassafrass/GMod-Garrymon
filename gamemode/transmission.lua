local transmitEntities = {}

local function removePlayerFromTransmit( ent, pl )
	print( ent, " Removing player from transmit ", pl )
	if not IsValid( ent ) then return end
	ent:SetPreventTransmit( pl, true )
	table.RemoveByValue( ent.transmitToPlayers, pl )
	if #ent.transmitToPlayers == 0 then
		transmitEntities[ent] = nil
		print( ent, " No more players, good bye!" )
		ent:Remove()
	end
end

local function addPlayerToTransmit( ent, pl )
	print( ent, " Adding player to transmit ", pl )
	table.insert( ent.transmitToPlayers, pl )
	ent:SetPreventTransmit( pl, false )
	ent:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

local META = FindMetaTable("Entity")
META.RemovePlayerFromTransmit = removePlayerFromTransmit
META.AddPlayerToTransmit = addPlayerToTransmit
META = nil

function GM:MakeEntityCustomTransmit( ent )
	transmitEntities[ ent ] = true
	ent.transmitToPlayers = {}
	ent:SetCustomCollisionCheck( true )
	for _, pl in pairs( player.GetAll() ) do
		ent:SetPreventTransmit( pl, true )
	end
	ent:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function GM:TransmitPlayerInit( pl )
	for ent, _ in pairs( transmitEntities ) do
		ent:SetPreventTransmit( pl, true )
		ent:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
	end
end

function GM:TransmitPlayerDisconnected( pl )
	for ent, _ in pairs( transmitEntities ) do
		ent:RemovePlayerFromTransmit( pl )
	end
end