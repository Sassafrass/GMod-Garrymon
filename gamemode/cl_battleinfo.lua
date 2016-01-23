local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground( false )
	self.top = vgui.Create( "DPanel", self )
	self.top:SetPaintBackground( false )
	self.top:Dock( TOP )
	self.name = vgui.Create( "DLabel", self.top )
	self.name:Dock( LEFT )
	self.name:SetFontInternal( "DermaLarge" )
	self.name:SetTextColor( Color( 0, 0, 0, 150 ) )
	self.lvl = vgui.Create( "DLabel", self.top )
	self.lvl:Dock( RIGHT )
	self.lvl:SetFontInternal( "DermaLarge" )
	self.lvl:SetContentAlignment(6)
	self.lvl:SetTextColor( Color( 0, 0, 0, 150 ) )
	self.hpBar = vgui.Create( "DProgress", self )
	self.hpBar:Dock( FILL )
	self.hp = vgui.Create( "DLabel", self )
	self.hp:Dock( BOTTOM )
	self.hp:SetFontInternal( "DermaLarge" )
	self.hp:SetTextColor( Color( 0, 0, 0, 150 ) )
end

function PANEL:Update( name, lvl, hp, maxHp )
	self.name:SetText( name )
	self.name:SizeToContents()
	self.lvl:SetText( "Lvl: " .. lvl )
	self.hpBar:SetFraction( hp / maxHp )
	self.hp:SetText( hp .. "/" .. maxHp )
end

function PANEL:PerformLayout()
	self:SetHeight( 160 )
	self.hpBar:SetHeight( 40 )
	self.top:SetHeight( 60 )
	self.hp:SetHeight( 60 )
end

vgui.Register( "BattleInfo", PANEL, "DPanel" )