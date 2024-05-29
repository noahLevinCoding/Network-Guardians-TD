extends State
class_name GameStatePlaying

func enter():
	print("Enter GameState Playing")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		state_transition.emit(self, "Pause")
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		state_transition.emit(self, "End")
		return
		
	if Input.is_action_just_pressed("one"):
		EventManager.start_next_wave.emit()
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Playing")
	visible = false
