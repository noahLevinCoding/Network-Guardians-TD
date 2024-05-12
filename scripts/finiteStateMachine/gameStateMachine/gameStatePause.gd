extends State
class_name GameStatePause

func enter():
	print("Enter GameState Pause")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		stateTransition.emit(self, "Playing")
	elif Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "Titlescreen")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Pause")
	visible = false
