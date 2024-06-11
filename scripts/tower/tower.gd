class_name Tower
extends Node2D

const ENEMY_LAYER = 1
const TOWER_LAYER = 2

var towers = []
var enemies = []

var current_enemy_target = null
var current_enemy_target_progress_ratio := 0.0

@onready var shoot_timer = %ShootTimer
@onready var animated_sprite_2d = %AnimatedSprite2D


@export_file("*.tscn") var bullet_scene_path : String = ""
@onready var bullet_scene : PackedScene = load(bullet_scene_path)

var is_idle = true

func _on_area_2d_area_entered(area):
	
	if(area.collision_layer == ENEMY_LAYER):
		enemies.append(area.owner)
		
		if is_idle:
			shoot()
			shoot_timer.start()
			animated_sprite_2d.play("shooting")
			is_idle = false
		
	elif(area.collision_layer == TOWER_LAYER):
		towers.append(area.owner)


func _on_area_2d_area_exited(area):
	if(area.collision_layer == ENEMY_LAYER):
		enemies.erase(area.owner)
		if area.owner == current_enemy_target:
			current_enemy_target = null
	elif(area.collision_layer == TOWER_LAYER):
		towers.erase(area.owner)
		
		
func select_target():
	if current_enemy_target == null:
		current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if enemy.progress_ratio >= current_enemy_target_progress_ratio:
			current_enemy_target = enemy
			current_enemy_target_progress_ratio = enemy.progress_ratio
			

func shoot():
	select_target()
	if current_enemy_target != null:
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.target = current_enemy_target
		add_child(bullet_instance)
	elif enemies.size() == 0:
		is_idle = true
		animated_sprite_2d.play("idle")
		shoot_timer.stop()
		
	

func _on_shoot_timer_timeout():
	shoot()
