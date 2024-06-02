extends Node

enum DIFFICULTY {EASY, MEDIUM, HARD}


const start_player_health : int = 10
var current_player_health : int = 10

var map_scene_path : String = ""
var map_instance = null
var difficulty : DIFFICULTY = DIFFICULTY.MEDIUM

@onready var game_node : Node = get_tree().root.get_node("Game")


func _ready():
	EventManager.enemy_reached_goal.connect(_on_enemy_reached_goal)
	EventManager.reset_game.connect(_on_reset_game)
	EventManager.init_game.connect(_on_init_game)
	
func _on_enemy_reached_goal(enemy : Enemy):
	current_player_health -= enemy.damage
	
	if current_player_health <= 0:
		game_over()
		
func game_over():
	EventManager.game_over.emit()
	
	
func _on_reset_game():
	clear_old_objects()
	
func _on_init_game():
	create_new_objects()
	reset_parameters()
	
func reset_parameters():
	current_player_health = start_player_health
	
func clear_old_objects():
	#Map
	game_node.remove_child(map_instance)
	if map_instance != null:
		map_instance.queue_free()
		map_instance = null
	
	
func create_new_objects():
	var map_scene = load(map_scene_path)
	map_instance = map_scene.instantiate()
	game_node.add_child(map_instance)
