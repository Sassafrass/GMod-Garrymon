AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self.BaseClass.Initialize(self)
	self:SetModel("models/barney.mdl")
    self:SetID( "" )

end

function ENT:RunBehaviour()

	while ( true ) do

		self:RunControllers()
		coroutine.yield()

	end

end