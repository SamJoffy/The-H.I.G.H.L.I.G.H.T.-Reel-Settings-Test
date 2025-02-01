extends Control

@export var NAME: Label
@export var KILLS: Label
@export var DEATHS: Label

var numKills: int = 0
var numDeaths: int = 0

func _ready():
	NAME.text = str(multiplayer.get_unique_id())
	self.name = str(multiplayer.get_unique_id())

func addKill():
	numKills += 1
	KILLS.text = str(numKills)

func addDeath():
	numDeaths += 1
	DEATHS.text = str(numDeaths)
