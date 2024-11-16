extends Node

@onready var ready_timer = $"Ready_timer"
@onready var music_player = $"Music_player"
@onready var animation_player = $"AnimationPlayer"
@onready var ready_label = $"ready_label"

@onready var players = get_node("/root/players")

func _ready():
	ready_timer.start()
	animation_player.play("ready_animation")

func _on_timer_timeout():

	ready_label.hide()

	print("players_ready")
	
	players.child_scan = true

	players.ready_players()
	
	for i in range(0, players.get_child_count()):
		
		players.get_child(i).process_mode = Node.PROCESS_MODE_INHERIT
	
	music_player.play()
	
func _on_music_player_finished():
	music_player.play()
