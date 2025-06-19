class_name Scoreboard

extends Control

@export var VBOX: VBoxContainer
@export var GUI: CanvasLayer
@export var SettingsMenu: Control
@export var playerStats: PackedScene
@export var players: Node
	
func _ready():
	SignalBus.addPlayer.connect(addPlayer)
	SignalBus.removePlayer.connect(removePlayer)
	SignalBus.openScoreboard.connect(setVisible)
	SignalBus.closeScoreboard.connect(setInvisible)
	SignalBus.playerDied.connect(addDeath)
	SignalBus.playerKill.connect(addKill)


func addPlayer(peer_id: int) -> void:
	for i in players.get_children():
		if i.is_multiplayer_authority():
			var newStats = playerStats.instantiate()
			newStats.setName(str(peer_id) + "sb")
			VBOX.add_child(newStats)

func removePlayer(playerName: int):
	for i in VBOX.get_children():
		if i.name == str(playerName) + "sb":
			i.queue_free()
			return

@rpc("any_peer", "call_local", "reliable")
func addKill(playerName: int):
	if not multiplayer.is_server():
		rpc_id(1, "addKill", playerName)
		return
	for i in VBOX.get_children():
		if i.name == str(playerName) + "sb":
			i.addKill()
			return

@rpc("any_peer", "call_local", "reliable")
func addDeath(playerName: int):
	if not multiplayer.is_server():
		rpc_id(1, "addDeath", playerName)
		return
	for i in VBOX.get_children():
		if i.name == str(playerName) + "sb":
			i.addDeath()
			return

func setVisible() -> void:
	visible = true
	
func setInvisible() -> void:
	visible = false
