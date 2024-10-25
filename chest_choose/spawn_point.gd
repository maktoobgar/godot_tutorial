extends Node2D

func _ready() -> void:
	if Multiplayer._peer == null:
		var player = load("res://scenes/player.tscn").instantiate()
		player.global_position = self.global_position
		add_child(player)
	else:
		var ids = Multiplayer.players.keys()
		ids.sort()
		for id in ids:
			var player = load("res://scenes/player.tscn").instantiate()
			player.global_position = self.global_position
			player.player_name = Multiplayer.players[id].name
			player.unique_id = id
			add_child(player)
