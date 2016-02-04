
local GHand = {}
local GHand_mt = { __index = GHand }

AccessorFunc( GHand, "player", "Player" )

function GHand:Init( pl )
	self.garrymon = {}
	self:SetPlayer( pl )
	pl:SetGHand( self )
end

function GHand:AddGarrymon( garrymon )
	table.insert( self.garrymon, garrymon )
end

function GHand:SwapOrder( index1, index2 )
	local temp = self.garrymon[index1]
	self.garrymon[index1] = self.garrymon[index2]
	self.garrymon[index2] = temp
end

function GHand:IsFull()
	return #self.garrymon == 6
end

function GM:CreateGHand( pl )
	local gh = {}
	setmetatable( gh, GHand_mt )
	gh:Init( pl )
end

local META = FindMetaTable("Player")
if META then
	AccessorFunc( META, "ghand", "GHand" )
end
META = nil