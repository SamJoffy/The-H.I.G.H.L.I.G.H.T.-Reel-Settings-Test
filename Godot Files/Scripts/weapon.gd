class_name Weapon

extends Node

@export var PARTICLES: GPUParticles3D
@export var HITBOX: RayCast3D
@export var WEAPON: Node3D

var RATEOFFIRE: int
var DAMAGE: int
var RELOADTIME: float
var MAGAZINESIZE: float
var ISREADY: bool = true
var ISRELOADED: bool = true
var AMMOLEFT: int

func emit():
	PARTICLES.emitting = true

func fire():
	if not ISREADY or not ISRELOADED:
		return
	ISREADY = false
	AMMOLEFT -= 1
	emit()
	if HITBOX.is_colliding():
			HITBOX.get_collider().hitPlayer.rpc_id(HITBOX.get_collider().get_multiplayer_authority(), DAMAGE)
	if AMMOLEFT <= 0:
		reload()
	else:
		await get_tree().create_timer(60.0/RATEOFFIRE).timeout
		ISREADY = true

func reload():
	WEAPON.changeColor(RELOADTIME)
	ISRELOADED = false
	await get_tree().create_timer(RELOADTIME).timeout
	AMMOLEFT = MAGAZINESIZE
	ISREADY = true
	ISRELOADED = true
