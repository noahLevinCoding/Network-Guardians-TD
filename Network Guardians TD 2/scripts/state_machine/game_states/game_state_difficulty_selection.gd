extends State
class_name GameStateDifficultySelection

@export var difficulty_selection_node : DifficultySelection = null

func _ready():
	difficulty_selection_node.back.connect(_on_back)
	difficulty_selection_node.set_difficulty.connect(_on_set_difficulty)

func enter():
	print("Enter GameState DifficultySelection")
	difficulty_selection_node.visible = true
	
func exit():
	print("Exit GameState DifficultySelection")
	difficulty_selection_node.visible = false

func _on_set_difficulty(difficulty : int):
	GameManager.difficulty = difficulty
	state_transition.emit(self, "ResetGame")
	
func _on_back():
	state_transition.emit(self, "MapSelection")
	
