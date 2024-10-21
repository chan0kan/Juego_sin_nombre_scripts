extends Area2D

@onready var players = get_node("/root/players")

var player = self.owner

func _on_body_entered(body):
	if body.has_method("recibe_damage") and body is CharacterBody2D and body.player_controls.current_state != 5:
		body.recibe_damage(10)
	elif body.player_controls.current_state == 5:
		body.defend_damage(5)
		
	
