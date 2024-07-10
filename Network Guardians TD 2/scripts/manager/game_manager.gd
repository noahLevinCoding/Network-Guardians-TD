extends Node

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health : int = 10

var map_scene_path : String = ""
var difficulty : DIFFICULTY = DIFFICULTY.MEDIUM
var game_time_scale : float = 1.0 :
	set(value):
		game_time_scale = value
		is_paused = is_paused
		
var is_paused : bool = true :
	set(value):
		is_paused = value
		Engine.time_scale = 0 if value else game_time_scale


var health : int :
	set(value):
		health = value
		SignalManager.health_changed.emit()

func reset():
	is_paused = true
	health = initial_health
	

func deal_damage_to_player(damage : int):
	health -= damage
	
	if health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()
