surface.CreateFont( "GarrymonChat",
{
	font		= "Tahoma",
	size		= 96,
	weight		= 500,
	outline 	= false,
	antialias 	= true,
})

local messages = {}

local chatBGColor = Color( 255, 255, 255, 255 )
local chatColor = Color( 0, 0, 0, 255 )

local function Message( text, pos )
	pos = pos + VECTOR_UP * 16
	local message = {}
	message.text = text
	message.pos = pos
	message.currpos = pos
	message.startTime = CurTime()
	message.appearDuration = string.len( text ) * 0.1
	message.endTime = message.startTime + math.max(message.appearDuration * 2, 5)
	for i, message in pairs( messages ) do
		message.pos = message.pos + VECTOR_UP * 12
	end
	table.insert( messages, message )
end

local function MessageUpdate( message )
	if CurTime() >= message.endTime then return false end
	return true
end

local function MessageRender( message, eyePos )

	local ang = (message.pos - eyePos):Angle()
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )

	local progress = (CurTime() - message.startTime) / message.appearDuration
	local messageText = message.text
	message.currpos = LerpVector( 1 - math.pow(0.00001, FrameTime()), message.currpos, message.pos )
	if progress  < 1 then
		messageText = string.sub( message.text, 1, progress * string.len( message.text ) )
	end

	cam.Start3D2D( message.currpos, ang, 0.075 )

		local width, height = surface.GetTextSize( messageText )
		local padding = 8
		draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
			width + padding * 2 + 8, height + padding * 2, chatColor )
		local padding = 4
		draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
			width + padding * 2 + 8, height + padding * 2, chatBGColor )
		draw.SimpleText( messageText, "GarrymonChat", 0, 0, chatColor, 1, 1 )

	cam.End3D2D()

end

net.Receive( "gmon.ChatMessage", function( len )
	Message( net.ReadString(), net.ReadVector() )
end )

local nextUpdateMessages = 0
function GM:UpdateMessages()
	if CurTime() < nextUpdateMessages then return end
	nextUpdateMessages = CurTime() + 0.1
	local newmessages = {}
	local messageOffset = 0
	for i, message in ipairs(messages) do
		if MessageUpdate( message ) then
			message.pos = message.pos + VECTOR_UP * messageOffset
			table.insert( newmessages, message )
		else
			messageOffset = messageOffset + 12
		end
	end
	messages = newmessages
end

function GM:HUDPaint()
	self:UpdateMessages()
	local eyePos = EyePos()
	surface.SetFont( "GarrymonChat" )
	surface.DisableClipping( true )
	cam.IgnoreZ( true )
	cam.Start3D()
		for i, message in ipairs(messages) do
				MessageRender( message, eyePos )
		end
	cam.End3D()
	cam.IgnoreZ( false )
	surface.DisableClipping( false )
end

function GM:OnPlayerChat( pl, text, teamChat, isDead )
	local headPos = pl:GetBonePosition(pl:LookupBone("ValveBiped.Bip01_Head1"))
	Message( text, headPos )
end