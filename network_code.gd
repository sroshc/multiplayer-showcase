extends Node2D

const PLAYER: PackedScene = preload("res://player/player.tscn")
const START_POS: Vector2 = Vector2(46, 122)

var peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(NetworkInfo.is_server):
		peer.create_server(NetworkInfo.port, NetworkInfo.max_clients)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_new_player)
		multiplayer.peer_disconnected.connect(_player_left)
		add_child(Camera2D.new())
		print("Created server on one of these: " + str(IP.get_local_addresses()))
	else:
		peer.create_client(NetworkInfo.ip_address, NetworkInfo.port)
		multiplayer.multiplayer_peer = peer
		print("Created client!")
	


func _new_player(id: int):
	if(id == 1):
		return
	
	print("New player has joined with id of " + str(id))
	
	var new_player = PLAYER.instantiate()
	new_player.position = START_POS
	new_player.name = str(id)
	call_deferred("add_child", new_player)

func _player_left(id: int):
	get_node(str(id)).queue_free()


func _on_exit_button_pressed() -> void:
	if(multiplayer.is_server()):
		SceneSwitcher.end_temp_scene("Server closed successfully")
	else:
		peer.close()
		SceneSwitcher.end_temp_scene("Exited successfully")
		
		
