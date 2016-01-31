local QUEST = {}
QUEST.__index = QUEST
QUEST.description = "A quest."

function QUEST:IsValid()
	return true
end

function QUEST:GetDescription()
	return self.description
end

function QUEST:Init()
	self.hooks = {}
end

function QUEST:OnComplete()
end

function QUEST:Unload()
	for hookName, _ in pairs( self.hooks ) do
		hook.Remove( hookName, self )
	end
end

function QUEST:__tostring()
	return "Quest ["..tostring(self.name).."]"
end

function QUEST:RegisterHook( hookName )
	self.hooks[hookName] = true
	hook.Add( hookName, self, self[hookName] )
end

quest.register( "base_quest", QUEST )