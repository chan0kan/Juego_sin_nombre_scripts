class_name map_script
extends Control

const MAP_SCENE = preload("res://Scenes/maps.tscn")

@onready var map_node = MAP_SCENE.instantiate()

var maps_path : Array

#-----------------AUTOLOADS----------------#

@onready var arena_auto = get_node("/root/ArenaManagement")
@onready var players = get_node("/root/players")

#-----------------AUTOLOADS----------------#

var label_map : Label
var btn_map : TextureButton
var focus_btn : TextureRect

var btn_elements = [btn_map, label_map, focus_btn]

func _ready():
	btn_maps()

func btn_maps():

	for i in map_node.get_child_count():

		maps_path.append(map_node.get_child(i).scene_file_path)

		if btn_elements.size() > 1:

			for element in range(0, btn_elements.size(), 1):

				if element == 0:

					btn_elements[element] = TextureButton.new()
					$"Panel/btn_map_containe/H_btn_aling".add_child(btn_elements[element])
					btn_elements[element].texture_normal = load("res://Sprites/HUD/btn_menu.png")
					btn_elements[element].pressed.connect(self.on_btn_map_pressed.bind(map_node.get_child(i)))
					btn_elements[element].pressed.connect(self.on_btn_map_focus.bind(btn_elements[element]))

					btn_elements[element].grab_focus()

					continue
				
				if element == 1:

					btn_elements[element] = Label.new()
					btn_elements[0].add_child(btn_elements[element])
					btn_elements[element].text = map_node.get_child(i).name

					btn_elements[element].position.x = 20

					continue

				else:

					btn_elements[element] = TextureRect.new()
					btn_elements[0].add_child(btn_elements[element])

					break

	print(maps_path)

func on_btn_map_pressed(arena):

	map_node.remove_child(arena)
	get_tree().change_scene_to_file("res://Scenes/versus_mode.tscn")
	arena_auto.arena_selected = true
	arena_auto.arena = arena
	arena_auto._arena_selected()
	players.ready_players()

func on_btn_map_focus(btn):

	btn.texture_focused = load("res://Sprites/HUD/focus_1P.png")
