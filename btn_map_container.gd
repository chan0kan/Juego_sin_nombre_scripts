class_name maps_script
extends Control

const MAPS_SCENE = preload("res://Scenes/maps.tscn")

@onready var maps_node = MAPS_SCENE.instantiate()

var maps_path : Array

@onready var map_img_show = $Panel/map_container/map_img 

var label_map : Label
var btn_map : TextureButton
var texture_focus : TextureRect

@onready var players = get_node("/root/players")

var btn_elements = [btn_map, label_map, texture_focus]

func _ready():
	maps_btn()

func maps_btn():

	for i in range(0, maps_node.get_child_count(), 1):
		
		print(i)

		maps_path.append(maps_node.get_child(i).scene_file_path)

		print("Mapa numero " + str(i) + " " + maps_path[i])

		if btn_elements.size() > 1:

			for element in btn_elements.size():

				if element == 0:

					btn_elements[element] = TextureButton.new()
					btn_elements[element].name = maps_node.get_child(i).name
					btn_elements[element].texture_normal = load("res://Sprites/HUD/btn_menu.png")
					btn_elements[element].texture_focused = load("res://Sprites/HUD/focus_1P.png")
					btn_elements[element].pressed.connect(self.on_btn_map_pressed.bind(maps_path[i]))
					btn_elements[element].focus_entered.connect(self.on_btn_map_focused.bind(maps_node.get_child(i)))

					$Panel/btn_map_container/H_btn_aling.add_child(btn_elements[element])

					btn_elements[element].grab_focus()

					continue

				if element == 1:

					btn_elements[element] = Label.new()
					btn_elements[0].add_child(btn_elements[element])

					continue

				else:

					btn_elements[element] = TextureRect.new()
					btn_elements[0].add_child(btn_elements[element])

					break

func on_btn_map_pressed(path):

	get_tree().change_scene_to_file(path)
	print_debug("Mapa cambiado a" + " " + str(path))

	for i in range(0, players.get_child_count()):
		
		players.get_child(i).process_mode = Node.PROCESS_MODE_INHERIT

func on_btn_map_focused(map):

	map_img_show.texture = map.get_child(1).get_texture()