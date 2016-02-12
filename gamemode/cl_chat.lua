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

local function MessagePushOtherMessages( message, j, messageCount )
	for i = j, 1, -1 do
		local msg = messages[i]
		if math.abs(msg.pos.z - message.pos.z) < 6 and
			msg.pos:Distance( message.pos ) < (msg.width + message.width) * 0.5 * 0.075 then
			msg.pos = msg.pos + (message.height + 32) * 0.075 * VECTOR_UP
			msg.startTime = msg.startTime - msg.appearDuration
			MessagePushOtherMessages( msg, i - 1, messageCount )
		end
	end
end

local function Message( text, pos )
	local message = {}
	message.text = text
	print( text )

	message.pos = pos + VECTOR_UP * 10
	message.currpos = pos

	message.startTime = CurTime()
	message.appearDuration = string.len( text ) * 0.05
	message.endTime = message.startTime + math.max(message.appearDuration * 3, 5)

	surface.SetFont( "GarrymonChat" )
	message.width, message.height = surface.GetTextSize( text )

	table.insert( messages, message )
	MessagePushOtherMessages( message, #messages - 1, #messages )

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

		local width, height = message.width, message.height
		local padding = 8
		draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
			width + padding * 2 + 8, height + padding * 2, chatColor )
		local padding = 4
		draw.RoundedBox( 4, -0.5 * width - padding - 4, -0.5 * height - padding, 
			width + padding * 2 + 8, height + padding * 2, chatBGColor )
		draw.SimpleText( messageText, "GarrymonChat", -0.5 * width, 0, chatColor, 0, 1 )

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
			table.insert( newmessages, message )
		end
	end
	messages = newmessages
end

function GM:ChatPaint()
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