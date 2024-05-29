extends State
class_name GameStateTitlescreen

func enter():
	print("Enter GameState Titlescreen")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		state_transition.emit(self, "MapSelection")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Titlescreen")
	visible = false
