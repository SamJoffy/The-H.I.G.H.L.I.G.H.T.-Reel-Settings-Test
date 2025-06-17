class_name Scoreboard

extends Control

@export var VBOX: VBoxContainer
@export var GUI: CanvasLayer
@export var SettingsMenu: Control
@export var playerStats: PackedScene
@export var stats: Dictionary = {}

func _ready():
	SignalBus.playerDied.connect(addDeath)
	SignalBus.playerKill.connect(addKill)
	SignalBus.scoreBoardUpdated.connect(updateScoreBoard)
	#SignalBus.addPlayer.connect(addPlayer)
	#SignalBus.removePlayer.connect(removePlayer)
	multiplayer.peer_connected.connect(addPlayer)
	multiplayer.peer_disconnected.connect(removePlayer)
	addPlayer(multiplayer.get_unique_id())


func addPlayer(peer_id: int):
	print("Adding Player for id " + str(get_multiplayer_authority()))
	stats[str(peer_id) + "sb"] = {"kills": 0, "deaths": 0}
	print(stats)
	var newStats = playerStats.instantiate()
	newStats.setName(str(peer_id) + "sb")
	print("printing node " + newStats.name)
	VBOX.add_child(newStats)

func removePlayer(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName) + "sb":
			stats.erase(i.name)
			i.queue_free()
			return

func addKill(playerName: int):
	stats[str(playerName) + "sb"] = {"kills": (stats[str(playerName) + "sb"]["kills"] + 1)}

func addDeath(playerName: int):
	stats[str(playerName) + "sb"] = {"deaths": (stats[str(playerName) + "sb"]["deaths"] + 1)}

func _process(delta: float) -> void:
	for i in VBOX.get_children():
		if (i != $VBoxContainer/HBoxContainer and stats.size() > 0):
			i.updateStats(stats.get(i.name))

@rpc("any_peer", "call_local")
func updateScoreBoard(name: int, kills: int, deaths: int):
	for i in VBOX.get_children():
		if i.name == str(name) + "sb":
			i.setKills(kills)
			i.setDeaths(deaths)
			return
