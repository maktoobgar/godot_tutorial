extends Node2D

@export var speed = 60
@export var direction = 1
@onready var rayCastRight: RayCast2D = %RayCastRight
@onready var rayCastLeft: RayCast2D = %RayCastLeft
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta * direction

func _physics_process(delta):
	if rayCastRight.is_colliding():
		direction = -1
		animatedSprite.flip_h = true
	if rayCastLeft.is_colliding():
		direction = 1
		animatedSprite.flip_h = false
