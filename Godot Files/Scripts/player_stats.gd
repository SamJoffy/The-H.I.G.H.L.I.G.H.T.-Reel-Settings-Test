extends Control

@export var NAME: Label
@export var KILLS: Label
@export var DEATHS: Label

@export var k: int = 0
@export var d: int = 0

func _ready() -> void:
	KILLS.text = "0"
	DEATHS.text = "0"

func setName(name: String):
	NAME.text = name
	self.name = name

func addKill():
	k += 1
	KILLS.text = str(k)

func addDeath():
	d += 1
	DEATHS.text = str(d)
