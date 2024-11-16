extends Node

signal add_current_state()
signal show_current_state()
signal key_released()

@onready var player : Player = self.owner

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func gravity(delta):
	player.velocity.y += GRAVITY * delta

func _input(_event):
	
	if Input.is_action_just_released("anything"):
		emit_signal("key_released", player.current_state)

	basic_state()
	get_current_state()

func _physics_process(delta):
	states_actions()
	gravity(delta)
	player.move_and_slide()
	emit_signal("show_current_state", player.current_state)

func basic_state():
	# Estado básico para los movimientos y acciones iniciales
	if player.current_state == player.STATE.IDLE:
		if Input.is_action_just_pressed(player.player_control + "_left"):
			player.current_state = player.STATE.LEFT
		elif Input.is_action_just_pressed(player.player_control + "_right"):
			player.current_state = player.STATE.RIGHT
		elif Input.is_action_just_pressed(player.player_control + "_defend"):
			player.current_state = player.STATE.DEFENSE
		elif Input.is_action_just_pressed(player.player_control + "_jump"):
			player.current_state = player.STATE.UP
		elif Input.is_action_just_pressed(player.player_control + "_attack"):
			player.current_state = player.STATE.NORMAL_ATTACK
		elif Input.is_action_pressed(player.player_control + "_crouch"):
			player.current_state = player.STATE.DOWN

	elif player.current_state == player.STATE.DEFENSE:
		if Input.is_action_just_released(player.player_control + "_defend"):
			player.current_state = player.STATE.IDLE
		elif Input.is_action_just_pressed(player.player_control + "_crouch"):
			player.current_state = player.STATE.DOWN_DEFENSE

	elif player.current_state == player.STATE.DOWN_DEFENSE:
		if Input.is_action_just_released(player.player_control + "_defend"):
			player.current_state = player.STATE.DOWN
		elif Input.is_action_just_released(player.player_control + "_crouch"):
			player.current_state = player.STATE.DEFENSE

	elif player.current_state == player.STATE.RIGHT:
		if Input.is_action_just_released(player.player_control + "_right"):
			player.current_state = player.STATE.IDLE
		elif Input.is_action_just_pressed(player.player_control + "_jump"):
			player.current_state = player.STATE.UP
		elif Input.is_action_just_pressed(player.player_control + "_attack"):
			player.current_state = player.STATE.NORMAL_ATTACK

	elif player.current_state == player.STATE.LEFT:
		if Input.is_action_just_released(player.player_control + "_left"):
			player.current_state = player.STATE.IDLE
		elif Input.is_action_just_pressed(player.player_control + "_jump"):
			player.current_state = player.STATE.UP
		elif Input.is_action_just_pressed(player.player_control + "_attack"):
			player.current_state = player.STATE.NORMAL_ATTACK

	elif player.current_state == player.STATE.DOWN:
		if Input.is_action_just_released(player.player_control + "_crouch"):
			player.current_state = player.STATE.IDLE
		elif Input.is_action_just_pressed(player.player_control + "_defend"):
			player.current_state = player.STATE.DOWN_DEFENSE
		elif Input.is_action_just_pressed(player.player_control + "_attack"):
			player.current_state = player.STATE.NORMAL_ATTACK

func states_actions():
	# Acción según el estado actual del jugador
	var direction = Input.get_axis(player.player_control + "_left", player.player_control + "_right")
	
	match player.current_state:
		player.STATE.IDLE:
			player.velocity.x = 0
			player.anim_player.play("idle")

		player.STATE.RIGHT, player.STATE.LEFT:
			player.velocity.x = direction * player.SPEED
			player.anim_player.play("walk")

		player.STATE.UP:
			player.velocity.y = player.JUMP_VELOCITY
			player.anim_player.play("jump")
			if player.velocity.y > 0:  # Cambia a estado de caída si comienza a descender
				player.current_state = player.STATE.FALLING

		player.STATE.FALLING:
			player.velocity.y = player.FALL_VELOCITY
			player.anim_player.play("falling")
			if player.is_on_floor():
				player.current_state = player.STATE.IDLE

		player.STATE.DEFENSE:
			player.anim_player.play("defend")

		player.STATE.DOWN:
			player.anim_player.play("crouch")

		player.STATE.HITTED:
			player.anim_player.play("hit")

		player.STATE.COMBINATION:
			pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name in ["NORMAL_ATTACK", "UP_ATTACK", "LOW_ATTACK", "jump", "hit", "dash"]:
		player.current_state = player.STATE.IDLE
		if anim_name == "jump":
			player.current_state = player.STATE.FALLING

func get_current_state():
	# Emite la señal de estado actual si no está en IDLE
	if not player.current_state in [player.STATE.FALLING, player.STATE.IDLE, player.STATE.HITTED]:
		emit_signal("add_current_state", player.current_state)
