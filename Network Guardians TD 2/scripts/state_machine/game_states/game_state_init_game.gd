extends State
class_name GameStateInitGame

@export var game_node : Node = null
@export var playing_menu : Playing = null

func enter():
	print("Enter GameState InitGame")
	game_node.add_child(load(GameManager.map_scene_path).instantiate())
	
	playing_menu.reset()
	
	state_transition.emit(self, "Playing")
	
	
func exit():
	print("Exit GameState InitGame")
	
	
