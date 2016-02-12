AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetUseType( SIMPLE_USE )
	self:AddGesture( ACT_IDLE )
	self.talkedTo = false
	self.controllers = {}

end

function ENT:WaitForTalk()
	self.talkedTo = false
	self:SetTalk(true)
	while not self.talkedTo do
		coroutine.yield()
	end
end

function ENT:Use( activator, caller, type, value )
	if activator:IsPlayer() then
		self.talkedTo = true
		self:SetTalk(false)
	end
end

function ENT:Say( text )
	local headPos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1"))
	net.Start( "gmon.ChatMessage" )
		net.WriteString( text )
		net.WriteVector( headPos )
	net.Send( self.transmitToPlayers )
end

function ENT:AddController( controller, func )
	self.controllers[ controller ] = coroutine.create( func )
end

function ENT:RemoveController( controller )
	self.controllers[ controller ] = nil
end

function ENT:GetYawPitch(vec)
	--This gets the offset from 0,2,0 on the entity to the vec specified as a vector
	local yawAng=vec-self:EyePos()
	--Then converts it to a vector on the entity and makes it an angle ("local angle")
	local yawAng=self:WorldToLocal(self:GetPos()+yawAng):Angle()
	
	--Same thing as above but this gets the pitch angle. Since the turret's pitch axis and the turret's yaw axis are seperate I need to do this seperately.
	local pAng=vec-self:LocalToWorld((yawAng:Forward()*8)+Vector(0,0,50))
	local pAng=self:WorldToLocal(self:GetPos()+pAng):Angle()

	--Y=Yaw. This is a number between 0-360.	
	local y=yawAng.y
	--P=Pitch. This is a number between 0-360.
	local p=pAng.p
	
	--Numbers from 0 to 360 don't work with the pose parameters, so I need to make it a number from -180 to 180
	if y>=180 then y=y-360 end
	if p>=180 then p=p-360 end
	if y<-60 || y>60 then return false end
	if p<-80 || p>80 then return false end
	--Returns yaw and pitch as numbers between -180 and 180	
	return y,p
end

function ENT:FindNearestPlayer()
	if self.nextFindNearestPlayer and CurTime() < self.nextFindNearestPlayer then return end
	self.nextFindNearestPlayer = CurTime() + 0.2

	local closest
	self.closestPlayer = nil
	for _, ent in pairs( self.transmitToPlayers ) do
		if IsValid(ent) and ent:IsPlayer() then
			if not self.closestPlayer or ent:GetPos():Distance(self:GetPos()) < closest then
				self.closestPlayer = ent
				closest = ent:GetPos():Distance(self:GetPos())
			end
		end
	end
end

function ENT:FaceNearestPlayer()
	self:FindNearestPlayer()
	if IsValid(self.closestPlayer) then
		local target = self.closestPlayer:EyePos()
		self:SetEyeTarget( target )
		local y, p = self:GetYawPitch( target )
		if y then
			self:SetPoseParameter("head_yaw", y)
			self:SetPoseParameter("head_pitch", p)
		else
			self.loco:FaceTowards( target )
		end
	end
end

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end

function ENT:RunControllers()
	for controller, routine in pairs( self.controllers ) do
		if coroutine.status( routine ) == "dead" then
			self.controllers[ controller ] = nil
		else
			local ok, res = coroutine.resume( routine, controller, self )
			if not ok then
				self.controllers[ controller ] = nil
				Error( res )
			end
		end
	end
end