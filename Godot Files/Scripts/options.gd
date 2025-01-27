class_name Options

extends Control

@export var CONTROLSSETTINGS: Panel
@export var ACCESSIBILITYSETTINGS: Panel
@export var CURRENTSENSITIVITY: Label
@export var SENSITIVITYSLIDER: HSlider

const DEFAULTSENSITIVITY: int = 30

var currentSensitivity: int

signal sensitivity_changed(sens: int)
signal optionsExited

func _ready():
	currentSensitivity = DEFAULTSENSITIVITY
	SENSITIVITYSLIDER.value = DEFAULTSENSITIVITY
	CURRENTSENSITIVITY.text = str(DEFAULTSENSITIVITY)

func _on_controls_pressed():
	CONTROLSSETTINGS.visible = true
	ACCESSIBILITYSETTINGS.visible = false

func _on_accessibility_pressed():
	CONTROLSSETTINGS.visible = false
	ACCESSIBILITYSETTINGS.visible = true

func _on_sensitivity_slider_drag_ended(value_changed):
	if not value_changed:
		return
	CURRENTSENSITIVITY.text = str(SENSITIVITYSLIDER.value)
	currentSensitivity = SENSITIVITYSLIDER.value
	sensitivity_changed.emit(currentSensitivity)

func _on_sensitivity_slider_value_changed(value):
	CURRENTSENSITIVITY.text = str(value)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		visible = false
		optionsExited.emit()

func getSettings():
	return currentSensitivity
