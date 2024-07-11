extends Node

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health_easy : int = 200
const initial_health_medium : int = 150
const initial_health_hard : int = 100
const initial_max_power : int = 100
const initial_power : int = 0

const initial_money : int = 200
const initial_tempearture : float = 23.4

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
var power : int :
	set(value):
		power = value
		SignalManager.power_changed.emit(power)
var max_power : int : 
	set(value):
		max_power = value
		SignalManager.max_power_changed.emit(max_power)
var temperature : float :
	set(value):
		temperature = value
		SignalManager.temperature_changed.emit(temperature)

func reset():
	is_paused = true
	
	if difficulty == DIFFICULTY.EASY:
		health = initial_health_easy
	elif difficulty == DIFFICULTY.MEDIUM:
		health = initial_health_medium
	else:
		health = initial_health_hard	
	
	money = initial_money
	
	max_power = initial_max_power
	power = initial_power
	temperature = initial_tempearture
	
func deal_damage_to_player(damage : int):
	health -= damage
	
	if health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()

func buy_tower(item : ShopItemResource, position):
	if item.price <= money and power + item.tower_resource.power <= max_power:
		money -= item.price
		power += item.tower_resource.power
		temperature += item.tower_resource.temperature_increase
		
