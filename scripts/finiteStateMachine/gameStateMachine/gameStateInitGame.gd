extends State
class_name GameStateInitGame

func enter():
	print("Enter GameState InitGame")
	visible = true
	
	for oldMap in %Map.get_children():
		%Map.remove_child(oldMap)
		oldMap.queue_free()
	
	var mapScene = load(GameManager.mapScenePath)
	var mapInstance = mapScene.instantiate()
	%Map.add_child(mapInstance)
	
	print(GameManager.mapScenePath)
	print(GameManager.difficulty)
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "Playing")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState InitGame")
	visible = false
