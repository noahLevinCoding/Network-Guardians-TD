extends State
class_name GameStateInitGame

func enter():
	print("Enter GameStateInitGame")
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStatePlaying")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStateInitGame")
