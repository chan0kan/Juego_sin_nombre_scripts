extends Camera2D

@onready var players = get_node("/root/players")

func _process(_delta):

	if players.child_scan:

		self.position = players.midpoint_players



