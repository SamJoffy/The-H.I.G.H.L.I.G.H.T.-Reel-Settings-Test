extends Control

@export var NAME: Label
@export var KILLS: Label
@export var DEATHS: Label

var numKills: int = 0
var numDeaths: int = 0

func addKill():
	print("AddKill playerstats: " + NAME.text + ". Multiplayer Authority: " + str(get_multiplayer_authority()))
	numKills += 1
	KILLS.text = str(numKills)
	SignalBus.scoreBoardUpdated.emit(int(str(self.name)), numKills, numDeaths)

func addDeath():
	print("AddDeath playerstats: " + NAME.text + ". Multiplayer Authority: " + str(get_multiplayer_authority()))
	numDeaths += 1
	DEATHS.text = str(numDeaths)
	SignalBus.scoreBoardUpdated.emit(int(str(self.name)), numKills, numDeaths)

func setName(name: String):
	NAME.text = name
	self.name = name

func setDeaths(deaths: int):
	numDeaths = deaths
	DEATHS.text = str(numDeaths)
	
func setKills(kills: int):
	numKills = kills
	KILLS.text = str(numKills)
