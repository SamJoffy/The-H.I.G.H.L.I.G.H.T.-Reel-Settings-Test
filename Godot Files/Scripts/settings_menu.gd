extends Control

@export var OPTIONS: Options
@export var MENU: Control

signal sensitivityChanged(sens: int)

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
