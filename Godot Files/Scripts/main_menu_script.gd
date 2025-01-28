extends Control

@export var OPTIONSMENU: Control



func _on_play_pressed():
	var currentSettings = OPTIONSMENU.getSettings()
	var playMenu = load("res://Scenes/play_menu.tscn").instantiate()
	playMenu.call_deferred("setSettings", currentSettings)
	get_tree().root.add_child(playMenu)
	get_node("/root/MainMenu").call_deferred("free")

func _on_options_pressed():
	OPTIONSMENU.visible = true

func _on_exit_pressed():
	get_tree().quit()

func setPlayerSettings(settings):
	OPTIONSMENU.setPlayerSettings(settings)
