include("shared.lua")

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

local defaultAngle = Angle( 0, -90, 0 )
function ENT:Initialize()
	self.renderAngles = defaultAngle
	self.renderOrigin = self:GetPos()
	self.realPosition = self:GetPos()
end

function ENT:Draw()
	local realPos = self.realPosition
	local angle = GAMEMODE:IsEntityHot( self ) and (EyePos() - realPos):Angle() or defaultAngle
	local origin = self:GetSelected() and realPos + VECTOR_UP * 2 or realPos
	self.renderAngles = LerpAngle( 1 - math.pow(0.00001, FrameTime()), self.renderAngles, angle )
	self.renderOrigin = LerpVector( 1 - math.pow(0.00001, FrameTime()), self.renderOrigin, origin )
	self:SetAngles( self.renderAngles )
	self:SetPos( self.renderOrigin )
	self:DrawModel()
	if( halo.RenderedEntity() == self ) then return end
	GAMEMODE:RenderNameTag( self:GetID(), self:GetPos(), 0.05 )
end