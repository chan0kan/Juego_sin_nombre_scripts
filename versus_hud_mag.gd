extends CanvasLayer

@onready var players = get_node("/root/players")

@onready var life_bar_p2 = $"VBoxContainer2/ProgressBar_p2"
@onready var life_bar_p1 = $"VBoxContainer/ProgressBar_p1"

@onready var label_p2 = $"VBoxContainer2/player_2"
@onready var label_p1 = $"VBoxContainer/player_1"

func _process(_delta):

	if players.child_scan:

		life_bar_p1.value = players.player_1.life_points
		life_bar_p2.value = players.player_2.life_points

		label_p1.text = players.player_1.name
		label_p2.text = players.player_2.name
