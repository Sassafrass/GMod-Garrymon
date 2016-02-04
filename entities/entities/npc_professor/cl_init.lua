include("shared.lua")

ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
	if( halo.RenderedEntity() == self ) then return end
	local headPos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
	GAMEMODE:RenderNameTag( self:GetID(), headPos, 0.1, true )
end