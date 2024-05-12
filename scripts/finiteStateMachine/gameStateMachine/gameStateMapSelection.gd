extends State
class_name GameStateMapSelection

@export_file("*.tscn") var map1ScenePath : String = ""
@export_file("*.tscn") var map2ScenePath : String = ""

func enter():
	print("Enter GameState MapSelection")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("one"):
		GameManager.mapScenePath = map1ScenePath
		stateTransition.emit(self, "DifficultySelection")
		
	elif Input.is_action_just_pressed("two"):
		GameManager.mapScenePath = map2ScenePath
		stateTransition.emit(self, "DifficultySelection")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState MapSelection")
	visible = false
