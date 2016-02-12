ENT.Base = "base_nextbot"
ENT.Interactable	= true

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "ID" )
	self:NetworkVar( "Bool", 0, "Talk" )

end