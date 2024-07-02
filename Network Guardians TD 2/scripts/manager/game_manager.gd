extends Node

var map_scene_path : String = ""
var difficulty : int = 1
var is_paused : bool = true :
	set(value):
		is_paused = value
		Engine.time_scale = 0 if value else 1.0


var player_health : int

func reset():
	is_paused = true
	player_health = 10
	
	SignalManager.player_health_changed.emit()

func deal_damage_to_player(damage : int):
	player_health -= damage
	SignalManager.player_health_changed.emit()
	
	if player_health <= 0:
		game_over()
		
func game_over():
	pass
