extends State
class_name GameStateInitGame

func enter():
	print("Enter GameState InitGame")
	visible = true
	
	for old_map in %Map.get_children():
		%Map.remove_child(old_map)
		old_map.queue_free()
	
	var map_scene = load(GameManager.map_scenePath)
	var map_instance = map_scene.instantiate()
	%Map.add_child(map_instance)
	
	print(GameManager.map_scenePath)
	print(GameManager.difficulty)
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		state_transition.emit(self, "Playing")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState InitGame")
	visible = false
