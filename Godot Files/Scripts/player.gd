class_name Player

extends CharacterBody3D


@export var JUMP_VELOCITY: float = 6.0
@export var SPEED: float = 10.0
@export var MOUSE_SENSITIVITY : float = 1.3
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var PLAYERMODEL : Node3D
@export var SETTINGSMENU : Control
@export var GUILAYER : CanvasLayer
@export var PRIMARYWEAPON: Weapon
@export var SECONDARYWEAPON: Weapon
@export var WEAPONHITBOX: RayCast3D
@export var WEAPONS: Node3D
@export var HEALTHBAR: ProgressBar


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_input: bool = false
var _mouse_rotation : Vector3
var _rotation_input: float = 0.0
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _current_rotation : float
var _tilt_input: float = 0.0
var jump_ready: bool = true
var health: int = 100
var currentWeapon: int = 0
var weaponSwitchCooldown: float = 0.3
var canSwitchWeapons: bool = true

var DEFAULTPLAYERCOLOR: GlobalItems.playerColors = GlobalItems.playerColors.RED

signal playerColorChanged(color: GlobalItems.playerColors)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CAMERA_CONTROLLER.current = is_multiplayer_authority()
	if is_multiplayer_authority():
		for i in PLAYERMODEL.get_children():
			i.set_layer_mask_value(1, false)
		GUILAYER.visible = true
		PRIMARYWEAPON.updateAmmo()

func _unhandled_input(event):
	if not is_multiplayer_authority():
		return
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jump_ready:
		jump_ready = false
		velocity.y = JUMP_VELOCITY
		await get_tree().create_timer(0.2).timeout
		jump_ready = true
	# Handle opening and closing SettingsMenu
	elif Input.is_action_just_pressed("escape") and is_multiplayer_authority():
		if not SETTINGSMENU.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			SETTINGSMENU.visible = true
		elif SETTINGSMENU.getMenuVisible():
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			SETTINGSMENU.visible = false
	
	if SETTINGSMENU.visible:
		return
	if Input.is_action_just_released("switch_weapons") and canSwitchWeapons:
		if currentWeapon == 0:
			currentWeapon = 1
			PRIMARYWEAPON.visible = false
			SECONDARYWEAPON.visible = true
		else:
			currentWeapon = 0
			PRIMARYWEAPON.visible = true
			SECONDARYWEAPON.visible = false
		canSwitchWeapons = false
		WEAPONS.get_child(currentWeapon).updateAmmo()
		await get_tree().create_timer(weaponSwitchCooldown).timeout
		canSwitchWeapons = true
	elif Input.is_action_just_pressed("reload"):
		WEAPONS.get_child(currentWeapon).reload()
	elif Input.is_action_pressed("shoot"):
		WEAPONS.get_child(currentWeapon).fire()

func _physics_process(delta):
	_update_camera(delta)

func _update_camera(delta):
	if not is_multiplayer_authority():
		return
	_current_rotation = _rotation_input
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0

func update_velocity() -> void:
	move_and_slide()

func update_gravity(delta) -> void:
	velocity.y -= gravity * delta

func _on_settings_menu_sensitivity_changed(sens):
	MOUSE_SENSITIVITY = 1 + (sens/100)

func _on_settings_menu_player_color_changed(color):
	DEFAULTPLAYERCOLOR = color
	playerColorChanged.emit(color)

func changeColor(color: GlobalItems.playerColors):
	PLAYERMODEL.changeColor(color)

func setPlayerSettings(settings):
	SETTINGSMENU.setPlayerSettings(settings)

@rpc("any_peer")
func hitPlayer(damage: int):
	health -= damage
	print("Current health: " + str(health))
	if health <= 0:
		self.position = Vector3(0, 1, 0)
		health = 100
	if is_multiplayer_authority():
		HEALTHBAR.value = health
