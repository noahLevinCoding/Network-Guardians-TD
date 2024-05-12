extends State
class_name GameStateEnd

func enter():
	print("Enter GameStateEnd")
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStateTitlescreen")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStateEnd")
