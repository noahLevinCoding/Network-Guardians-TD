class_name Tower
extends Node2D

@export var sprite : Sprite2D
@export var attack_col_shape : CollisionShape2D
@export var place_col_shape : CollisionShape2D
@export var shoot_timer : Timer
@export var bullet_scene : PackedScene

@export var tower_resource : TowerResource	

var enemies = []
var current_enemy_target = null

var is_idle = true	#used for direct shooting if idle

func _ready():
	init_resource()
	
func init_resource():
	sprite.texture = tower_resource.tower_texture
	shoot_timer.wait_time = 1 / tower_resource.attack_speed 
	attack_col_shape.shape.radius = tower_resource.attack_range
	place_col_shape.shape = tower_resource.place_col_shape

func _on_area_2d_area_entered(area):
	if area.owner is Enemy:
		enemies.append(area.owner)
		
		if is_idle:
			is_idle = false
			shoot_timer.start()
			shoot()
		
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		upgrade(1)

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
	bullet_resource.speed = tower_resource.bullet_speed
	bullet_resource.bullet_visual_resource = tower_resource.bullet_visual_resource
	bullet_resource.pierce = tower_resource.pierce
	bullet_instance.bullet_resource = bullet_resource	
	
	add_child(bullet_instance)
		
func select_target():
	current_enemy_target = null
	
	match tower_resource.target_prio_type:
		tower_resource.TARGET_PRIO_TYPES.FIRST:
			select_first_target()
		tower_resource.TARGET_PRIO_TYPES.LAST:
			select_last_target()
		tower_resource.TARGET_PRIO_TYPES.CAMO:
			select_camo_target()
		tower_resource.TARGET_PRIO_TYPES.LEAD:
			select_lead_target()
		tower_resource.TARGET_PRIO_TYPES.HEALTHIEST:
			select_healthiest_target()
	
	if current_enemy_target == null:
		select_first_target()
	

func select_first_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy):
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio

func select_last_target():
	var current_enemy_target_progress_ratio = 2.0
	
	for enemy in enemies:
		if can_see_enemy(enemy):
			if enemy.progress_ratio <= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_camo_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and enemy.enemy_resource.is_camo:
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_lead_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and enemy.enemy_resource.is_lead:
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_healthiest_target():
	var current_enemy_target_health := 0.0
	
	for enemy in enemies:
		if can_see_enemy(enemy):
			if enemy.current_health >= current_enemy_target_health:
				current_enemy_target = enemy
				current_enemy_target_health = enemy.current_health

#Adjust when adding effects
func can_see_enemy(enemy : Enemy):
	if tower_resource.can_see_camo: #add effects
		return true
	else:
		return not enemy.enemy_resource.is_camo #add effects

func _on_shoot_timer_timeout():
	shoot()
	
func upgrade(path : int):
	if path == 1:
		tower_resource = tower_resource.upgrade_path_1_tower_resource
		init_resource()
	elif path == 2:
		tower_resource = tower_resource.upgrade_path_2_tower_resource
		init_resource()
		
	
