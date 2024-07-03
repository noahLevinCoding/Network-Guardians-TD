extends Node

@export var initial_player_health : int = 10

var map_scene_path : String = ""
var difficulty : int = 1
var is_paused : bool = true :
	set(value):
		is_paused = value
		Engine.time_scale = 0 if value else 1.0


var player_health : int :
	set(value):
		player_health = value
		SignalManager.player_health_changed.emit()

func reset():
	is_paused = true
	player_health = initial_player_health
	

func deal_damage_to_player(damage : int):
	player_health -= damage
	
	if player_health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()
