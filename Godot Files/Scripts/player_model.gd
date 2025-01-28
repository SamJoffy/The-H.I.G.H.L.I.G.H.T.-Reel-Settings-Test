class_name PlayerModel

extends Node3D

@export var BODY: MeshInstance3D
@export var BluePlayerColor: StandardMaterial3D
@export var RedPlayerColor: StandardMaterial3D


func changeColor(color: GlobalItems.playerColors):
	match color:
		GlobalItems.playerColors.RED:
			BODY.set_surface_override_material(0, RedPlayerColor)
		GlobalItems.playerColors.BLUE:
			BODY.set_surface_override_material(0, BluePlayerColor)
