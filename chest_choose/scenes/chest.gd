extends Node2D

class_name Chest

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var ui_animation_player: AnimationPlayer = %UIAnimationPlayer
@onready var select_sign: Sprite2D = %SelectSign

var is_open: bool = false

func _ready() -> void:
	animated_sprite.animation_changed.connect(_run_animation_if_not_server)

func _run_animation_if_not_server() -> void:
	if !multiplayer.is_server():
		animated_sprite.play()

func open() -> void:
	unlock()
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
	Global.locked_chest = null

func _on_body_entered(body: Node2D) -> void:
	ui_animation_player.play("show", 1, 1, false)
	if not is_open and multiplayer.is_server() and body.unique_id == 1:
		Global.active_chest = self
		Global.help_ui.visible = true

func _on_body_exited(body: Node2D) -> void:
	ui_animation_player.play("show", 1, -1, true)
	if not is_open and multiplayer.is_server() and body.unique_id == 1:
		Global.active_chest = null
		Global.help_ui.visible = false
