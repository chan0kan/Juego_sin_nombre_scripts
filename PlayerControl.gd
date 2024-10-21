extends Node

signal add_current_state(current_state)
signal show_current_state(current_state)

# Asignarle la clase Player al script del characterBody y crea el nodo "PlayerControl" como un nodo externo y luego instancialo a la escena
# del player.#######
@onready var player : Player = self.owner

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE{
	IDLE,
	RIGHT,
	LEFT,
	UP,
	DOWN,
	P,
	DEFENSE,
	DOWN_DEFENSE,
	HITTED
}

## Emitir la señal cada vez que se cambie de estado ##

@export var current_state : STATE = STATE.IDLE

func gravity(delta):
	player.velocity.y += GRAVITY * delta

func _input(_event):
	
	match current_state:
		
		STATE.IDLE:

			if Input.is_action_just_pressed(player.player_control + "_left"):
				current_state = STATE.LEFT
			if Input.is_action_just_pressed(player.player_control + "_right"):
				current_state = STATE.RIGHT
			if Input.is_action_just_pressed(player.player_control + "_defend"):
				current_state = STATE.DEFENSE
			elif (Input.is_action_just_pressed(player.player_control + "_jump")):
				current_state = STATE.UP
			elif (Input.is_action_just_pressed(player.player_control + "_attack")):
				current_state = STATE.P
			elif (Input.is_action_pressed(player.player_control + "_crouch")):
				current_state = STATE.DOWN

		STATE.RIGHT:

			if Input.is_action_just_released(player.player_control + "_right"):
				current_state = STATE.IDLE
			if (Input.is_action_just_pressed(player.player_control + "_jump")):
				current_state = STATE.UP
			elif (Input.is_action_just_pressed(player.player_control + "_attack")):
				current_state = STATE.P

		STATE.LEFT:

			if Input.is_action_just_released(player.player_control + "_left"):
				current_state = STATE.IDLE
			if (Input.is_action_just_pressed(player.player_control + "_jump")):
				current_state = STATE.UP
			elif (Input.is_action_just_pressed(player.player_control + "_attack")):
				current_state = STATE.P

		STATE.DEFENSE:

			if Input.is_action_just_released(player.player_control + "_defend"):
				current_state = STATE.IDLE
			elif Input.is_action_just_pressed(player.player_control + "_crouch"):
				current_state = STATE.DOWN_DEFENSE
		
		STATE.DOWN_DEFENSE:
			
			if Input.is_action_just_released(player.player_control + "_defend"):
					current_state = STATE.DOWN
			if Input.is_action_just_released(player.player_control + "_crouch"):
					current_state = STATE.DEFENSE
		
		STATE.DOWN:
			if Input.is_action_just_released(player.player_control + "_crouch"):
				current_state = STATE.IDLE
			if Input.is_action_just_pressed(player.player_control + "_defend"):
				current_state = STATE.DOWN_DEFENSE
			if (Input.is_action_just_pressed(player.player_control + "_attack")):
				current_state = STATE.P

	emit_signal("show_current_state", current_state)
	get_current_state()

func _physics_process(delta): 

	var direction = Input.get_axis(player.player_control + "_left", player.player_control + "_right")
	
	match current_state:
		
		STATE.IDLE:
			player.velocity.x = 0
			player.anim_player.play("idle")

		STATE.RIGHT:
			player.velocity.x = direction * player.SPEED
			player.anim_player.play("walk")

		STATE.LEFT:
			player.velocity.x = direction * player.SPEED
			player.anim_player.play("walk")

		STATE.UP:

			if player.velocity.y == player.JUMP_VELOCITY:
				player.anim_player.play("fall")
				print("in fall")
			else:
				player.anim_player.play("falling")
				print("falling")

			player.velocity.y = player.JUMP_VELOCITY
			player.anim_player.play("jump")

		STATE.P:
			player.velocity.x = 0
			#cuando el sistema de combinaciones este completo hay que sacar las animaciones como esta de golpe ya que el sistema de combinaciones
			#se encargara de ejecutarlas
			#player.anim_player.play("P")
		
		STATE.DEFENSE:
			player.anim_player.play("defend")
		
		STATE.DOWN_DEFENSE:
			
			pass
		
		STATE.DOWN:
			player.anim_player.play("crouch")

		STATE.HITTED:
			player.anim_player.play("hit")
			
	gravity(delta)
	player.move_and_slide()

func _on_animation_player_animation_finished(anim_name):

	if anim_name == "P":
		print("not atack")
		current_state = STATE.IDLE
	
	if anim_name == "hit":
		current_state = STATE.IDLE

	if anim_name == "dash":
		current_state = STATE.IDLE

	# if anim_name == "UP":
	# 	current_state = STATE.FALLING

func get_current_state():

	if current_state != 0:
		emit_signal("add_current_state", current_state)