class_name Scoreboard

extends Control

@export var VBOX: VBoxContainer
@export var GUI: CanvasLayer
@export var SettingsMenu: Control
@export var playerStats: PackedScene
@export var players: Node
static var stats: Dictionary = {}

func _ready():
	SignalBus.playerDied.connect(addDeath)
	SignalBus.playerKill.connect(addKill)
	#SignalBus.scoreBoardUpdated.connect(updateScoreBoard)
	#SignalBus.addPlayer.connect(addPlayer)
	#SignalBus.removePlayer.connect(removePlayer)
	SignalBus.openScoreboard.connect(setVisible)
	SignalBus.closeScoreboard.connect(setInvisible)
	multiplayer.peer_connected.connect(addPlayer)
	multiplayer.peer_disconnected.connect(removePlayer)
	stats[str(1) + "sb"] = {"kills": 0, "deaths": 0}
	var newStats = playerStats.instantiate()
	newStats.setName(str(1) + "sb")
	VBOX.add_child(newStats)


func addPlayer(peer_id: int) -> void:
	for i in players.get_children():
		if i.is_multiplayer_authority():
			stats[str(peer_id) + "sb"] = {"kills": 0, "deaths": 0}
			var newStats = playerStats.instantiate()
			newStats.setName(str(peer_id) + "sb")
			VBOX.add_child(newStats)

func removePlayer(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName) + "sb":
			stats.erase(i.name)
			i.queue_free()
			return

func addKill(playerName: int):
	print("Adding kill for player " + str(playerName))
	stats[str(playerName) + "sb"]["kills"] += 1
	print(stats)

func addDeath(playerName: int):
	stats[str(playerName) + "sb"]["deaths"] += 1

func _process(delta: float) -> void:
	for i in VBOX.get_children():
		if (i != $VBoxContainer/HBoxContainer and stats.size() > 0):
			if (stats.has(i.name)):
				i.updateStats.rpc(stats.get(i.name))	

func setVisible() -> void:
	visible = true
	
func setInvisible() -> void:
	visible = false
