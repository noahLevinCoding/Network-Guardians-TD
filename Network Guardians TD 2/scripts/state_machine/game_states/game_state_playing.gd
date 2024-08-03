extends State
class_name GameStatePlaying

@export var playing_ui_node : Playing = null

func _ready():
	playing_ui_node.pause.connect(_on_pause)
	playing_ui_node.start_next_wave.connect(_on_start_next_wave)
	SignalManager.defeat.connect(_on_defeat)
	
func _on_reset():
	playing_ui_node.deselect()
	
func update(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_pause()

func enter():
	print("Enter GameState Playing")
	playing_ui_node.visible = true
	GameManager.is_paused = false
	
	
func exit():
	print("Exit GameState Playing")
	playing_ui_node.visible = false
	GameManager.is_paused = true
	
func _on_pause():
	SignalManager.pause_game.emit()
	state_transition.emit(self, "Pause")
	
func _on_start_next_wave():
	SignalManager.start_next_wave.emit()
	
func _on_defeat():
	state_transition.emit(self, "Defeat")
