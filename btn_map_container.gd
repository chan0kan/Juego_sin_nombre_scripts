class_name maps_script
extends PanelContainer

const MAPS_SCENE = preload("res://Scenes/maps.tscn")

@onready var maps_node = MAPS_SCENE.instantiate()

var maps_path : Array
var btn_maps : Array

var label_map = Label.new()
var btn_map = TextureButton.new()
var texture_focus = TextureRect.new()

var btn_elements = [btn_map, label_map, texture_focus]

func _ready():
	maps_btn()

func maps_btn():

	for i in range(0, maps_node.get_child_count(), 1):
		
		print(i)

		maps_path.append(maps_node.get_child(i).scene_file_path)

		print("Mapa numero " + str(i) + " " + maps_path[i])

		btn_maps.append(btn_elements)

		for element in range(0, btn_maps[i].size(), 1):

			if element == 0:
				
				$H_btn_aling.add_child(btn_maps[i][element])
				btn_maps[i][element].name = maps_node.get_child(i).name

				continue

			else:

				$H_btn_aling.get_child(i).add_child(btn_maps[i][element])

		print(btn_maps)

		print($H_btn_aling.get_child(i))