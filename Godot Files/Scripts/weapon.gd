class_name Weapon

extends Node

@export var PARTICLES: GPUParticles3D

var RATEOFFIRE: int
var DAMAGE: int
var RELOADTIME: float
var MAGAZINESIZE: float
var ISAUTOMATIC: bool

func emit():
	PARTICLES.emitting = true
