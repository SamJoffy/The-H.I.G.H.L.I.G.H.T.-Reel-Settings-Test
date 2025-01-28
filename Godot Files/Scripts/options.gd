class_name Options

extends Control

@export var CONTROLSSETTINGS: Panel
@export var ACCESSIBILITYSETTINGS: Panel
@export var CURRENTSENSITIVITY: Label
@export var SENSITIVITYSLIDER: HSlider

const DEFAULTSENSITIVITY: int = 30

var currentSensitivity: int
var currentPlayerColor: GlobalItems.playerColors = GlobalItems.playerColors.RED

signal sensitivity_changed(sens: int)
signal optionsExited
signal player_color_changed(color: GlobalItems.playerColors)

func _ready():
	currentSensitivity = DEFAULTSENSITIVITY
	SENSITIVITYSLIDER.value = DEFAULTSENSITIVITY
	CURRENTSENSITIVITY.text = str(DEFAULTSENSITIVITY)
	player_color_changed.emit(currentPlayerColor)

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

## returns the settings in the order [sensitivity, player color]
func getSettings():
	return [currentSensitivity, currentPlayerColor]

func _on_blue_pressed():
	currentPlayerColor = GlobalItems.playerColors.BLUE
	player_color_changed.emit(GlobalItems.playerColors.BLUE)

func _on_red_pressed():
	currentPlayerColor = GlobalItems.playerColors.RED
	player_color_changed.emit(GlobalItems.playerColors.RED)

func setPlayerSettings(settings):
	currentSensitivity = settings[0]
	CURRENTSENSITIVITY.text = str(settings[0])
	SENSITIVITYSLIDER.value = settings[0]
	sensitivity_changed.emit(settings[0])
	
	currentPlayerColor = settings[1]
	player_color_changed.emit(settings[1])
