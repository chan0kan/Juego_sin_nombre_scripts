class_name Player extends CharacterBody2D

var SPEED = 300.0
var JUMP_VELOCITY = -600
const FALL_VELOCITY = 500

enum STATE{
	IDLE,
	RIGHT,
	LEFT,
	UP,
	DOWN,
	FALLING,
	DEFENSE,
	DOWN_DEFENSE,
	HITTED,
	NORMAL_ATTACK,
	HEAVY_ATTACK,
	COMBINATION
}

var current_state : STATE = STATE.IDLE

@onready var anim = $AnimatedSprite2D 
@onready var anim_player = $AnimationPlayer
@onready var timer = $Timer
@onready var hit_boxs = $"Attack_hit_boxs"
@onready var sprite = $"Sprites_1"
@onready var player_ident = $"Label"
@onready var hurt_box = $"hurt_box"
@onready var player_controls = $"PlayerControl"
@onready var label_current_state = $"current_state"

var life_points = 100

var actual_life_points : float

var player_view_direction :	STATE
var player_control : String

func recibe_damage(damage_points:float):

	life_points -= damage_points

	print("La vida actual del " +  player_control + " es igual a " + str(life_points))

	current_state = STATE.HITTED

func defend_damage(damage_points : float):

	life_points -= damage_points

	print("ataque defendido")

func _on_player_control_show_current_state(state):
	label_current_state.text = "state= " + str(state)
