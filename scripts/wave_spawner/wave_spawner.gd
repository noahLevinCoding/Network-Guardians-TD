class_name WaveSpawner
extends Node2D

@export_file("*.json") var waves_file_path : String = "res://resources/waves/waves.json"
@export var enemy_directory_path : String = "res://scenes/enemies/"

var waves : Array = []
var current_wave_index : int = -1
var current_wave_group_index : int = -1
var current_wave_group_enemy_index : int = -1

var current_wave : Wave = null
var current_wave_group : WaveGroup = null

var is_wave_active : bool = false

@onready var wave_active_timer = %WaveActiveTimer
@onready var betweem_enemies_timer = %BetweemEnemiesTimer
@onready var between_wave_groups_timer = %BetweenWaveGroupsTimer

var path = null

func _ready():
	parse_waves()
	EventManager.start_next_wave.connect(_on_start_next_wave)

func _on_start_next_wave():
	start_next_wave()
			
func start_next_wave():
	if is_wave_active == false:
		current_wave_index += 1
		current_wave_group_index = -1
		if current_wave_index < waves.size():
			is_wave_active = true
			current_wave = waves[current_wave_index]
			start_next_wave_group()
			
func start_next_wave_group():
	current_wave_group_index += 1
	current_wave_group_enemy_index = -1
	if current_wave_group_index < current_wave.wave_groups.size():
		current_wave_group = current_wave.wave_groups[current_wave_group_index]
		spawn_enemy()
	else:
		wave_active_timer.start()
		
func _on_spawn_enemy_timeout():
	spawn_enemy()
		
func spawn_enemy():
	current_wave_group_enemy_index += 1
	
	if current_wave_group_enemy_index < current_wave_group.enemy_count:
		var enemy_scene = load(current_wave_group.enemy_type)
		var enemy_scene_instance = enemy_scene.instantiate()
		
		path.add_child(enemy_scene_instance)
		
		betweem_enemies_timer.start(current_wave_group.time_between_enemies)
	else:
		between_wave_groups_timer.start(current_wave_group.time_after_wave_group)
	
func _on_wave_active_timer_timeout():
	if path.get_child_count() == 0:
		is_wave_active = false
	else:
		wave_active_timer.start()

func _on_start_next_wave_group_timeout():
	start_next_wave_group()


# JSON Parsing
func parse_waves() -> void:
	var file = FileAccess.open(waves_file_path, FileAccess.READ)
	var json_str = file.get_as_text()
	file.close()

	var json_parser = JSON.new()
	var parse_result = json_parser.parse(json_str)
	
	var json_data = []
	
	if parse_result != OK:
		print("Parsing error")
	else: 
		json_data = json_parser.data

	var waves_data = json_data["waves"]
	for wave_data in waves_data:
		parse_wave(wave_data)

func parse_wave(wave_data) -> void:
	var wave = Wave.new()
	if wave_data.has("wave_groups"):
		var wave_groups_data = wave_data["wave_groups"]
		for wave_group_data in wave_groups_data:
			var wave_group = parse_wave_group(wave_group_data)
			wave.wave_groups.append(wave_group)
	waves.append(wave)

func parse_wave_group(wave_group_data) -> WaveGroup:
	var wave_group = WaveGroup.new()
	if wave_group_data.has("enemy_type") and wave_group_data.has("enemy_count") and wave_group_data.has("time_between_enemies") and wave_group_data.has("time_after_wave_group"):
		wave_group.enemy_type = enemy_directory_path + wave_group_data["enemy_type"] + ".tscn"
		wave_group.enemy_count = wave_group_data["enemy_count"]
		wave_group.time_between_enemies = wave_group_data["time_between_enemies"]
		wave_group.time_after_wave_group = wave_group_data["time_after_wave_group"]
	return wave_group
