extends Node

var help_ui: Label = null
var active_chest: Chest = null
var locked_chest: Chest = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_E and event.is_released():
		if active_chest:
			active_chest.open()
	elif event is InputEventKey and event.keycode == KEY_F and event.is_released():
		if active_chest and locked_chest != active_chest:
			active_chest.lock()
		elif active_chest and locked_chest == active_chest:
			active_chest.unlock()
