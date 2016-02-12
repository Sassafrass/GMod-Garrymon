include("shared.lua")

surface.CreateFont( "GarrymonFont",
{
	font		= "Tahoma",
	size		= ScreenScale(16),
	weight		= 500,
	outline 	= true,
	antialias 	= true,
})

surface.CreateFont( "GarrymonLarge",
{
	font		= "Roboto",
	size		= ScreenScale(14),
	weight		= 500
})

surface.CreateFont( "GarrymonMedium",
{
	font		= "Roboto",
	size		= ScreenScale(10),
	weight		= 500
})

include("cl_chat.lua")
include("cl_battleinfo.lua")
include("cl_quests.lua")

net.Receive( "PlayerInitialSpawn", function( len )
	local name = net.ReadString()
end )

local function parseText( text, colorStack )
	local k, l = string.find( text, "</c>" )
	local m, n = string.find( text, "<c=%d+,%d+,%d+>" )
	if k and (not m or k < m) then
		local c = table.remove( colorStack ) or Color( 255, 255, 255 )
		chatHistory:InsertColorChange( c.r, c.g, c.b, 255 )
		chatHistory:AppendText( string.sub( text, 1, k - 1 ) )
		text = string.sub( text, l + 1 )
		parseText( text, colorStack )
	elseif m then
		local c = colorStack[#colorStack] or Color( 255, 255, 255 )
		chatHistory:InsertColorChange( c.r, c.g, c.b, 255 )
		chatHistory:AppendText( string.sub( text, 1, m - 1 ) )
		local r, g, b = string.match( string.sub( text, m, n ), "<c=(%d+),(%d+),(%d+)>" )
		table.insert( colorStack, Color( r, g, b ) )
		text = string.sub( text, n + 1 )
		parseText( text, colorStack )
	else
		local c = colorStack[#colorStack] or Color( 255, 255, 255 )
		chatHistory:InsertColorChange( c.r, c.g, c.b, 255 )
		chatHistory:AppendText( text )
	end
end

local hot = false
function GM:PreDrawHalos()
	local tr = util.TraceLine{
		start = EyePos(),
		endpos = EyePos() + LocalPlayer():GetAimVector() * 95,
		filter = player.GetAll()
	}
	local hitEnt = tr.Entity
	if( IsValid( hitEnt ) and hitEnt.Interactable and (not hitEnt.GetTalk or hitEnt:GetTalk()) ) then
		if not hot or hot ~= hitEnt then
			hot = hitEnt
			surface.PlaySound( "ui/buttonrollover.wav" )
		end
		halo.Add( {hitEnt}, Color( 255, 255, 255 ), 2, 2, 2 )
	else
		hot = false
	end
end

function GM:IsEntityHot( ent )
	return hot == ent
end

function GM:HUDPaint()
	self:ChatPaint()
	quest.Paint()
end

------------------------------------------------
--
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

function GM:RenderNameTag( name, pos, scale, bounce )

	local alpha = 1 - math.Clamp( EyePos():Distance( pos ) - 200, 0, 200 ) / 200
	if alpha > 0 then
		nameTagColor.a = alpha * 255
		nameTagShadowColor.a = alpha * 255
		local ang = EyeAngles()
		ang:RotateAroundAxis( ang:Right(), 90 )
		ang:RotateAroundAxis( EyeAngles():Forward(), 90 )
		local offset = bounce and (math.abs(math.sin(RealTime() * 4)) * 5 + 10) or 10
		cam.Start3D2D( pos + offset * scale * 10 * VECTOR_UP, ang, scale )
			draw.SimpleTextOutlined( name, "GarrymonNametag", 0, 0, nameTagColor, 1, 1, 2, nameTagShadowColor )
		cam.End3D2D()
	end

end
--
------------------------------------------------

local lookAt = NULL
local lookAtTime = -2
local lookAtDuration = 2
local lookAtStart
local lookAtSmoother

net.Receive( "gmon.LookAt", function( len ) 
	local target = net.ReadEntity()
	if IsValid(target) then
		lookAt = target
		lookAtTime = RealTime()
		lookAtStart = EyeAngles()
		lookAtSmoother = lookAt:LocalToWorld( lookAt:OBBCenter() )
	end
end )


function GM:CreateMove( cmd )
	if RealTime() < lookAtTime + lookAtDuration and IsValid(lookAt) then
		cmd:ClearMovement()
		local t = math.Clamp((RealTime() - lookAtTime) / lookAtDuration, 0, 1)
		lookAtSmoother = LerpVector( 1 - math.pow(0.0001, FrameTime()), lookAtSmoother, lookAt:LocalToWorld( lookAt:OBBCenter() ) )
		local ang = (lookAtSmoother - EyePos()):Angle()
		cmd:SetViewAngles( LerpAngle( t, lookAtStart, ang ) )
	end
end