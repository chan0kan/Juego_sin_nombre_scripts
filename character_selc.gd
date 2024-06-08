extends CanvasLayer

@export var characters : PackedScene

@onready var character = characters.instantiate()

@onready var btn_ready = $"Panel/btn-middle-aling/ready_btn"
@onready var img_char_1 = $Panel/player_1/img_char_1; @onready var img_char_2 = $Panel/player_2/img_char_2 

@onready var players = get_node("/root/Players")

@onready var chars : Array

@onready var player_controls = get_node("/root/PlayersControls")

var img_char
var btn_char : Button

var player_1
var player_2
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

		btn_char = Button.new()

		btn_char.name = chars[i].name; btn_char.text = chars[i].name
		btn_char.add_theme_font_size_override("font_size", 30)

		btn_char.pressed.connect(self.on_btn_char_pressed.bind(i))
		btn_char.focus_entered.connect(self.on_focus_char_entered.bind(i))
			
		$Panel/btn_char_container.get_child(0).add_child(btn_char)

		if i == 0:
			btn_char.grab_focus()


func on_focus_char_entered(btn):

	img_char = chars[btn].get_node("char_img")

	if player_2_ready:
		return

	if player_1_ready:

		img_char_2.texture = img_char.get_texture()
		img_char_2.modulate = Color(0.267, 0.267, 0.267)

	else:

		img_char_1.texture = img_char.get_texture()
		img_char_1.modulate = Color(0.267, 0.267, 0.267)
		

func on_btn_char_pressed(btn_array, char_clone):

	img_char = chars[btn_array].get_node("char_img")

	if player_2_ready:
		return

	if player_1_ready:

		print(str(btn_array) + " " + "pressed")

		img_char_2.texture = img_char.get_texture()
		player_2_ready = true
		player_2 = chars[btn_array]

		if player_1 == player_2:

			char_clone = player_1.duplicate()

			char_clone.name = player_1.name + "2"

			players.add_child(char_clone)

		else:

			character.remove_child(player_2)
			players.add_child(player_2)
			img_char_2.modulate = Color(1, 1, 1)

	else:	
		
		print(str(btn_array) + " " + "pressed")

		img_char_1.texture = img_char.get_texture()
		player_1_ready = true
		player_1 = chars[btn_array]
		character.remove_child(player_1)
		players.add_child(player_1)
		img_char_1.modulate = Color(1, 1, 1)

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

	if event is InputEvent:
		if event.is_action_pressed("player_1") and event.button_index == JOY_BUTTON_B:

			if player_1_ready and not player_2_ready:
				img_char_1.modulate = Color(0.267, 0.267, 0.267)
				img_char_2.texture = null
				player_1_ready = false
				players.remove_child(player_1)
				character.add_child(player_1)
				
			elif player_1_ready and player_2_ready:
				player_2_ready = false
				img_char_2.modulate = Color(0.267, 0.267, 0.267)
				players.remove_child(player_2)
				character.add_child(player_2)
				
			on_players_ready()

func _on_timer_timeout():
	pass

func _on_ready_btn_pressed():

	get_tree().change_scene_to_file("res://Scenes/versus_mode.tscn")

	#get_node("/root/Players").add_child.call_deferred(player_1, player_2)


