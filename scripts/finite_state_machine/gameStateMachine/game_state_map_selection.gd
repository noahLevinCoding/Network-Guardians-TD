extends State
class_name GameStateMapSelection

@export_file("*.tscn") var map_1_scene_path : String = ""
@export_file("*.tscn") var map_2_scene_path : String = ""

func enter():
	print("Enter GameState MapSelection")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("one"):
		GameManager.map_scene_path = map_1_scene_path
		state_transition.emit(self, "DifficultySelection")
		
	elif Input.is_action_just_pressed("two"):
		GameManager.map_scene_path = map_2_scene_path
		state_transition.emit(self, "DifficultySelection")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState MapSelection")
	visible = false
