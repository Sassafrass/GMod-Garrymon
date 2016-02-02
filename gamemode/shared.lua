GM.Name 	= "Garrymon"
GM.Author 	= "IAreHelen"
GM.Email 	= ""
GM.Website 	= ""

GM.TEAMS = {}
GM.TEAMS.JOINING = 0
GM.TEAMS.PLAYERS = 1

team.SetUp(GM.TEAMS.JOINING, "Initializing", Color(80, 80, 80, 255))
team.SetUp(GM.TEAMS.PLAYERS, "Players", Color(20, 220, 20, 255))

MsgN("#########################")
MsgN("# Garrymon by IAreHelen #")
MsgN("#########################")

function GM:GetGameDescription()
	return self.Name
end

VECTOR_UP = Vector(0, 0, 1)
VECTOR_ZERO = Vector(0, 0, 0)

color_white = Color( 255, 255, 255, 255 )
color_black = Color( 0, 0, 0, 255 )

function GM:SetPlayerScale( pl, scale )
	-- Default Hull
	-- 32  =  2' 0"    width & length
	-- 36  =  2' 3"    height crouching
	-- 72  =  4' 6"    height standing

	-- Default Eyelevel
	-- 28  =  1' 9"    height crouching
	-- 64  =  4' 0"    height standing
    local hullMin = Vector( -16, -16, 0 ) * scale
    local hullMax = Vector( 16, 16, 72 ) * scale
    local duckMax = Vector( 16, 16, 36 ) * scale
    pl:SetHull( hullMin, hullMax )
    pl:SetHullDuck( hullMin, duckMax )
    pl:SetModelScale( scale, 0 )
    pl:SetViewOffset( Vector( 0, 0, 64 ) * scale )
    pl:SetViewOffsetDucked( Vector( 0, 0, 28 ) * scale )
    pl:Activate()
end