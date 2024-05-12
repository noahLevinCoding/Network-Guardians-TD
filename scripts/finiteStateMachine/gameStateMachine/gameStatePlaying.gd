extends State
class_name GameStatePlaying

func enter():
	print("Enter GameState Playing")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		stateTransition.emit(self, "Pause")
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "End")
		return
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Playing")
	visible = false
