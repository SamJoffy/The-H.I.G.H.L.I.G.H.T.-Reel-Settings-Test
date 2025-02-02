class_name Weapon

extends Node

@export var PARTICLES: GPUParticles3D
@export var HITBOX: RayCast3D
@export var WEAPON: Node3D
@export var AMMOLABEL: Label

var RATEOFFIRE: int
var DAMAGE: int
var RELOADTIME: float
var MAGAZINESIZE: float
var ISREADY: bool = true
var ISRELOADED: bool = true
var AMMOLEFT: int

signal killedPlayer

func emit():
	PARTICLES.emitting = true

func fire():
	if not ISREADY or not ISRELOADED:
		return
	if AMMOLEFT <= 0:
		reload()
		return
	ISREADY = false
	AMMOLEFT -= 1
	emit()
	if HITBOX.is_colliding():
		if HITBOX.get_collider().getHealth() - DAMAGE <= 0:
			killedPlayer.emit()
		HITBOX.get_collider().hitPlayer.rpc_id(HITBOX.get_collider().get_multiplayer_authority(), DAMAGE)
	if AMMOLEFT <= 0:
		reload()
	else:
		updateAmmo()
		await get_tree().create_timer(60.0/RATEOFFIRE).timeout
		ISREADY = true

# Currently a bug where reloading, switching weapons, and then switching back
# before the reload time is up still reloads the weapon. Might keep in as feature
func reload():
	updateAmmo()
	WEAPON.changeColor(RELOADTIME)
	ISRELOADED = false
	await get_tree().create_timer(RELOADTIME).timeout
	if self.visible:
		AMMOLEFT = MAGAZINESIZE
		updateAmmo()
	ISREADY = true
	ISRELOADED = true

func updateAmmo():
	AMMOLABEL.text = str(AMMOLEFT) + "/" + str(MAGAZINESIZE)
