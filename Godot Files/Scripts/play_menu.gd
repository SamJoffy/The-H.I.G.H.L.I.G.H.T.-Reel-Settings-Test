extends Control

@export var ADDRESSENTRY: LineEdit

var playerSettings

func _on_host_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("setPlayerSettings", playerSettings)
	map.call_deferred("startHost")
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		var mainMenu = load("res://Scenes/main_menu.tscn").instantiate()
		mainMenu.call_deferred("setPlayerSettings", playerSettings)
		get_tree().root.add_child(mainMenu)
		get_node("/root/PlayMenu").call_deferred("free")

func _on_join_local_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("setPlayerSettings", playerSettings)
	map.call_deferred("startJoinLocal")
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")

func _on_join_remote_pressed():
	var map = preload("res://Scenes/multiplayer_map.tscn").instantiate()
	map.call_deferred("setPlayerSettings", playerSettings)
	map.call_deferred("start_join_remote", ADDRESSENTRY.text)
	get_tree().root.add_child(map)
	get_node("/root/PlayMenu").call_deferred("free")

func setSettings(settings):
	playerSettings = settings
