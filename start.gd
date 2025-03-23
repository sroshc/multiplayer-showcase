extends Node2D

var debug: bool = true

#Client fields
@onready var port_client: TextEdit = $"Client/Port-Client"
@onready var username: TextEdit = $Client/Username
@onready var ip: TextEdit = $Client/IP

#Server fields
@onready var max_clients: TextEdit = $"Server/Max-Clients"
@onready var port_server: TextEdit = $"Server/Port-Server"

#Debug buttons
@onready var debug_node: Node = $CanvasLayer/Debug
@onready var debug_client: Button = $"CanvasLayer/Debug/Debug-Client"
@onready var debug_server: Button = $"CanvasLayer/Debug/Debug-Server"

@onready var result_message: Label = $"Result-Message"

func _ready() -> void:
	if not debug:
		debug_node.queue_free()


func _on_clientbutton_pressed() -> void:
	NetworkInfo.is_server = false
	NetworkInfo.port = int(port_client.text)
	NetworkInfo.username = username.text
	NetworkInfo.ip_address = ip.text
	SceneSwitcher.save_scene_and_goto("res://world.tscn")


func _on_serverbutton_pressed() -> void:
	NetworkInfo.is_server = true
	NetworkInfo.port = int(port_server.text)
	NetworkInfo.max_clients = int(max_clients.text)
	SceneSwitcher.save_scene_and_goto("res://world.tscn")


func _on_debug_client_pressed() -> void:
	NetworkInfo.is_server = false
	NetworkInfo.port = 8080
	NetworkInfo.username = "test_miku"
	NetworkInfo.ip_address = "localhost"
	SceneSwitcher.save_scene_and_goto("res://world.tscn")


func _on_debug_server_pressed() -> void:
	NetworkInfo.is_server = true
	NetworkInfo.port = 8080
	NetworkInfo.max_clients = 32
	SceneSwitcher.save_scene_and_goto("res://world.tscn")


func _on_exitbutton_pressed() -> void:
	get_tree().quit(0)
