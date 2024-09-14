extends Node

@onready var tower_node : Node = get_node("../Main/Game/Tower")

var attack_tower_scene : PackedScene = preload("res://scenes/tower/attack_tower.tscn")
var resource_tower_scene : PackedScene = preload("res://scenes/tower/resource_tower.tscn")
var support_tower_scene : PackedScene = preload("res://scenes/tower/support_tower.tscn")

var save_folder_path : String = "res://saves"

enum DIFFICULTY {EASY, MEDIUM, HARD}

const initial_health_easy : int = 200
const initial_health_medium : int = 150
const initial_health_hard : int = 100
const initial_max_power : int = 0
const initial_power : int = 0
const initial_money : float = 650.0
const initial_tempearture : float = 70.0

var map_id : int = 0
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
var money : float : 
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
#temperatures min: 0
var temperature_clamped : float :
	set(value):
		temperature_clamped = max(0.0, value)
		
		var temperature_diff = temperature_clamped - initial_tempearture
		temperature_speed_modifier = 1 + temperature_diff / 100
		
		SignalManager.temperature_changed.emit(temperature_clamped)	
var temperature_speed_modifier : float = 1.0

var wave_index : int = 0
var highscore : int = 0

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

func earn_money():
	var earning := 0.0
	
	if wave_index < 50:
		earning = 1.0
	elif wave_index < 60:
		earning = 0.5
	elif wave_index < 85:
		earning = 0.2
	elif wave_index < 100:
		earning = 0.1
	elif wave_index < 120:
		earning = 0.05
	else:
		earning = 0.02
		
	money += earning
		
		

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
	
func _ready():
	SignalManager.wave_index_changed.connect(increase_wave_index)
	SignalManager.on_wave_finished.connect(_on_wave_finished)
	
func increase_wave_index(_wave_index : int):
	self.wave_index = _wave_index

func _on_wave_finished():
	save_game()

func deal_damage_to_player(damage : int):
	health -= damage
	
	if health <= 0:
		defeat()
		
func defeat():
	SignalManager.defeat.emit()
	
func sell_tower(tower : Tower):
	SignalManager.on_tower_sell.emit()
	money += tower.sell_value
	temperature -= tower.tower_resource.temperature_increase
	power -= tower.tower_resource.power
	tower.queue_free()

func buy_tower(item : ShopItemResource, position):
	if item.price <= money and power + item.tower_resource.power <= max_power:
		
		SignalManager.on_upgrade_button_click.emit()
		
		money -= item.price
		power += item.tower_resource.power
		temperature += item.tower_resource.temperature_increase
		
		var tower_scene = get_tower_scene(item.tower_resource)
		
		var tower_instance = tower_scene.instantiate()
		tower_instance.sell_value = item.price / 2.0
		tower_instance.tower_resource = item.tower_resource
		tower_node.add_child(tower_instance)
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

func save_game():
	
	var game_progress_resource = GameProgressResource.new()
	game_progress_resource.map_scene_path = map_scene_path
	game_progress_resource.difficulty = difficulty
	
	#Save stats
	game_progress_resource.money = money
	game_progress_resource.health = health
	game_progress_resource.power = power
	game_progress_resource.max_power = max_power
	game_progress_resource.temperature = temperature
	
	game_progress_resource.wave_index = wave_index - 1


	game_progress_resource.cooler_resource_path = cooler.cooler_resource.resource_path
	game_progress_resource.power_supply_resource_path = power_supply.power_supply_resource.resource_path

	#Save tower
	for tower in tower_node.get_children():
		game_progress_resource.tower_resource_paths.append(tower.tower_resource.resource_path)
		game_progress_resource.tower_positions.append(tower.position)
		game_progress_resource.tower_sell_values.append(tower.sell_value)
		
		if tower is AttackTower:
			game_progress_resource.tower_damage_dealt.append(tower.damage_dealt)
			game_progress_resource.tower_money_generated.append(0)
			game_progress_resource.tower_prioritization.append(tower.target_prio_type)
		elif tower is ResourceTower:
			game_progress_resource.tower_damage_dealt.append(0)
			game_progress_resource.tower_money_generated.append(tower.money_generated)
			game_progress_resource.tower_prioritization.append(0)
		else:
			game_progress_resource.tower_damage_dealt.append(0)
			game_progress_resource.tower_money_generated.append(0)
			game_progress_resource.tower_prioritization.append(0)
		
	ResourceSaver.save(game_progress_resource, save_folder_path + "/games/" + str(map_id) + "_" + str(difficulty) + ".tres")

func load_game():
	
	if not ResourceLoader.exists(save_folder_path + "/games/" + str(map_id) + "_" + str(difficulty) + ".tres"):
		return
		
	var game_progress_resource = ResourceLoader.load(save_folder_path + "/games/" + str(map_id) + "_" + str(difficulty) + ".tres")
	
	cooler.cooler_resource = ResourceLoader.load(game_progress_resource.cooler_resource_path)
	cooler.init_resource()
	power_supply.power_supply_resource = ResourceLoader.load(game_progress_resource.power_supply_resource_path)
	power_supply.init_resource()
	
	#Load tower
	for tower_index in game_progress_resource.tower_resource_paths.size():
		var tower_resource = ResourceLoader.load(game_progress_resource.tower_resource_paths[tower_index])
	
		var tower_scene = get_tower_scene(tower_resource)
		var tower_instance = tower_scene.instantiate()
		tower_instance.tower_resource = tower_resource
		tower_instance.is_selectable = true
		tower_node.add_child(tower_instance)
		tower_instance.position = game_progress_resource.tower_positions[tower_index]
		tower_instance.sell_value = game_progress_resource.tower_sell_values[tower_index]
		
		if tower_instance is AttackTower:
			tower_instance.damage_dealt = game_progress_resource.tower_damage_dealt[tower_index]
			tower_instance.target_prio_type = game_progress_resource.tower_prioritization[tower_index]
		elif tower_instance is ResourceTower:
			tower_instance.money_generated = game_progress_resource.tower_money_generated[tower_index]
	
	#Load stats
	money = game_progress_resource.money 
	health = game_progress_resource.health 
	power = game_progress_resource.power 
	max_power = game_progress_resource.max_power 
	temperature = game_progress_resource.temperature 
	
	SignalManager.load_wave_index.emit(game_progress_resource.wave_index)

func delete_save_file():
	DirAccess.remove_absolute(save_folder_path + "/games/" + str(map_id) + "_" + str(difficulty) + ".tres")

func has_save_files():
	return ResourceLoader.exists(save_folder_path + "/games/" + str(map_id) + "_" + str(difficulty) + ".tres")

func save_highscore():
	if highscore < wave_index:
		highscore = wave_index
	
	var highscore_resource = HighscoreResource.new()
	highscore_resource.highscore = highscore
	ResourceSaver.save(highscore_resource, save_folder_path + "/highscores/" + str(map_id) + "_" + str(difficulty) + ".tres")
	
func load_highscore():
	if not ResourceLoader.exists(save_folder_path + "/highscores/" + str(map_id) + "_" + str(difficulty) + ".tres"):
		highscore = 0
		return
		
	var highscore_resource = ResourceLoader.load(save_folder_path + "/highscores/" + str(map_id) + "_" + str(difficulty) + ".tres")
	highscore = highscore_resource.highscore
