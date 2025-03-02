extends Control

@export var VBOX: VBoxContainer
@export var GUI: CanvasLayer
@export var SettingsMenu: Control

var playerStats: PackedScene = preload("res://Scenes/player_stats.tscn")

func _ready():
	SignalBus.playerDied.connect(addDeath)
	SignalBus.playerKill.connect(addKill)
	SignalBus.scoreBoardUpdated.connect(updateScoreBoard)
	SignalBus.addPlayer.connect(addPlayer)
	SignalBus.removePlayer.connect(removePlayer)

func addPlayer(peer_id: int):
	var newStats = playerStats.instantiate()
	newStats.setName(str(peer_id))
	VBOX.add_child(newStats)

func removePlayer(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName):
			i.queue_free()
			return

func addKill(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName):
			i.addKill()
			return

func addDeath(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName):
			i.addDeath()
			return

@rpc("any_peer", "call_local")
func updateScoreBoard(name: int, kills: int, deaths: int):
	for i in VBOX.get_children():
		if i.name == str(name):
			i.setKills(kills)
			i.setDeaths(deaths)
			return


