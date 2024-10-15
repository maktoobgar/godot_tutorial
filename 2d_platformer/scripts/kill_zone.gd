extends Area2D

@onready var timer: Timer = %Timer

func _on_body_entered(body: Player):
	if timer.is_stopped():
		body.velocity.y = 10
		body.get_node('CollisionShape').queue_free()
		timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
