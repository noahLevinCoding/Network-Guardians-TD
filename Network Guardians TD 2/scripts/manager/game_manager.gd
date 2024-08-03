extends Node

@onready var game_node : Node = get_node("../Main/Game")
var tower_scene : PackedScene = preload("res://scenes/tower/tower.tscn")

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health_easy : int = 200
const initial_health_medium : int = 150
const initial_health_hard : int = 100
const initial_max_power : int = 100
const initial_power : int = 0
const initial_money : int = 200
const initial_tempearture : float = 23.4

var map_scene_path : String = ""
var difficulty : DIFFICULTY 
var game_time_scale : float = 1.0 :
	set(value):
		game_time_scale = value
		is_paused = is_paused
var is_paused : bool = true :
	set(value):
		is_paused = value
		Engine.time_scale = 0.0 if value else game_time_scale
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
		
		var temperature_diff = temperature - initial_tempearture
	
		if temperature_diff > 0:
			temperature_speed_modifier = 1 + temperature_diff / 100
		else:
			temperature_speed_modifier = 1.0
var temperature_speed_modifier : float = 1.0

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
		
		var tower_instance = tower_scene.instantiate()
		tower_instance.tower_resource = item.tower_resource
		game_node.add_child(tower_instance)
		tower_instance.position = position
		
func upgrade_tower(tower: Tower, path_id : int):

	var upgrade_tower_resource : TowerResource = get_upgrade_tower_resource(tower, path_id)	
	if upgrade_tower_resource == null:
		return
	
	var upgrade_price = get_upgrade_price(upgrade_tower_resource)
	var upgrade_power = get_upgrade_power(tower.tower_resource, upgrade_tower_resource)
	var upgrade_temperature_increase = get_upgrade_temperature_increase(tower.tower_resource, upgrade_tower_resource)
	
	var has_enough_money : bool = upgrade_price <= money
	var has_enough_power : bool = upgrade_power <= max_power - power
	
	if has_enough_money and has_enough_power:
		money -= upgrade_price
		power += upgrade_power
		temperature += upgrade_temperature_increase
		tower.upgrade(path_id)

func get_upgrade_tower_resource(tower: Tower, path_id : int):
	return tower.tower_resource.upgrade_path_1_tower_resource if path_id == 1 else tower.tower_resource.upgrade_path_2_tower_resource

func get_upgrade_temperature_increase(tower_resource : TowerResource, upgrade_tower_resource : TowerResource):
	return upgrade_tower_resource.temperature_increase - tower_resource.temperature_increase

func get_upgrade_power(tower_resource : TowerResource, upgrade_tower_resource : TowerResource):
	return upgrade_tower_resource.power - tower_resource.power

func get_upgrade_price(tower_resource: TowerResource):
	if difficulty == GameManager.DIFFICULTY.EASY:
		return tower_resource.upgrade_price_easy
	elif difficulty == GameManager.DIFFICULTY.MEDIUM:
		return tower_resource.upgrade_price_medium
	else:
		return tower_resource.upgrade_price_hard

