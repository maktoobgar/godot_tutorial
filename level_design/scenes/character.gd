extends CharacterBody3D

var SPEED = 30
var JUMP_VELOCITY = 10
# Make it between 0 and 1
var ROTATION_COEFFICIENT = 0.12

@onready var cameraAnchor: Node3D = %CameraAnchor
@onready var forwardLead: Node3D = %ForwardLead
@onready var rightLead: Node3D = %RightLead

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	_move(delta)
	_rotate_camera()

# Moves our character
func _move(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "backward", "forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var forwardDirection = self.global_position.direction_to(forwardLead.global_position)
	var rightDirection = self.global_position.direction_to(rightLead.global_position)
	direction = (forwardDirection * input_dir.y + rightDirection * input_dir.x).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# Takes input from mouse and rotates character in different direction
func _rotate_camera():
	var cameraVelocity = Input.get_last_mouse_velocity()
	var xMaxMin = min(max(-1000, cameraVelocity.x), 1000)
	var yMaxMin = min(max(-1000, cameraVelocity.y), 1000)
	var cameraVelocityNormalized = Vector3(xMaxMin / 1000, yMaxMin / 1000, 0)

	cameraAnchor.rotation.y += (-cameraVelocityNormalized.x * ROTATION_COEFFICIENT)
	cameraAnchor.rotation.x += (-cameraVelocityNormalized.y * ROTATION_COEFFICIENT)
	cameraAnchor.rotation_degrees.x = min(max(cameraAnchor.rotation_degrees.x, -30), 20)
