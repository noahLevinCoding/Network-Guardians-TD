extends State
class_name GameStateMapSelection

@export var map_selection_node : MapSelection = null

func _ready():
	map_selection_node.set_map.connect(_on_set_map)
	map_selection_node.back.connect(_on_back)

func enter():
	print("Enter GameState MapSelection")
	map_selection_node.visible = true
	
func exit():
	print("Exit GameState Map Selection")
	map_selection_node.visible = false

func _on_set_map(map_scene_path : String, map_id : int):
	GameManager.map_scene_path = map_scene_path
	GameManager.map_id = map_id
	state_transition.emit(self, "DifficultySelection")
	
func _on_back():
	state_transition.emit(self, "Titlescreen")
	
func on_escape():
	SignalManager.on_button_click.emit()
	_on_back()
