extends Node


@export var is_server: bool = false
@export var username: String = "miku"
@export var port: int = 8080
@export var max_clients: int = 10
@export var ip_address: String = "10.0.0.0"

func get_local_ip() -> String:
	var ip = ""
	for address in IP.get_local_addresses():
		if "." in address and not address.begins_with("127.") and not address.begins_with("169.254."):
			if address.begins_with("192.168.") or address.begins_with("10.") or (address.begins_with("172.") and int(address.split(".")[1]) >= 16 and int(address.split(".")[1]) <= 31):
				ip = address
				break
	return ip
