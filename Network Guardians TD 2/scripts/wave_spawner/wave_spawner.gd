class_name WaveSpawner
extends Node2D

@export var waves_resource : Waves
@export var enemy_scene : PackedScene
@export var path : Path2D 

@onready var waves = waves_resource.waves

var current_wave_index : int : 
	set(value):
		current_wave_index = value
		SignalManager.wave_index_changed.emit(current_wave_index)

var current_wave_group_index : int = -1
var current_wave_group_enemy_index : int = -1

var current_wave : Wave = null
var current_wave_group : WaveGroup = null

var is_wave_active : bool = false

@onready var is_wave_active_timer = %IsWaveActiveTimer
@onready var spawn_enemy_timer = %SpawnEnemyTimer
@onready var spawn_wave_group_timer = %SpawnWaveGroupTimer


func _ready():
	SignalManager.load_wave_index.connect(_on_load_wave_index)
	SignalManager.start_next_wave.connect(_on_start_next_wave)
	current_wave_index = -1

func _on_load_wave_index(wave_index : int):
	current_wave_index = wave_index + 1 

func _on_start_next_wave():
	start_next_wave()
	
func start_next_wave():
	if is_wave_active == false:
		if current_wave_index + 1 < waves.size():
			current_wave_index += 1
			current_wave_group_index = -1
			is_wave_active = true
			SignalManager.on_start_next_wave.emit()
			current_wave = waves[current_wave_index]
			start_next_wave_group()
			
func start_next_wave_group():
	current_wave_group_index += 1
	current_wave_group_enemy_index = -1
	if current_wave_group_index < current_wave.wave_groups.size():
		current_wave_group = current_wave.wave_groups[current_wave_group_index]
		spawn_enemy()
	else:
		is_wave_active_timer.start()
		
func spawn_enemy():
	current_wave_group_enemy_index += 1
	
	if current_wave_group_enemy_index < current_wave_group.enemy_count:
		
		var enemy_scene_instance = enemy_scene.instantiate()
		enemy_scene_instance.enemy_resource = current_wave_group.enemy_resource
		path.add_child(enemy_scene_instance)
		
		
		spawn_enemy_timer.start(current_wave_group.time_between_enemies / GameManager.temperature_speed_modifier)
	else:
		spawn_wave_group_timer.start(current_wave_group.time_after_wave_group / GameManager.temperature_speed_modifier)
	

func _on_is_wave_active_timer_timeout():
	if path.get_child_count() == 0:
		is_wave_active = false
		SignalManager.on_wave_finished.emit()
	else:
		is_wave_active_timer.start()
	
	#emit signal


func _on_spawn_wave_group_timer_timeout():
	start_next_wave_group()


func _on_spawn_enemy_timer_timeout():
	spawn_enemy()
