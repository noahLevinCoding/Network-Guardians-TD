extends State
class_name GameStateInitGame

@export var map_node : Node = null
@export var playing_menu : Playing = null

func enter():
	print("Enter GameState InitGame")
	map_node.add_child(load(GameManager.map_scene_path).instantiate())
	
	SignalManager.init_game.emit()
	
	GameManager.load_game()
	
	
	state_transition.emit(self, "Playing")
	
	
func exit():
	print("Exit GameState InitGame")
	
	
