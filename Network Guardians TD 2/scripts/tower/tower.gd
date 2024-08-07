class_name Tower
extends Node2D

enum TARGET_PRIO_TYPES {FIRST, LAST, CAMO, LEAD, HEALTHIEST}

@export var sprite : Sprite2D
@export var attack_col_shape : CollisionShape2D
@export var place_col_shape : CollisionShape2D
@export var range_indicator : Polygon2D
@export var shoot_timer : Timer
@export var bullet_scene : PackedScene

@export var tower_resource : TowerResource	
@export var select_shader_color : Color

var target_prio_type : TARGET_PRIO_TYPES = TARGET_PRIO_TYPES.FIRST
var sell_value : int

var enemies = []
var current_enemy_target = null
var current_enemy_targets = []

var is_idle = true	#used for direct shooting if idle

var is_selectable : bool = false
var is_selected : bool = false :
	set(value):
		is_selected = value
		range_indicator.visible = is_selected
		sprite.material.set_shader_parameter("line_color", select_shader_color if is_selected else Color(0,0,0,0))
		

var damage_dealt : float = 0.0

func _ready():
	range_indicator.color = Color(1, 1, 1, 0.2)
	init_resource()
	
	
func init_resource():
	sprite.texture = tower_resource.tower_texture
	shoot_timer.wait_time = 1 / tower_resource.attack_speed 
	attack_col_shape.shape.radius = tower_resource.attack_range
	place_col_shape.shape = tower_resource.place_col_shape
	
	var radius = tower_resource.attack_range
	var segments = 64
	var points = []
	
	for i in range(segments):
		var angle = 2 * PI * i / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
		
	range_indicator.polygon = points

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
	current_enemy_targets = []
	
	for i in range(tower_resource.number_of_targets):
		print(i)
		select_target()
		if current_enemy_target != null:
			instantiate_bullet()
		else:
			if current_enemy_targets == []:
				is_idle = true
				shoot_timer.stop()
			
			break
	
func instantiate_bullet():
	var bullet_instance = bullet_scene.instantiate()
	var bullet_resource = BulletResource.new()
	
	bullet_resource.target = current_enemy_target
	bullet_resource.attack_damage = tower_resource.attack_damage
	bullet_resource.speed = tower_resource.bullet_speed
	bullet_resource.bullet_visual_resource = tower_resource.bullet_visual_resource
	bullet_resource.pierce = tower_resource.pierce
	bullet_resource.source_tower = self
	bullet_resource.effects = tower_resource.effects
	bullet_resource.damage_type = tower_resource.damage_type
	bullet_resource.ignoes_damage_type_immunity = tower_resource.ignores_damage_type_immunity
	bullet_instance.bullet_resource = bullet_resource	
	
	add_child(bullet_instance)
		
func select_target():
	current_enemy_target = null
	
	match target_prio_type:
		TARGET_PRIO_TYPES.FIRST:
			select_first_target()
		TARGET_PRIO_TYPES.LAST:
			select_last_target()
		TARGET_PRIO_TYPES.CAMO:
			select_camo_target()
		TARGET_PRIO_TYPES.LEAD:
			select_lead_target()
		TARGET_PRIO_TYPES.HEALTHIEST:
			select_healthiest_target()
	
	if current_enemy_target == null:
		select_first_target()
		
	if current_enemy_target != null:
		current_enemy_targets.append(current_enemy_target)
	

func select_first_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and not current_enemy_targets.has(enemy):
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio

func select_last_target():
	var current_enemy_target_progress_ratio = 2.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and not current_enemy_targets.has(enemy):
			if enemy.progress_ratio <= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_camo_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and enemy.enemy_resource.is_camo and not current_enemy_targets.has(enemy):
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_lead_target():
	var current_enemy_target_progress_ratio = -1.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and enemy.enemy_resource.is_lead and not current_enemy_targets.has(enemy):
			if enemy.progress_ratio >= current_enemy_target_progress_ratio:
				current_enemy_target = enemy
				current_enemy_target_progress_ratio = enemy.progress_ratio
				
func select_healthiest_target():
	var current_enemy_target_health := 0.0
	
	for enemy in enemies:
		if can_see_enemy(enemy) and not current_enemy_targets.has(enemy):
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
	
func upgrade(path : int, price : int):
	if path == 1:
		tower_resource = tower_resource.upgrade_path_1_tower_resource
		init_resource()
	elif path == 2:
		tower_resource = tower_resource.upgrade_path_2_tower_resource
		init_resource()
		
	sell_value += price / 2
		
	


func _on_place_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		if is_selectable:
			SignalManager.select_tower_on_board.emit(self)
		else:
			is_selectable = true
			

func add_damage_dealt(damage : float):
	damage_dealt += damage
	if is_selected:
		SignalManager.selected_tower_damage_dealt_changed.emit()
		
