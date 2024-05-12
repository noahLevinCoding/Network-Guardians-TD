extends State
class_name GameStateEnd

func enter():
	print("Enter GameState End")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "Titlescreen")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState End")
	visible = false
