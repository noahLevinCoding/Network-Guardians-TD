extends State
class_name GameStatePlaying

func enter():
	print("Enter GameStatePlaying")
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		stateTransition.emit(self, "GameStatePause")
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStateEnd")
		return
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStatePlaying")
