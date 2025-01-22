class_name RunningPlayerState

extends PlayerMovementState

@export var SPEED: float = 10.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var DASHINGPLAYERSTATE: DashingPlayerState

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	if PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	elif Input.is_action_just_pressed("dash") and DASHINGPLAYERSTATE.getNumCharges() > 0:
		transition.emit("DashingPlayerState")
