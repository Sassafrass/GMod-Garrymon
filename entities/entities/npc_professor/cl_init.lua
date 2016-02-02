include("shared.lua")

ENT.RenderGroup 	= RENDERGROUP_BOTH

surface.CreateFont( "GarrymonNametag",
{
	font		= "Tahoma",
	size		= 48,
	weight		= 500,
	outline 	= false,
	antialias 	= true,
})

local nameTagColor = Color( 255, 255, 255, 0 )
local nameTagShadowColor = Color( 0, 0, 0, 0 )

function ENT:Draw()
	self:DrawModel()
	if( halo.RenderedEntity() == self ) then return end
	local headPos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
	local alpha = 1 - math.Clamp( EyePos():Distance( headPos ) - 200, 0, 200 ) / 200
	if alpha > 0 then
		nameTagColor.a = alpha * 255
		nameTagShadowColor.a = alpha * 255
		local ang = EyeAngles()
		ang:RotateAroundAxis( ang:Right(), 90 )
		ang:RotateAroundAxis( EyeAngles():Forward(), 90 )
		cam.Start3D2D( headPos + VECTOR_UP * (math.abs(math.sin(RealTime() * 4)) * 5 + 10), ang, 0.1 )
			draw.SimpleTextOutlined( self:GetID(), "GarrymonNametag", 0, 0, nameTagColor, 1, 1, 2, nameTagShadowColor )
		cam.End3D2D()
	end
end

function ENT:StartTalking()
	--self:
end

hook.Add( "PreDrawHalos", "npc_halo", function()
	local tr = LocalPlayer():GetEyeTrace()
	local hitEnt = tr.Entity
	-- NOTE(Sassafrass): 82 is use distance according to https://developer.valvesoftware.com/wiki/Dimensions
	-- but it appears to be further in Gmod
	if( IsValid( hitEnt ) and hitEnt:GetClass() == "npc_professor" and
		EyePos():Distance( tr.HitPos ) <= 95 ) then
		halo.Add( {hitEnt}, Color( 255, 255, 255 ), 2, 2, 2 )
	end
end )