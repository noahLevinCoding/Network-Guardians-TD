class_name Enemy
extends PathFollow2D

@export var base_animated_sprite : AnimatedSprite2D
@export var camo_sprite : Sprite2D
@export var fortified_sprite : Sprite2D
@export var regrow_sprite : Sprite2D

@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource
@export var base_speed_multiplier : float = 100

@export var child_spawn_displacement : float = 10

var enemy_scene : PackedScene = load("res://scenes/enemy/enemy.tscn")

var current_health : float
var current_speed : float

var effects : Array[EnemyEffect] = []
var slow_multiplier : float = 1.0
var is_knockbacked : bool = false
var knockback_speed : float = 0.0

var regrow_parent_resources = []
@export var regrow_timer : Timer

var last_position := Vector2.ZERO

func _ready():
	init_resource()
	
func _physics_process(delta):
	last_position = global_position
	reset_effect_parameters()
	apply_effects(delta)
	calc_current_speed()
	move(delta)
	check_if_rotation()
	check_if_end()
	
func check_if_rotation():
	var diff = global_position - last_position
	
	
	if diff.x > -0.2 and diff.x < 0.2:
		return
	
	elif diff.x < 0:
		base_animated_sprite.flip_h = true
		fortified_sprite.flip_h = true
		camo_sprite.flip_h = true
		regrow_sprite.flip_h = true
		
	elif diff.x > 0:
		base_animated_sprite.flip_h = false
		fortified_sprite.flip_h = false
		camo_sprite.flip_h = false
		regrow_sprite.flip_h = false
	
	
func reset_effect_parameters():
		slow_multiplier = 1.0
		is_knockbacked = false
		knockback_speed = 0.0

func apply_effects(delta):
	for effect in effects:
		effect.apply_effect(self, delta)
			
func end_of_effect(effect : EnemyEffect):
	effects.erase(effect)

func calc_current_speed():
	if is_knockbacked and not enemy_resource.enemy_type == enemy_resource.ENEMY_TYPES.TROJAN:
		current_speed = -knockback_speed * base_speed_multiplier
	else:
		current_speed = enemy_resource.base_speed * GameManager.temperature_speed_modifier  * base_speed_multiplier
		if not enemy_resource.is_immunte_to_slow:
			current_speed *= slow_multiplier
	
func move(delta : float):
	progress += current_speed * delta
	
func check_if_end():
	if progress_ratio >= 1:
		var damage_to_player = calc_damage_to_player(enemy_resource)
		GameManager.deal_damage_to_player(damage_to_player)
		
		queue_free()
	
#recursively calculating the count of enemies / damage to player 	
func calc_damage_to_player(child_enemy_resource : EnemyResource):
	if child_enemy_resource.child_quantities.size() == 0:
		return 1
	else:
		var damage_from_children = 0
		
		for child_index in child_enemy_resource.child_quantities.size():
			var quantity = child_enemy_resource.child_quantities[child_index]
			damage_from_children += quantity * calc_damage_to_player(child_enemy_resource.child_resources[child_index])
		
		return  1 + damage_from_children
		
func take_damage(bullet_resource : BulletResource):

	bullet_resource = duplicate_bullet_resource(bullet_resource)

	for effect_resource in bullet_resource.effects:
		effects.append(EnemyEffect.new(effect_resource, bullet_resource.source_tower))
	
	
	if is_immune(bullet_resource):
		return
	
	SignalManager.on_enemy_take_damage.emit()	#Sound
	
	if enemy_resource.enemy_type == enemy_resource.ENEMY_TYPES.TROJAN and bullet_resource.extra_damage_to_trojan:
		bullet_resource.attack_damage *= 2
	
	#Apply pierce 
	while bullet_resource.attack_damage > current_health and enemy_resource.child_quantities.size() == 1 and enemy_resource.child_quantities[0] == 1 and  bullet_resource.pierce > 1 and not enemy_resource.is_immune_to_pierce:
		bullet_resource.attack_damage -= current_health
		bullet_resource.pierce -= 1
		bullet_resource.source_tower.add_damage_dealt(current_health)
		drop_loot()
		regrow_parent_resources.push_back(enemy_resource)
		enemy_resource = enemy_resource.child_resources[0]
		init_resource()
		
		if is_immune(bullet_resource):
			return
	
	bullet_resource.source_tower.add_damage_dealt(min(bullet_resource.attack_damage, current_health))
		
	if current_health <= bullet_resource.attack_damage:
		bullet_resource.attack_damage -= current_health
		bullet_resource.pierce -= 1
		current_health = 0
		spawn_children(bullet_resource)
	else:
		current_health -= bullet_resource.attack_damage
		
		if enemy_resource.can_regrow and regrow_parent_resources.size() > 0:
			regrow_timer.start()
	
