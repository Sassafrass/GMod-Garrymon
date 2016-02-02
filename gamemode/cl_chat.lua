surface.CreateFont( "GarrymonChat",
{
	font		= "Tahoma",
	size		= 96,
	weight		= 500,
	outline 	= false,
	antialias 	= true,
})

local chatBGColor = Color( 255, 255, 255, 255 )
local chatColor = Color( 0, 0, 0, 255 )
local message = "Hello. I am the professor."

function GM:HUDPaint()
	local ent = ents.FindByClass("npc_professor")[1]
	if not IsValid(ent) then return end
	local headPos = ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1"))
	local ang = (headPos - EyePos()):Angle()
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	cam.IgnoreZ( true )
	cam.Start3D()
		cam.Start3D2D( headPos - VECTOR_UP * 5, ang, 0.075 )

			surface.DisableClipping( true )
			surface.SetFont( "GarrymonChat" )
			local partialMessage = string.sub( message, 1, (CurTime() * 10) % (string.len( message ) + 1) )
			local width, height = surface.GetTextSize( partialMessage )
			local padding = 8
			draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
				width + padding * 2 + 8, height + padding * 2, chatColor )
			local padding = 4
			draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
				width + padding * 2 + 8, height + padding * 2, chatBGColor )
			draw.SimpleText( partialMessage, "GarrymonChat", 0, 0, chatColor, 1, 1 )
			surface.DisableClipping( false )

		cam.End3D2D()
	cam.End3D()
	cam.IgnoreZ( false )
end