extends Node2D

const PLAYER: PackedScene = preload("res://player/player.tscn")
const START_POS: Vector2 = Vector2(46, 122)

@onready var message_box: TextEdit = $"CanvasLayer/Message-Box"
@onready var send_message: Button = $"CanvasLayer/Send-Message"
@onready var ip_label: Label = $"CanvasLayer/IP-Label"
@onready var latest_message: Label = $"CanvasLayer/Latest-Message"

var peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(NetworkInfo.is_server):
		peer.create_server(NetworkInfo.port, NetworkInfo.max_clients)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_new_player)
		multiplayer.peer_disconnected.connect(_player_left)
		add_child(Camera2D.new())
		send_message.queue_free()
		message_box.queue_free()
		ip_label.text = "Server running on " + NetworkInfo.get_local_ip() + " \non port " + str(NetworkInfo.port)
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
	
func _on_send_message_pressed() -> void:
	if message_box.text == "":
		return
	
	rpc("receive_message", NetworkInfo.username + ": " + message_box.text)
	message_box.text = ""

@rpc("any_peer", "call_local", "reliable")
func receive_message(message: String) -> void:
	latest_message.text = message


func _on_exit_button_pressed() -> void:
	if(multiplayer.is_server()):
		SceneSwitcher.end_temp_scene("Server closed successfully")
	else:
		peer.close()
		SceneSwitcher.end_temp_scene("Exited successfully")

func is_typing():
	return message_box.has_focus()
