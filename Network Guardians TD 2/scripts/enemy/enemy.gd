class_name Enemy
extends PathFollow2D

@export var base_animated_sprite : AnimatedSprite2D
@export var camo_sprite : Sprite2D
@export var lead_sprite : Sprite2D
@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource
@export var base_speed_multiplier : float = 100

@export var child_spawn_delay : float = 0.05

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
		effect.apply_effect(self)
		effect.duration -= delta
		if effect.duration <= 0:
			effects.erase(effect)

func calc_current_speed():
	current_speed = enemy_resource.base_speed * GameManager.temperature_speed_modifier * slow_multiplier
	
func move(delta : float):
	progress += current_speed * delta * base_speed_multiplier
	
func check_if_end():
	if progress_ratio >= 1:
		var damage_to_player = calc_damage_to_player(enemy_resource)
		GameManager.deal_damage_to_player(damage_to_player)
		
		queue_free()
		
func calc_damage_to_player(child_enemy_resource : EnemyResource):
	if child_enemy_resource.child_quantity == 0:
		return 1
	else:
		var quantity = enemy_resource.child_quantity
		return  1 + quantity * calc_damage_to_player(child_enemy_resource.child_resource)
		
func take_damage(bullet_resource : BulletResource):
	
	#Check lead
	if enemy_resource.is_lead and not bullet_resource.can_pop_lead:
		return
	
	#TODO damage multiplier
	
	#Apply pierce
	while bullet_resource.attack_damage > current_health and enemy_resource.child_quantity == 1 and bullet_resource.pierce > 1 and not enemy_resource.is_immune_to_pierce:
		bullet_resource.attack_damage -= current_health
		bullet_resource.pierce -= 1
		bullet_resource.source_tower.add_damage_dealt(current_health)
		drop_loot()
		enemy_resource = enemy_resource.child_resource
		init_resource()
		
	bullet_resource.source_tower.add_damage_dealt(min(bullet_resource.attack_damage, current_health))
	current_health -= bullet_resource.attack_damage
	
	if current_health <= 0: 
		spawn_children()
		
func spawn_children():
	if enemy_resource.child_quantity == 0:
		die()
	elif enemy_resource.child_quantity == 1:
		drop_loot()
		enemy_resource = enemy_resource.child_resource
		init_resource()
	else:
		for enemy_child_index in range(enemy_resource.child_quantity):
			var enemy_instance := enemy_scene.instantiate() as Enemy
			enemy_instance.enemy_resource  = enemy_resource.child_resource
			get_parent().add_child(enemy_instance)
			enemy_instance.progress_ratio = progress_ratio
			enemy_instance.effects.append(SlowEffect.new((enemy_resource.child_quantity - enemy_child_index) * child_spawn_delay, 0))
			#enemy_instance.z_index = enemy_resource.child_quantity - enemy_child_index
			
			
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
	lead_sprite.texture = enemy_resource.lead_texture
	col_shape.shape = enemy_resource.col_shape
	
	current_health = enemy_resource.base_health
	
	#TODO: Adjust when adding effects
	camo_sprite.visible = enemy_resource.is_camo
	lead_sprite.visible = enemy_resource.is_lead
