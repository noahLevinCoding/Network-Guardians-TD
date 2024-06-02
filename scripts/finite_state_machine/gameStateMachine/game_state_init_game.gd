extends State
class_name GameStateInitGame

func enter():
	print("Enter GameState InitGame")
	visible = true
	
	EventManager.reset_game.emit()
	EventManager.init_game.emit()
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		state_transition.emit(self, "Playing")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState InitGame")
	visible = false
