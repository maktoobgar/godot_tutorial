extends CharacterBody2D

const SPEED = 60.0
const RUN_SPEED = 120.0
const JUMP_VELOCITY = -260

@onready var character_sprites: AnimatedSprite2D = %CharacterSprites
@onready var help: Label = %Help

var spawn_position = Vector2.ZERO

func _ready() -> void:
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

	move_and_slide()

func _physics_process(delta: float) -> void:
	_move(delta)
