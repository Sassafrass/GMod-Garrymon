local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground( false )
	self.top = vgui.Create( "DPanel", self )
	self.top:SetPaintBackground( false )
	self.top:Dock( TOP )
	self.name = vgui.Create( "DLabel", self.top )
	self.name:Dock( LEFT )
	self.name:SetFontInternal( "GarrymonFont" )
	self.name:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.lvl = vgui.Create( "DLabel", self.top )
	self.lvl:Dock( RIGHT )
	self.lvl:SetFontInternal( "GarrymonFont" )
	self.lvl:SetContentAlignment(6)
	self.lvl:SetTextColor( Color( 255, 255, 255, 255 ) )
	self.hpBar = vgui.Create( "DProgress", self )
	self.hpBar:Dock( FILL )
	self.hp = vgui.Create( "DLabel", self )
	self.hp:Dock( BOTTOM )
	self.hp:SetContentAlignment(6)
	self.hp:SetFontInternal( "GarrymonFont" )
	self.hp:SetTextColor( Color( 255, 255, 255, 255 ) )
end

function PANEL:Update( name, lvl, hp, maxHp )
	self.name:SetText( name )
	self.name:SizeToContents()
	self.lvl:SetText( "Lvl: " .. lvl )
	self.hpBar:SetFraction( hp / maxHp )
	self.hp:SetText( hp .. "/" .. maxHp )
end

function PANEL:PerformLayout()
	local height = self:GetTall()
	self.hpBar:SetHeight( height * 0.25 )
	self.top:SetHeight( height * 0.375 )
	self.hp:SetHeight( height * 0.375 )
end

vgui.Register( "BattleInfo", PANEL, "DPanel" )

local PANEL = {}

function PANEL:Init()
	self.buttons = {}
	local actions = {"FIGHT", "BAG", "POKEMON", "RUN"}
	for i = 1, 4 do
		local btn = vgui.Create( "DButton", self )
		btn:SetText( actions[i] )
		btn:SetFontInternal( "GarrymonLarge" )
		btn:SetConsoleCommand( "say", i )
		self.buttons[i] = btn
	end
end

function PANEL:PerformLayout()
	local w, h = self:GetSize()
	for i = 1, 4 do
		self.buttons[i]:SetSize( w / 2, h / 2 )
		self.buttons[i]:SetPos( (1 - (i % 2)) * w / 2, math.floor((i-1) / 2) * h / 2 )
	end
end

vgui.Register( "ActionPanel", PANEL, "DPanel" )


local battlePanel = vgui.Create( "DPanel" )

function battlePanel:Init()
	self:SetPaintBackground( false )
	self:SetVisible( false )
	self.gmonPanel = vgui.Create( "BattleInfo", self )
	self.enemyPanel = vgui.Create( "BattleInfo", self )
	self.actionPanel = vgui.Create( "ActionPanel", self )
end

function battlePanel:Toggle( visible )
	if visible and not self.visible then
		gui.EnableScreenClicker(true)
		self:SetVisible( true )
		self.visible = true
	elseif not visible and self.visible then
		gui.EnableScreenClicker(false)
		self:SetVisible( false )
		self.visible = false
	end
end

function battlePanel:PerformLayout()
	local w, h = ScrW(), ScrH() * 0.8
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	local padX, padY = w * 0.1, h * 0.05
	local width, height = w * 0.3, h * 0.15
	self.gmonPanel:SetPos( w - padX - width, h - padY - height )
	self.gmonPanel:SetSize( width, height )
	self.enemyPanel:SetPos( padX, padY )
	self.enemyPanel:SetSize( width, height )
	self.actionPanel:SetSize( w * 0.5, ScrH() * 0.2 )
	self.actionPanel:SetPos( w * 0.5, h )
end

function battlePanel:UpdateGmon( name, lvl, hp, maxHp )
	self.gmonPanel:Update( name, lvl, hp, maxHp )
end

function battlePanel:UpdateEnemy( name, lvl, hp, maxHp )
	self.enemyPanel:Update( name, lvl, hp, maxHp )
end

battlePanel:Init()
battlePanel:PerformLayout()

function GM:IsInBattle()
	return battlePanel.visible
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