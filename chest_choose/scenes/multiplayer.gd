extends Node

class Player:
	var id: int
	var name: String

	func _init(id: int, name: String) -> void:
		self.id = id
		self.name = name

var _address: String = ""
var _port: int = -1
var _peer: ENetMultiplayerPeer = null

var player_name: String = ""
var players: Dictionary = {}

func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)

# Gets called on the server and clients
func _peer_connected(id: int) -> void:
	if multiplayer.is_server():
		inform_everyone_about_me_joining.rpc(player_name, multiplayer.get_unique_id())
	print("Player Connected {id}".format({"id": id}))

# Gets called on the server and clients
func _peer_disconnected(id: int) -> void:
	print("Player Disconnected {id}".format({"id": id}))

# Gets called only from clients
func _connected_to_server() -> void:
	inform_everyone_about_me_joining.rpc(player_name, multiplayer.get_unique_id())
	print("Connected To Server")

# Gets called only from clients
func _connection_failed() -> void:
	print("Couldn't Connect To Server")

func host(address: String, port: int) -> void:
	_address = address
	_port = port
	# Create a peer
	_peer = ENetMultiplayerPeer.new()
	# Create a server
	var err = _peer.create_server(_port, 32)
	if err != OK:
		print("Cannot Host: {err}".format({"err": err}))
	# Optional
	_peer.host.compress(ENetConnection.COMPRESS_NONE)

	multiplayer.multiplayer_peer = _peer
	print("Waiting for players")

func join(address: String, port: int) -> void:
	_address = address
	_port = port
	_peer = ENetMultiplayerPeer.new()
	_peer.create_client(address, port)
	# Optional
	_peer.host.compress(ENetConnection.COMPRESS_NONE)
	multiplayer.multiplayer_peer = _peer

@rpc("any_peer", "call_local", "reliable")
func inform_everyone_about_me_joining(name: String, id: int) -> void:
	if !players.has(id):
		players[id] = Player.new(id, name)
	print("from {id}, players: {players}".format({"id": multiplayer.get_unique_id(), "players": players}))

@rpc("authority", "call_local", "reliable")
func start_game() -> void:
	get_tree().change_scene_to_file("res://test.tscn")

# @rpc(?)
#
# any_peer = anyone can call it
# authority = only authority can call it
# call_local = it gets called on everyone else and local computer
# call_remote = ite gets called on just remote computers
# reliable = use tcp (slower but reliable)
# unreliable = use udp (faster but unreliable)
# unreliable_ordered = use udp but keep the orders of calls (faster but unreliable but at least we are in order)
