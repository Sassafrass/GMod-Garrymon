local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground( false )
	self.top = vgui.Create( "DPanel", self )
	self.top:SetPaintBackground( false )
	self.top:Dock( TOP )
	self.name = vgui.Create( "DLabel", self.top )
	self.name:Dock( LEFT )
	self.name:SetFontInternal( "GarrymonLarge" )
	self.name:SetTextColor( Color( 0, 0, 0, 150 ) )
	self.lvl = vgui.Create( "DLabel", self.top )
	self.lvl:Dock( RIGHT )
	self.lvl:SetFontInternal( "GarrymonLarge" )
	self.lvl:SetContentAlignment(6)
	self.lvl:SetTextColor( Color( 0, 0, 0, 150 ) )
	self.hpBar = vgui.Create( "DProgress", self )
	self.hpBar:Dock( FILL )
	self.hp = vgui.Create( "DLabel", self )
	self.hp:Dock( BOTTOM )
	self.hp:SetFontInternal( "GarrymonLarge" )
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
	local height = ScreenScale( 80 )
	self:SetHeight( height )
	self.hpBar:SetHeight( height * 0.25 )
	self.top:SetHeight( height * 0.375 )
	self.hp:SetHeight( height * 0.375 )
end

vgui.Register( "BattleInfo", PANEL, "DPanel" )

function GM:IsInBattle()
	return true
end

function GM:CalcView( pl, pos, angles, fov, near, far )
	if GAMEMODE:IsInBattle() then
		local view = {}

		view.origin = Vector( 492.531525, -309.865845, 74.911697 )
		view.angles = Angle( 30.800, 131.472, 0.000 )
		view.fov = fov

		return view
	end
end

function GM:ShouldDrawLocalPlayer()
	return false
end