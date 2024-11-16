extends Node
@onready var player : Player = self.owner
@onready var timer_combo_refresh = $"Timer"
@onready var players = get_node("/root/players")

var combinations_machine : Array = []
var pressed_keys : Dictionary = {}

func _on_player_control_add_current_state(current_state):
	# Solo agrega el estado si la tecla no está presionada actualmente
	if not pressed_keys.has(current_state) or not pressed_keys[current_state]:
		combinations_machine.append(current_state)
		pressed_keys[current_state] = true  # Marca la tecla como presionada

		print(pressed_keys)
		timer_combo_refresh.start()  # Reinicia el timer de refresco de combinaciones
		check_combination()
		print(combinations_machine)

func _on_timer_timeout():
	clear_current_combination()

func clear_current_combination():
	if combinations_machine.size() > 0:
		combinations_machine.clear()
		pressed_keys.clear()  # Limpiar las teclas presionadas
		print("Combination cleared")

func check_combination():
	var combinations : Dictionary = {
		"NORMAL_ATTACK": [player.player_view_direction, player.STATE.NORMAL_ATTACK],
		"LOW_ATTACK": [player.STATE.DOWN, player.STATE.NORMAL_ATTACK],
		"UP_ATTACK": [player.STATE.NORMAL_ATTACK]
	}
	
	if combinations_machine.size() > 0:
		for combination in combinations.values():
			if combinations_machine == combination:
				player.anim_player.play(combinations.find_key(combination))
				print("Combo accessed")
				print(combination)

	player_dash()

func player_dash():
	if combinations_machine == [player.STATE.RIGHT, player.STATE.RIGHT]:
		player.anim_player.play("dash")
		clear_current_combination()
		player.velocity.x += 500
		player.current_state = player.STATE.COMBINATION

	elif combinations_machine == [player.STATE.LEFT, player.STATE.LEFT]:
		player.anim_player.play("dash")
		clear_current_combination()
		player.velocity.x -= 500
		player.current_state = player.STATE.COMBINATION

func _on_player_control_key_released(released_state):
	# Función para llamar al soltar una tecla y reiniciar su estado en pressed_keys
		if pressed_keys.has(released_state):
			pressed_keys[released_state] = false  # Marca la tecla como no presionada
