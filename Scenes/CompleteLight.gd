extends DirectionalLight

export(Resource) var player_info

func _ready():
	player_info.connect("game_complete", self, "turn_on")

func turn_on():
	self.visible = true
