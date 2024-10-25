@tool
extends TextureButton

@export var label: String = "": set = _setLabel

@onready var label_instance: Label = %Label

func _setLabel(input: String) -> void:
	if ! is_node_ready():
		await ready
	label_instance.text = input
	label = input
