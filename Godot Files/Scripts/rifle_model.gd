extends Node3D

@export var MODEL: MeshInstance3D

func changeColor(time: float):
	MODEL.set_surface_override_material(0, load("res://Materials/RedPlayerMaterial.tres"))
	await get_tree().create_timer(time).timeout
	MODEL.set_surface_override_material(0, load("res://Materials/rifleMaterial.tres"))
