extends State
class_name GameStateTitlescreen

func enter():
	print("Enter GameStateTitlescreen")
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStateMapSelection")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStateTitlescreen")
