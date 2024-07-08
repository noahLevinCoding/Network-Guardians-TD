extends State
class_name GameStateResetGame

@export var game_node : Node = null

func enter():
	print("Enter GameState ResetGame")
	for child in game_node.get_children():
		game_node.remove_child(child)
		child.queue_free()
	
	GameManager.reset()
	
	state_transition.emit(self, "InitGame")
	
	
func exit():
	print("Exit GameState ResetGame")
	
	
