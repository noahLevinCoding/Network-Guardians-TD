extends Node

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health_easy : int = 200
const initial_health_medium : int = 150
const initial_health_hard : int = 100

const initial_money : int = 200

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
		SignalManager.health_changed.emit(health)
var money : int : 
	set(value):
		money = value
		SignalManager.money_changed.emit(money)


func reset():
	is_paused = true
	
	if difficulty == DIFFICULTY.EASY:
		health = initial_health_easy
	elif difficulty == DIFFICULTY.MEDIUM:
		health = initial_health_medium
	else:
		health = initial_health_hard	
	
	money = initial_money
	
func deal_damage_to_player(damage : int):
	health -= damage
	
	if health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()

func buy_tower(item : ShopItemResource, position):
	if item.price <= money:
		money -= item.price
