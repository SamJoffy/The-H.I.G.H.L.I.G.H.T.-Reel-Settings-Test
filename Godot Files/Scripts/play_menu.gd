extends Control

@export var ADDRESSENTRY: LineEdit

func _on_host_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("startHost")
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_join_local_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("startJoinLocal")
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")


func _on_join_remote_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("start_join_remote", ADDRESSENTRY.text)
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")
