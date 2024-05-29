extends State
class_name GameStatePause

func enter():
	print("Enter GameState Pause")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		state_transition.emit(self, "Playing")
	elif Input.is_action_just_pressed("ui_accept"):
		state_transition.emit(self, "Titlescreen")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Pause")
	visible = false
