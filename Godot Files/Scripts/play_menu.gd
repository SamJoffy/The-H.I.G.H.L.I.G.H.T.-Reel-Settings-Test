extends Control



func _on_host_pressed():
	get_tree().change_scene_to_file("res://Scenes/multiplayer_map.tscn")

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
