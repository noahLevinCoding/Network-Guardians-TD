extends State
class_name GameStateInitGame

func enter():
	print("Enter GameState InitGame")
	visible = true
	
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
