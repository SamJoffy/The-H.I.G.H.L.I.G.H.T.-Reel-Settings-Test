extends Control

@export var NAME: Label
@export var KILLS: Label
@export var DEATHS: Label

var numKills: int = 0
var numDeaths: int = 0

@rpc("any_peer", "call_local")
func addKill():
	print("AddKill playerstats: " + NAME.text + ". Multiplayer Authority: " + str(get_multiplayer_authority()))
	numKills += 1
	KILLS.text = str(numKills)

@rpc("any_peer", "call_local")
func addDeath():
	print("AddDeath playerstats: " + NAME.text + ". Multiplayer Authority: " + str(get_multiplayer_authority()))
	numDeaths += 1
	DEATHS.text = str(numDeaths)

func setName(name: String):
	NAME.text = name
	self.name = name
