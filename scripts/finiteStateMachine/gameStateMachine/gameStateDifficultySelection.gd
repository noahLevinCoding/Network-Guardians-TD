extends State
class_name GameStateDifficultySelection

func enter():
	print("Enter GameState DifficultySelection")
	visible = true
		
func update(_delta : float):
	if Input.is_action_just_pressed("one"):
		GameManager.difficulty = GameManager.DIFFICULTY.EASY
		stateTransition.emit(self, "InitGame")
	elif Input.is_action_just_pressed("two"):
		GameManager.difficulty = GameManager.DIFFICULTY.MEDIUM
		stateTransition.emit(self, "InitGame")
	elif Input.is_action_just_pressed("three"):
		GameManager.difficulty = GameManager.DIFFICULTY.HARD
		stateTransition.emit(self, "InitGame")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState DifficultySelection")
	visible = false
