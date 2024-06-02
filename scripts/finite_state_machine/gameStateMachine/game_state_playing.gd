extends State
class_name GameStatePlaying

func _ready():
	EventManager.game_over.connect(_on_game_over)

func enter():
	print("Enter GameState Playing")
	visible = true
	Engine.time_scale = 1
		
func update(_delta : float):
	if Input.is_action_just_pressed("pause"):
		state_transition.emit(self, "Pause")
	elif Input.is_action_just_pressed("one"):
		EventManager.start_next_wave.emit()
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameState Playing")
	visible = false

func _on_game_over():
	state_transition.emit(self, "End")
