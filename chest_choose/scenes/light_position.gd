extends Node2D

@onready var light_and_texture_container: Node2D = %LightAndTextureContainer

func _physics_process(delta: float) -> void:
	light_and_texture_container.global_position = light_and_texture_container.global_position.lerp(self.global_position, 0.03)
