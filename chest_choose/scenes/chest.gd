extends Node2D

class_name Chest

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var ui_animation_player: AnimationPlayer = %UIAnimationPlayer
@onready var select_sign: Sprite2D = %SelectSign

var is_open: bool = false

func open() -> void:
	Global.active_chest = null
	Global.help_ui.visible = false

	animated_sprite.play("open", 1, false)
	is_open = true
	ui_animation_player.play("show", 1, -1, true)

func lock() -> void:
	if Global.locked_chest:
		Global.locked_chest.unlock()
	select_sign.visible = true
	Global.locked_chest = self

func unlock() -> void:
	select_sign.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_open:
		Global.active_chest = self
		ui_animation_player.play("show", 1, 1, false)
		Global.help_ui.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if not is_open:
		Global.active_chest = null
		ui_animation_player.play("show", 1, -1, true)
		Global.help_ui.visible = false
