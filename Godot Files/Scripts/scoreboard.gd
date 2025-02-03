extends Control

@export var VBOX: VBoxContainer
var playerStats: PackedScene = preload("res://Scenes/player_stats.tscn")

@rpc("any_peer", "call_local")
func addPlayer(peer_id: int):
	var newStats = playerStats.instantiate()
	newStats.setName(str(peer_id))
	VBOX.add_child(newStats)

@rpc("any_peer", "call_local")
func removePlayer(playerName: String):
	for i in VBOX.get_children():
		if i.name == playerName:
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
