extends Node2D

#Client fields
@onready var port_client: TextEdit = $"Client/Port-Client"
@onready var username: TextEdit = $Client/Username
@onready var ip: TextEdit = $Client/IP

#Server fields
@onready var max_clients: TextEdit = $"Server/Max-Clients"
@onready var port_server: TextEdit = $"Server/Port-Server"



@onready var result_message: Label = $"Result-Message"

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
	
