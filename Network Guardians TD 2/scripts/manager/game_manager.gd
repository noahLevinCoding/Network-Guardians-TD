extends Node

@onready var game_node : Node = get_node("../Main/Game")
var attack_tower_scene : PackedScene = preload("res://scenes/tower/attack_tower.tscn")
var resource_tower_scene : PackedScene = preload("res://scenes/tower/resource_tower.tscn")
var support_tower_scene : PackedScene = preload("res://scenes/tower/support_tower.tscn")

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health_easy : int = 200
const initial_health_medium : int = 150
const initial_health_hard : int = 100
const initial_max_power : int = 0
const initial_power : int = 0
const initial_money : int = 200
const initial_tempearture : float = 50.0

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
		temperature_clamped = temperature
var temperature_clamped : float :
	set(value):
		temperature_clamped = max(0.0, value)
		
		var temperature_diff = temperature_clamped - initial_tempearture
		temperature_speed_modifier = 1 + temperature_diff / 100
		
		SignalManager.temperature_changed.emit(temperature_clamped)	
var temperature_speed_modifier : float = 1.0

var cooler : Cooler :
	set(value):
		cooler = value
		if value != null:
			temperature -= value.cooler_resource.temperature_decrease
			
	
var power_supply : PowerSupply :
	set(value):
		power_supply = value
		
		if value != null:
			max_power = value.power_supply_resource.max_power

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
	
	cooler = null
	power_supply = null
	
	
func deal_damage_to_player(damage : int):
	health -= damage
	
	if health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()
	
func sell_tower(tower : Tower):
	money += tower.sell_value
	temperature -= tower.tower_resource.temperature_increase
	power -= tower.tower_resource.power
	tower.queue_free()

func buy_tower(item : ShopItemResource, position):
	if item.price <= money and power + item.tower_resource.power <= max_power:
		money -= item.price
		power += item.tower_resource.power
		temperature += item.tower_resource.temperature_increase
		
		var tower_scene = get_tower_scene(item.tower_resource)
		
		var tower_instance = tower_scene.instantiate()
		tower_instance.sell_value = item.price / 2.0
		tower_instance.tower_resource = item.tower_resource
		game_node.add_child(tower_instance)
		tower_instance.position = position
	
func get_tower_scene(tower_resource : TowerResource):
	if tower_resource is AttackTowerResource:
		return attack_tower_scene
	if tower_resource is ResourceTowerResource:
		return resource_tower_scene
	if tower_resource is SupportTowerResource:
		return support_tower_scene
		
	return null
	
func upgrade_tower(tower: Tower, path_id : int):

	var upgrade_tower_resource : TowerResource = get_upgrade_tower_resource(tower, path_id)	
	if upgrade_tower_resource == null:
		return
	
	var upgrade_price = get_upgrade_tower_price(tower.tower_resource, path_id)
	var upgrade_power = get_upgrade_tower_power(tower.tower_resource, upgrade_tower_resource)
	var upgrade_temperature_increase = get_upgrade_tower_temperature_increase(tower.tower_resource, upgrade_tower_resource)
	
	var has_enough_money : bool = upgrade_price <= money
	var has_enough_power : bool = upgrade_power <= max_power - power
	
	if has_enough_money and has_enough_power:
		money -= upgrade_price
		power += upgrade_power
		temperature += upgrade_temperature_increase
		tower.upgrade(path_id, upgrade_price)

func get_upgrade_tower_resource(tower: Tower, path_id : int):
	return tower.tower_resource.upgrade_path_1_tower_resource if path_id == 1 else tower.tower_resource.upgrade_path_2_tower_resource

func get_upgrade_tower_temperature_increase(tower_resource : TowerResource, upgrade_tower_resource : TowerResource):
	return upgrade_tower_resource.temperature_increase - tower_resource.temperature_increase

func get_upgrade_tower_power(tower_resource : TowerResource, upgrade_tower_resource : TowerResource):
	return upgrade_tower_resource.power - tower_resource.power

func get_upgrade_tower_price(tower_resource: TowerResource, path_id : int):
	
	if path_id == 1:
		if difficulty == GameManager.DIFFICULTY.EASY:
			return tower_resource.upgrade_path_1_price_easy
		elif difficulty == GameManager.DIFFICULTY.MEDIUM:
			return tower_resource.upgrade_path_1_price_medium
		else:
			return tower_resource.upgrade_path_1_price_hard
	else:
		if difficulty == GameManager.DIFFICULTY.EASY:
			return tower_resource.upgrade_path_2_price_easy
		elif difficulty == GameManager.DIFFICULTY.MEDIUM:
			return tower_resource.upgrade_path_2_price_medium
		else:
			return tower_resource.upgrade_path_2_price_hard

func upgrade_cooler():
	var price = get_upgrade_cooler_price(cooler.cooler_resource.upgrade_cooler_resource)
	
	if money >= price:
		money -= price
		temperature += cooler.cooler_resource.temperature_decrease
		cooler.upgrade()
		temperature -= cooler.cooler_resource.temperature_decrease
	
func upgrade_power_supply():
	var price = get_upgrade_power_supply_price(power_supply.power_supply_resource.upgrade_power_supply_resource)
	
	if money >= price:
		money -= price
		power_supply.upgrade()
		max_power = power_supply.power_supply_resource.max_power
	
func get_upgrade_cooler_price(cooler_resource: CoolerResource):
	if difficulty == GameManager.DIFFICULTY.EASY:
		return cooler_resource.upgrade_price_easy
	elif difficulty == GameManager.DIFFICULTY.MEDIUM:
		return cooler_resource.upgrade_price_medium
	else:
		return cooler_resource.upgrade_price_hard
		
func get_upgrade_power_supply_price(power_supply_resource: PowerSupplyResource):
	if difficulty == GameManager.DIFFICULTY.EASY:
		return power_supply_resource.upgrade_price_easy
	elif difficulty == GameManager.DIFFICULTY.MEDIUM:
		return power_supply_resource.upgrade_price_medium
	else:
		return power_supply_resource.upgrade_price_hard
