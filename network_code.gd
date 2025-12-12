extends Node2D

const PLAYER: PackedScene = preload("res://player/player.tscn")

@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var message_box: TextEdit = $"CanvasLayer/Message-Box"
@onready var send_message: Button = $"CanvasLayer/Send-Message"
@onready var ip_label: Label = $"CanvasLayer/IP-Label"
@onready var latest_message: Label = $"CanvasLayer/Latest-Message"
@onready var player_node: Control = $Players

var peer = ENetMultiplayerPeer.new()
var server_cam: Camera2D

### Making a new client or a new server ###
func _ready() -> void:
	if(NetworkInfo.is_server):
		peer.create_server(NetworkInfo.port, NetworkInfo.max_clients)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_new_player)
		multiplayer.peer_disconnected.connect(_player_left)
		server_cam = Camera2D.new()
		add_child(server_cam)
		send_message.queue_free()
		message_box.queue_free()
		ip_label.text = "Server running on " + NetworkInfo.get_local_ip() + " \non port " + str(NetworkInfo.port)
	else:
		peer.create_client(NetworkInfo.ip_address, NetworkInfo.port)
		multiplayer.multiplayer_peer = peer
		print("Created client!")


### Handling players joining and leaving ###
func _new_player(id: int):
	if(id == 1):
		return
	
	print("New player has joined with id of " + str(id))
	
	var new_player = PLAYER.instantiate()
	new_player.name = str(id)
	player_node.call_deferred("add_child", new_player)

func _player_left(id: int):
	print("Player with id of %s left!" % str(id) )
	player_node.get_node(str(id)).queue_free()
###======================================###



### Sending a message to all the clients ###
func _on_send_message_pressed() -> void:
	if message_box.text == "":
		return
	
	rpc("receive_message", NetworkInfo.username + ": " + message_box.text)
	message_box.text = ""

@rpc("any_peer", "call_local", "reliable")
func receive_message(message: String) -> void:
	latest_message.add_message(message)
###======================================###

### Handle clients leaving ###
func _on_exit_button_pressed() -> void:
	if(multiplayer.is_server()):
		SceneSwitcher.end_temp_scene("Server closed successfully")
	else:
		peer.close()
		SceneSwitcher.end_temp_scene("Exited successfully")
###======================================###





const CAMERA_SPEED: int = 300
var direction: Vector2
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	
	direction = Vector2(0, 0)
	
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")
	
	server_cam.position += direction * delta * CAMERA_SPEED
	
	

func is_typing():
	return message_box.has_focus()
