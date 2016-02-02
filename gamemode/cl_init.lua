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

function GM:OnPlayerChat( pl, text, teamChat, isDead )
	-- TODO
end