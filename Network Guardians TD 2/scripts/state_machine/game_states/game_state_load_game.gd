class_name GameStateLoadGame
extends State

@export var load_game_node : LoadGame = null

func _ready():
	load_game_node.back.connect(_on_back)
	load_game_node.new_game.connect(_on_new_game)
	load_game_node.load_game.connect(_on_load_game)

func enter():
	print("Enter GameState LoadGame")
	
	if GameManager.has_save_files():
		load_game_node.visible = true
	else:
		state_transition.emit(self, "ResetGame")
	
	
func exit():
	load_game_node.visible = false
	print("Exit GameState LoadGame")
	
	
	
func _on_back():
	state_transition.emit(self, "DifficultySelection")
	
func _on_new_game():
	GameManager.delete_save_file()
	state_transition.emit(self, "ResetGame")
	
func _on_load_game():
	state_transition.emit(self, "ResetGame")
