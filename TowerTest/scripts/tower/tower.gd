class_name Tower
extends Node2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D
@export var shoot_timer : Timer

@export var tower_resource : TowerResource

@export var bullet_scene : PackedScene


var enemies = []
var current_enemy_target = null
var current_enemy_target_progress_ratio := 0.0

var is_idle = true

func _ready():
	sprite.texture = tower_resource.tower_texture
	shoot_timer.wait_time = 1 / tower_resource.attack_speed 
	col_shape.shape.radius = tower_resource.attack_range
	
func _on_area_2d_area_entered(area):
	if area.owner is Enemy:
		enemies.append(area.owner)
		
		if is_idle:
			is_idle = false
			shoot_timer.start()
			shoot()
		


func _on_area_2d_area_exited(area):
	if area.owner is Enemy:
		enemies.erase(area.owner)
		if area.owner == current_enemy_target:
			current_enemy_target = null
	
func shoot():
	select_target()
	if current_enemy_target != null:
		instantiate_bullet()
		
	else:
		is_idle = true
		shoot_timer.stop()
	
func instantiate_bullet():
	var bullet_instance = bullet_scene.instantiate()
	var bullet_resource = BulletResource.new()
	
	bullet_resource.target = current_enemy_target
	bullet_resource.can_pop_lead = tower_resource.can_pop_lead
	bullet_resource.attack_damage = tower_resource.attack_damage
	bullet_resource.speed = tower_resource.attack_speed * 100
	bullet_resource.bullet_visual_resource = tower_resource.bullet_visual_resource
	bullet_instance.bullet_resource = bullet_resource
	
	add_child(bullet_instance)
		
func select_target():
	if current_enemy_target == null:
		current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy):
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio

#Adjust when adding effects
func can_see_enemy(enemy : Enemy):
	return true
	#if tower_resource.can_see_camo:
		#return true
	#else:
		#return not enemy.enemy_resource.is_camo

func _on_shoot_timer_timeout():
	shoot()
