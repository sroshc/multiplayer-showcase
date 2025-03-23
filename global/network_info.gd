extends Node


@export var is_server: bool = false
@export var username: String = "miku"
@export var port: int = 8080
@export var max_clients: int = 10
@export var ip_address: String = "10.0.0.0"

func get_local_ip() -> String:
	var interfaces = IP.get_local_interfaces()
	print(str(interfaces))
	
	for interface in interfaces:
		if interface.name == "wlan0":
			return  interface.addresses[0]
	
	return "(not found)"
