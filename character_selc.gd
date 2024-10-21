extends CanvasLayer

signal btn_ready_pressed

@export var characters : PackedScene

@onready var character = characters.instantiate()

@onready var btn_ready = $"Panel/btn-middle-aling/ready_btn"
@onready var img_char_1 = $Panel/player_1/img_char_1; @onready var img_char_2 = $Panel/player_2/img_char_2

@onready var players = get_node("/root/Players")

var chars : Array

var img_char : TextureRect
var btn_char : TextureButton
var lab_char_name : Label

var char_clone : CharacterBody2D
@export var player_1 : CharacterBody2D
@export var player_2 : CharacterBody2D
var player_1_ready : bool = false
var player_2_ready : bool = false

func _ready():

	players.name = "players"
	
	get_parent().add_child.call_deferred(character)

	for i in range(0, character.get_child_count(), 1):
		chars.append(character.get_child(i))

	btn_ready.disabled = true
	btn_character()

func btn_character():

	for i in range(0, chars.size(), 1):

		chars[i].visible = false

		chars[i].process_mode = PROCESS_MODE_DISABLED

		btn_char = TextureButton.new()
		lab_char_name = Label.new()
		var texture_focus = TextureRect.new()
		btn_char.texture_normal = load("res://Sprites/HUD/btn_menu.png")

		btn_char.name = chars[i].name; lab_char_name.text = chars[i].name

		btn_char.add_child(lab_char_name)
		btn_char.add_child(texture_focus)

		lab_char_name.position.x = 20

		btn_char.pressed.connect(self.on_btn_char_pressed.bind(i))
		btn_char.focus_entered.connect(self.on_focus_char_entered.bind(i, texture_focus))
		btn_char.focus_exited.connect(self.on_focus_char_exited.bind(texture_focus))
			
		$Panel/btn_char_container.get_child(0).add_child(btn_char)

		if i == 0:
			btn_char.grab_focus()


func on_focus_char_entered(btn_array, btn_focus):

	img_char = chars[btn_array].get_node("char_img")

	if player_2_ready:
		return

	if player_1_ready:

		img_char_2.texture = img_char.get_texture()
		img_char_2.modulate = Color(0.267, 0.267, 0.267)
		btn_focus.texture = load("res://Sprites/HUD/focus_1P.png")

	else:

		img_char_1.texture = img_char.get_texture()
		img_char_1.modulate = Color(0.267, 0.267, 0.267)
		btn_focus.texture = load("res://Sprites/HUD/focus_1P.png")

func on_focus_char_exited(btn_focus):

	btn_focus.texture = null

func on_btn_char_pressed(btn_array):

	img_char = chars[btn_array].get_node("char_img")

	if player_2_ready:
		return

	if player_1_ready:

		print_debug(str(btn_array) + " " + "pressed")

		img_char_2.texture = img_char.get_texture()
		player_2_ready = true
		player_2 = chars[btn_array]
		player_2.player_control = "p2"


		if player_1 == player_2:

			char_clone = player_1.duplicate()

			char_clone.name = player_1.name + "2"

			players.add_child(char_clone)
			img_char_2.modulate = Color(1, 1, 1)

			char_clone.player_control = "p2"
			player_1.player_control = "p1"

		else:

			character.remove_child(player_2)
			players.add_child(player_2)
			img_char_2.modulate = Color(1, 1, 1)

	else:	
		
		print_debug(str(btn_array) + " " + "pressed")

		img_char_1.texture = img_char.get_texture()
		player_1_ready = true
		player_1 = chars[btn_array]
		character.remove_child(player_1)
		players.add_child(player_1)
		img_char_1.modulate = Color(1, 1, 1)

		player_1.player_control = "p1"
		
	on_players_ready()

func on_players_ready():
	
	if not player_1_ready or not player_2_ready:

		btn_ready.disabled = true

	for i in range(0, $Panel/btn_char_container/H_btn_aling.get_child_count(), 1):

		if player_1_ready and player_2_ready:
			btn_ready.disabled = false
			$Panel/btn_char_container/H_btn_aling.get_child(i).disabled = true

		else:
			$Panel/btn_char_container/H_btn_aling.get_child(i).disabled = false

func _input(event):

	if event is InputEventKey:
		if event.is_action_pressed("p1_heavy_attack"):

			if player_1_ready and not player_2_ready:
				img_char_1.modulate = Color(0.267, 0.267, 0.267)
				img_char_2.texture = null
				player_1_ready = false
				players.remove_child(player_1)
				character.add_child(player_1)
				
			elif player_1_ready and player_2_ready:

				if player_1 == player_2:

					players.remove_child(char_clone)

				else:
					img_char_2.modulate = Color(0.267, 0.267, 0.267)
					players.remove_child(player_2)
					character.add_child(player_2)

				player_2_ready = false
				
			on_players_ready()

func _on_ready_btn_pressed():

	players.ready_players()

	get_tree().change_scene_to_file("res://Scenes/map_selc.tscn")
