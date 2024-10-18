@tool

extends Camera3D

@onready var cameraPositionLead: Node3D = %CameraPositionLead
@onready var cameraPositionLeadOriginalPosition = cameraPositionLead.position
@onready var rayCast: RayCast3D = %RayCast
@onready var cameraAnchor: Node3D = %CameraAnchor

func _ready() -> void:
	self.global_position = cameraPositionLead.global_position
	self.global_rotation = cameraPositionLead.global_rotation

func _physics_process(delta: float) -> void:
	_rotate_and_position_camera()
	_camera_clamp_fixer_with_raycast()

func _rotate_and_position_camera() -> void:
	self.global_position = self.global_position.lerp(cameraPositionLead.global_position, 0.3)
	self.global_rotation.x = lerp_angle(self.global_rotation.x, cameraPositionLead.global_rotation.x, 0.25)
	self.global_rotation.y = lerp_angle(self.global_rotation.y, cameraPositionLead.global_rotation.y, 0.25)
	self.global_rotation.z = lerp_angle(self.global_rotation.z, cameraPositionLead.global_rotation.z, 0.25)

	# ! This doesn't work, it jitters
	#self.rotation = lerp(self.rotation, cameraPositionLead.rotation, 0.3)

func _camera_clamp_fixer_with_raycast():
	if rayCast.is_colliding():
		var collisionPoint = rayCast.get_collision_point()
		var normalizedMargin = collisionPoint.direction_to(cameraAnchor.global_position).normalized()
		cameraPositionLead.global_position = collisionPoint + normalizedMargin * 3
	else:
		cameraPositionLead.position = cameraPositionLeadOriginalPosition
