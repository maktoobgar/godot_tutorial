extends CharacterBody2D

const SPEED = 60.0
const RUN_SPEED = 120.0
const JUMP_VELOCITY = -260

@onready var character_sprites: AnimatedSprite2D = %CharacterSprites
@onready var help: Label = %Help
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer
@onready var player_name_label: Label = %Name
@onready var camera_2d: Camera2D = %Camera2D

var spawn_position = Vector2.ZERO
var unique_id = 1
var player_name = ""
var _position = Vector2.ZERO

func _ready() -> void:
	self.set_multiplayer_authority(unique_id, true)
	multiplayer_synchronizer.set_multiplayer_authority(unique_id)
	if unique_id != multiplayer.get_unique_id():
		camera_2d.enabled = false
	if unique_id != 1:
		modulate = Color("65ff588f")
	player_name_label.text = player_name
	Global.help_ui = help
	spawn_position = self.global_position

func _move(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	# Facing Right Way
	if direction == 1:
		character_sprites.flip_h = false
	elif direction == -1:
		character_sprites.flip_h = true
	# Animation
	if is_on_floor():
		if direction == 1:
			if Input.is_action_pressed("run"):
				character_sprites.play("run")
			else:
				character_sprites.play("walk")
		elif direction == -1:
			if Input.is_action_pressed("run"):
				character_sprites.play("run")
			else:
				character_sprites.play("walk")
		else:
			character_sprites.play("idle")
	# Jump
	else:
		if velocity.y > 0:
			character_sprites.play("jump")
		else:
			character_sprites.play("drop_down")
	# Movement
	if direction:
		velocity.x = lerp(velocity.x, direction * (RUN_SPEED if Input.is_action_pressed("run") else SPEED), 0.1)
	else:
		velocity.x = 0

	_position = global_position
	move_and_slide()

func _physics_process(delta: float) -> void:
	if unique_id == multiplayer.get_unique_id():
		_move(delta)
	else:
		global_position = global_position.lerp(_position, 0.3)
		if !character_sprites.is_playing():
			character_sprites.play()
