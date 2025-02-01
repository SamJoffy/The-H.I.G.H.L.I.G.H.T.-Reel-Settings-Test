extends Control

@export var VBOX: VBoxContainer
var playerStats: PackedScene = preload("res://Scenes/player_stats.tscn")

func _ready():
	addPlayer()

func addPlayer():
	VBOX.add_child(playerStats.instantiate())

func removePlayer(playerName: String):
	for i in VBOX.get_children():
		if i.name == playerName:
			i.queue_free()
			return
