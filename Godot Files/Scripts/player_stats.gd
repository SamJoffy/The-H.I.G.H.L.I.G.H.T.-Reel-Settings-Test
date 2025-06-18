extends Control

@export var NAME: Label
@export var KILLS: Label
@export var DEATHS: Label

func setName(name: String):
	NAME.text = name
	self.name = name

@rpc("any_peer", "call_local", "reliable")
func updateStats(stats: Dictionary):
	KILLS.text = str(stats["kills"])
	DEATHS.text = str(stats["deaths"])