#Godot 4.2.1 has still bugs duplicating nested resources
func duplicate_bullet_resource(bullet_resource : BulletResource):
	var new_bullet_resource = BulletResource.new()
	
	new_bullet_resource.attack_damage = bullet_resource.attack_damage
	new_bullet_resource.pierce = bullet_resource.pierce
	new_bullet_resource.source_tower = bullet_resource.source_tower
	new_bullet_resource.effects = bullet_resource.effects
	new_bullet_resource.damage_type = bullet_resource.damage_type
	new_bullet_resource.ignores_damage_type_immunity = bullet_resource.ignores_damage_type_immunity
	new_bullet_resource.extra_damage_to_trojan = bullet_resource.extra_damage_to_trojan
	
	return new_bullet_resource

		
func is_immune(bullet_resource : BulletResource):

	var is_immune_due_to_light = enemy_resource.is_immune_to_light and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.LIGHT
	var is_immune_due_to_electricity = enemy_resource.is_immune_to_electricity and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.ELECTRICITY
	var is_immune_due_to_magnetism = enemy_resource.is_immune_to_magnetism and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.MAGNETISM
	
	var is_immune_due_to_damage_type = is_immune_due_to_light or is_immune_due_to_electricity or is_immune_due_to_magnetism
	var is_immune_final = is_immune_due_to_damage_type and not bullet_resource.ignores_damage_type_immunity
	
	for enemy_effect in bullet_resource.effects:
		if enemy_effect is SlowEffectResource and enemy_resource.is_immunte_to_slow:
			is_immune_final = true
			
	return is_immune_final
	
func spawn_children(bullet_resource : BulletResource):
	if enemy_resource.child_quantities.size() == 0:
		die()
	elif enemy_resource.child_quantities.size() == 1 and enemy_resource.child_quantities[0] == 1:
		drop_loot()
		regrow_parent_resources.push_back(enemy_resource)
		enemy_resource = enemy_resource.child_resources[0]
		init_resource()
	else:	
		var children_counter = 0
		regrow_parent_resources.push_back(enemy_resource)
		
		for child_type_index in range(enemy_resource.child_resources.size()):
			for enemy_child_index in range(enemy_resource.child_quantities[child_type_index]):
				var enemy_instance := enemy_scene.instantiate() as Enemy
				enemy_instance.enemy_resource  = enemy_resource.child_resources[child_type_index]
				enemy_instance.regrow_parent_resources = regrow_parent_resources.duplicate()
				get_parent().add_child(enemy_instance)
				enemy_instance.progress_ratio = progress_ratio
				enemy_instance.progress -= children_counter * child_spawn_displacement
				if not enemy_resource.is_immune_to_pierce and bullet_resource.pierce >= 1:
					enemy_instance.take_damage(duplicate_bullet_resource(bullet_resource))
				children_counter += 1
		die()
	
func die():
	drop_loot()
	queue_free()
	
func drop_loot():
	GameManager.money += enemy_resource.money_on_death
	
func init_resource():
	base_animated_sprite.sprite_frames = enemy_resource.base_sprite_frames
	base_animated_sprite.play("move")
	
	camo_sprite.texture = enemy_resource.camo_texture
	fortified_sprite.texture = enemy_resource.fortified_texture
	regrow_sprite.texture = enemy_resource.regrow_texture
	
	current_health = enemy_resource.base_health
	# double hp if fortified
	if enemy_resource.is_fortified:
		current_health *= 2
	
	camo_sprite.visible = enemy_resource.is_camo
	fortified_sprite.visible = enemy_resource.is_fortified
	regrow_sprite.visible = enemy_resource.can_regrow
	
	regrow_timer.stop()
	
	if enemy_resource.can_regrow and regrow_parent_resources.size() > 0:
		regrow_timer.start()
	
	call_deferred("deferred_init_resource")

func deferred_init_resource():
	col_shape.shape = enemy_resource.col_shape

#heal up to the original layer if not taking damage
func _on_regrow_timer_timeout():
	var parent_resource = regrow_parent_resources.pop_back()
	if parent_resource != null:
		enemy_resource = parent_resource
		init_resource()
