include("shared.lua")
include("cl_battleinfo.lua")

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

local playing = true
local frame = vgui.Create( "DFrame" )
frame:SetPos( 100, 100 )
frame:SetSize( ScrW() - 200, ScrH() - 200 )
frame:SetTitle( "Garrymon" )

function frame:OnRemove()
	playing = false
end

local chatPanel = vgui.Create( "DPanel", frame )
chatPanel:Dock( FILL )
chatPanel:SetBackgroundColor(Color( 50, 50, 50, 255 ) )
chatPanel:DockPadding( 10, 10, 10, 10 )

local chatHistory = vgui.Create( "RichText", chatPanel )
chatHistory:Dock( FILL )
chatHistory:SetMultiline( true )
function chatHistory:PerformLayout()
	chatHistory:SetFontInternal( "GarrymonFont" )
	chatHistory:SetFGColor( Color( 0, 0, 0, 255 ) )
end

local textEntry = vgui.Create( "DTextEntry", chatPanel )
textEntry:SetHeight( 40 )
textEntry:SetFocusTopLevel( true )
textEntry:Dock( BOTTOM )
textEntry:SetFont( "GarrymonLarge" )
function textEntry:OnEnter()
	RunConsoleCommand( "say", self:GetText() )
	self:SetText( "" )
	self:RequestFocus()
end

local battlePanel = vgui.Create( "DPanel" )

function battlePanel:Init()
	self:Dock( RIGHT )
	self:DockPadding( 20, 20, 20, 20 )
	self:SetWidth( ScrW() / 2 )
	self:SetVisible( false )
	self.gmonPanel = vgui.Create( "BattleInfo", self )
	self.gmonPanel:Dock( BOTTOM )
	self.enemyPanel = vgui.Create( "BattleInfo", self )
	self.enemyPanel:Dock( TOP )
end

function battlePanel:Toggle( visible )
	if visible and not self.visible then
		self:SetParent( frame )
		self:SetVisible( true )
		self.visible = true
	elseif not visible and self.visible then
		self:Dock( NODOCK )
		self:SetParent( nil )
		self:SetVisible( false )
		chatPanel:Dock( FILL )
		self.visible = false
	end
end

function battlePanel:PerformLayout()
	self.gmonPanel:DockPadding( self:GetWide() / 2, 0, 0, 0 )
	self.enemyPanel:DockPadding( 0, 0, self:GetWide() / 2, 0 )
end

function battlePanel:UpdateGmon( name, lvl, hp, maxHp )
	self.gmonPanel:Update( name, lvl, hp, maxHp )
end

function battlePanel:UpdateEnemy( name, lvl, hp, maxHp )
	self.enemyPanel:Update( name, lvl, hp, maxHp )
end

battlePanel:Init()

frame:MakePopup()

net.Receive( "PlayerInitialSpawn", function( len )
	textEntry:SetText( net.ReadString() )
	textEntry:RequestFocus()
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

function GM:ChatText( index, name, text, type )
	if not playing then return end
	parseText( text, {} )
	chatHistory:AppendText( "\n" )
	return true
end

function GM:OnPlayerChat( pl, text, teamChat, isDead )
	if not playing then return end
	chatHistory:AppendText( text )
	chatHistory:AppendText( "\n" )
end

net.Receive( "BattleUpdate", function( len )
	local inBattle = net.ReadBool()
	if inBattle then
		battlePanel:Toggle( true )
		local gmonName = net.ReadString()
		local gmonLvl = net.ReadInt(16)
		local gmonHp = net.ReadInt(16)
		local gmonMaxHp = net.ReadInt(16)
		battlePanel:UpdateGmon( gmonName, gmonLvl, gmonHp, gmonMaxHp )
		local enemyName = net.ReadString()
		local enemyLvl = net.ReadInt(16)
		local enemyHp = net.ReadInt(16)
		local enemyMaxHp = net.ReadInt(16)
		battlePanel:UpdateEnemy( enemyName, enemyLvl, enemyHp, enemyMaxHp )
	else
		battlePanel:Toggle( false )
	end
end )