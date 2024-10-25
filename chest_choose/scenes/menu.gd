extends Control

@onready var address: LineEdit = %Address
@onready var port: LineEdit = %Port
@onready var host_button: TextureButton = %HostButton
@onready var join_button: TextureButton = %JoinButton
@onready var start_button: TextureButton = %StartButton
@onready var name_line_edit: LineEdit = %NameLineEdit

func _ready() -> void:
	start_button.disabled = true

func _on_host_button_button_up() -> void:
	Multiplayer.host(address.text, int(port.text))
	start_button.disabled = false
	host_button.disabled = true
	join_button.disabled = true
	name_line_edit.editable = false

func _on_join_button_button_up() -> void:
	Multiplayer.join(address.text, int(port.text))
	host_button.disabled = true
	join_button.disabled = true
	name_line_edit.editable = false
	start_button.label = "  Waiting for Host  "

func _on_start_button_button_up() -> void:
	Multiplayer.start_game.rpc()

func _on_name_line_edit_text_changed(new_text: String) -> void:
	Multiplayer.player_name = new_text
