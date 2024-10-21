extends CanvasLayer

func _on_versus_pressed():
	get_tree().change_scene_to_file("res://Scenes/character_selc.tscn")

func _on_practice_pressed():
	get_tree().change_scene_to_file("res://Scenes/character_selc.tscn")

func _on_out_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu_init.tscn")
