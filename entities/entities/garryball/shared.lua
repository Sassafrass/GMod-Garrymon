ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = false
ENT.Interactable	= true

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Selected" )
	self:NetworkVar( "String", 0, "ID" )

end

function ENT:CalcAbsolutePosition(pos, ang)
	local phys = self:GetPhysicsObject()

	if(IsValid(phys)) then
		phys:EnableMotion(false)
		
		phys:SetPos(pos)
		phys:SetAngles(ang)
	end
end