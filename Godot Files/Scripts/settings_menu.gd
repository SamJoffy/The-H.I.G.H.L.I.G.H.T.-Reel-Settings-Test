extends Control

@export var OPTIONS: Control
@export var MENU: Control

signal sensitivityChanged(sens: int)
signal playerColorChanged(color: GlobalItems.playerColors)

func _on_exit_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	MENU.visible = false
	OPTIONS.visible = true

func _on_options_options_exited():
	MENU.visible = true

func getMenuVisible():
	return MENU.visible

func _on_options_sensitivity_changed(sens):
	sensitivityChanged.emit(sens)

func _on_options_player_color_changed(color):
	playerColorChanged.emit(color)

func setPlayerSettings(settings):
	OPTIONS.setPlayerSettings(settings)
