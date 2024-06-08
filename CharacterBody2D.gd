extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -2100
const GRAVITY = 98.0

@onready var anim = $AnimatedSprite2D 
@onready var anim_player = $AnimationPlayer
@onready var timer = $Timer

var attacking : bool = false  # Variable para rastrear si el personaje está atacando
var move : bool = false  # Varible para determinar si el personaje se esta moviendo

func _ready(): 
	pass

# De aca
func _process(delta):
	
	if not is_on_floor():
		velocity.y += GRAVITY
		SPEED = 670

	else:
		
		SPEED = 300
		velocity.y = 0
# Hasta acá sabes lo que hace (define las propiedades del salto)

	# Manejar el ataque
	if Input.is_action_just_pressed("attack") and not attacking:
		anim_player.play("attack")
		# anim.play("attack")   Aca tenia un ("attack", false) para que no se repdoduzca en bucle pero lo arregle en el nodo (y a mi me lo rompe)
		attacking = true  # Establece el estado de ataque como verdadero

		# var attack_hit = Area2D.new() || para la hitbox del ataque
	
	if not attacking: # Si NO esta atacando puede ejecutar todo lo que sigue...

	# Manejar el movimiento vertical
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Manejar el movimiento horizontal
		var direction = Input.get_axis("ui_left", "ui_right")
		if Input.is_action_pressed("run") and (direction > 0 or direction < 0):
			SPEED = 500

		if direction != 0:
			velocity.x = direction * SPEED
			move = true

			if move: # SI se esta moviendo puede ejecutarse todo lo que sigue...
			
				if direction < 0:
					anim_player.play("walk_back")
					 # anim.play("walk_back")
				else:
					anim_player.play("walk")
					 # anim.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim_player.play("stand")
			#anim.play("stand")
			move = false

# Si quieren que no se pueda mover mientras ataca borren todo lo que esta depues del else y pongan: move = false

	else: # SI esta atacando se puede ejecutar todo lo que sigue...

			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			var direction = Input.get_axis("ui_left", "ui_right")

			if direction != 0:
				velocity.x = direction * SPEED

			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _on_animation_player_animation_finished(anim_name):

	if anim_name == "attack": # Determina que no se esta atacando cuando termine de ejecutarse la animacion
		attacking = false
		print("not atack")

