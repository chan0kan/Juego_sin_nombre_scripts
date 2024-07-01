extends CanvasLayer

@onready var btn_cont = $Vbtn_container

@onready var opt_screen = get_tree().get_root().get_node("Menu_init/Panel/options")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu_1.tscn")

func _on_options_pressed():
	opt_screen.show()

func _on_out_pressed():
	get_tree().quit()
