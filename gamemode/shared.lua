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