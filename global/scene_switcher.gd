extends Node

var current_scene: Node = null

var resolver: SceneTreeTimer = null
var saved_scene: Node = null
var saved_scene_result = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)

func goto_scene(path):
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	current_scene.free()
	
	#Instanciate and Load the next scene
	var scene_loader = ResourceLoader.load(path)
	current_scene = scene_loader.instantiate()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func save_scene_and_goto(path: String) -> Variant:
	_deferred_save_scene_and_goto.call_deferred(path)
	
	return saved_scene_result
	
	
func _deferred_save_scene_and_goto(path):
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	current_scene.hide()
	get_tree().root.remove_child(current_scene)

	saved_scene = current_scene
	
	var scene_loader = ResourceLoader.load(path)
	current_scene = scene_loader.instantiate()
	get_tree().root.add_child(current_scene)
	
	
	resolver = get_tree().create_timer(9999) #Temporary await (make better later)
	await resolver.timeout
	resolver = null
	
	current_scene.queue_free()
	current_scene = saved_scene
	saved_scene = null
	
	current_scene.process_mode = Node.PROCESS_MODE_INHERIT
	current_scene.show()
	
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	


func end_temp_scene(result: Variant):
	if(resolver):
		saved_scene_result = result
		resolver.emit_signal("timeout")
		resolver = null
