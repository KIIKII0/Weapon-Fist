extends Control







func _on_exit_button_pressed():
	get_tree().quit()



func _on_test_button_pressed():
	get_tree().change_scene_to_file("res://Arenas/test_arena.tscn")
