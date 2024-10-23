extends Node2D

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite

func open() -> void:
	animated_sprite.play("open", 1, false)

func close() -> void:
	animated_sprite.play("open", -1, true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		open()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		close()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("here")
