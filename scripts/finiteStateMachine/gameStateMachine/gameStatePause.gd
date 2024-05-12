extends State
class_name GameStatePause

func enter():
	print("Enter GameStatePause")
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		stateTransition.emit(self, "GameStatePlaying")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStatePause")
