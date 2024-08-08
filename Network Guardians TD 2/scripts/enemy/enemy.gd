class_name Enemy
extends PathFollow2D

@export var base_animated_sprite : AnimatedSprite2D
@export var camo_sprite : Sprite2D

@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource
@export var base_speed_multiplier : float = 100

@export var child_spawn_displacement : float = 10

var enemy_scene : PackedScene = load("res://scenes/enemy/enemy.tscn")

var current_health : float
var current_speed : float

var effects : Array[Effect] = []
var slow_multiplier : float = 1.0

func _ready():
	init_resource()
	
func _process(delta):
	reset_effect_parameters()
	apply_effects(delta)
	calc_current_speed()
	move(delta)
	check_if_end()
	
func reset_effect_parameters():
		slow_multiplier = 1.0

func apply_effects(delta):
	for effect in effects:
		effect.apply_effect(self, delta)
			
func end_of_effect(effect : Effect):
	effects.erase(effect)

func calc_current_speed():
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
	print("B")

	
	for effect_resource in bullet_resource.effects:
		effects.append(Effect.new(effect_resource))
	
	if is_immune(bullet_resource):
		return
	
	#TODO damage multiplier
	
	#Apply pierce
	while bullet_resource.attack_damage > current_health and enemy_resource.child_quantities.size() == 1 and enemy_resource.child_quantities[0] == 1 and  bullet_resource.pierce > 1 and not enemy_resource.is_immune_to_pierce:
		bullet_resource.attack_damage -= current_health
		bullet_resource.pierce -= 1
		bullet_resource.source_tower.add_damage_dealt(current_health)
		drop_loot()
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
	

func duplicate_bullet_resource(bullet_resource : BulletResource):
	var new_bullet_resource = BulletResource.new()
	
	new_bullet_resource.attack_damage = bullet_resource.attack_damage
	new_bullet_resource.pierce = bullet_resource.pierce
	new_bullet_resource.source_tower = bullet_resource.source_tower
	new_bullet_resource.effects = bullet_resource.effects
	new_bullet_resource.damage_type = bullet_resource.damage_type
	new_bullet_resource.ignores_damage_type_immunity = bullet_resource.ignores_damage_type_immunity
	
	return new_bullet_resource

		
func is_immune(bullet_resource : BulletResource):
	return enemy_resource.is_immune_to_light and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.LIGHT and not bullet_resource.ignoes_damage_type_immunity or enemy_resource.is_immune_to_electricity and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.ELECTRICITY  and not bullet_resource.ignoes_damage_type_immunity or enemy_resource.is_immune_to_magnetism and bullet_resource.damage_type == TowerResource.DAMAGE_TYPE.MAGNETISM and not bullet_resource.ignoes_damage_type_immunity

	
func spawn_children(bullet_resource : BulletResource):
	if enemy_resource.child_quantities.size() == 0:
		die()
	elif enemy_resource.child_quantities.size() == 1 and enemy_resource.child_quantities[0] == 1:
		drop_loot()
		enemy_resource = enemy_resource.child_resources[0]
		init_resource()
	else:	
		var children_counter = 0
		
		for child_type_index in range(enemy_resource.child_resources.size()):
			for enemy_child_index in range(enemy_resource.child_quantities[child_type_index]):
				var enemy_instance := enemy_scene.instantiate() as Enemy
				enemy_instance.enemy_resource  = enemy_resource.child_resources[child_type_index]
				get_parent().add_child(enemy_instance)
				enemy_instance.progress_ratio = progress_ratio
				enemy_instance.progress -= children_counter * child_spawn_displacement
				if not enemy_resource.is_immune_to_pierce and bullet_resource.pierce >= 1:
					print("A")
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
	col_shape.shape = enemy_resource.col_shape
	
	current_health = enemy_resource.base_health
	
	#TODO: Adjust when adding effects
	camo_sprite.visible = enemy_resource.is_camo

