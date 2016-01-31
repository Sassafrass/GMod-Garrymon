include("shared.lua")

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

surface.CreateFont( "GarrymonNametag",
{
	font		= "Tahoma",
	size		= 48,
	weight		= 500,
	outline 	= true,
	antialias 	= true,
})

local nameTagColor = Color( 255, 255, 255, 0 )
local nameTagShadowColor = Color( 0, 0, 0, 0 )

function ENT:Draw()
	self:DrawModel()
	local headPos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
	local alpha = 1 - math.Clamp( EyePos():Distance( headPos ) - 200, 0, 200 ) / 200
	if alpha > 0 then
		nameTagColor.a = alpha * 255
		nameTagShadowColor.a = alpha * 255
		local ang = EyeAngles()
		ang:RotateAroundAxis( ang:Right(), 90 )
		ang:RotateAroundAxis( EyeAngles():Forward(), 90 )
		cam.Start3D2D( headPos + VECTOR_UP * (math.abs(math.sin(RealTime() * 4)) * 5 + 10), ang, 0.1 )
			local font = "GarrymonNametag"
			draw.SimpleTextOutlined( self:GetID(), font, 0, 0, nameTagColor, 1, 1, 2, nameTagShadowColor )
		cam.End3D2D()
	end
end