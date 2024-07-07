class_name Enemy
extends PathFollow2D

@export var base_animated_sprite : AnimatedSprite2D
@export var camo_sprite : Sprite2D
@export var lead_sprite : Sprite2D
@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource
@export var base_speed_multiplier : float = 100

var enemy_scene : PackedScene = load("res://scenes/enemy/enemy.tscn")

var current_health : float
var current_speed : float

func _ready():
	init_resource()

func _process(delta):
	move(delta)
	check_if_end()
	
func move(delta : float):
	progress += current_speed * delta * base_speed_multiplier
	
func check_if_end():
	if progress_ratio >= 1:
		var damage_to_player = calc_damage_to_player(enemy_resource)
		GameManager.deal_damage_to_player(damage_to_player)
		
		queue_free()
		
func calc_damage_to_player(enemy_resource : EnemyResource):
	if enemy_resource.children_quantity == 0:
		return 1
	else:
		var quantity = enemy_resource.children_quantity
		return  1 + quantity * calc_damage_to_player(enemy_resource.children_resource)
		
func take_damage(bullet_resource : BulletResource):
	
	#Check lead
	if enemy_resource.is_lead and not bullet_resource.can_pop_lead:
		return
	
	#TODO damage multiplier
	
	#Apply pierce
	while bullet_resource.attack_damage > current_health and enemy_resource.children_quantity == 1 and bullet_resource.pierce > 1 and not enemy_resource.is_immune_to_pierce:
		bullet_resource.attack_damage -= current_health
		bullet_resource.pierce -= 1
		enemy_resource = enemy_resource.children_resource
		init_resource()
		
	current_health -= bullet_resource.attack_damage
	
	if current_health <= 0: 
		spawn_children()
		
func spawn_children():
	if enemy_resource.children_quantity == 0:
		die()
	elif enemy_resource.children_quantity == 1:
		enemy_resource = enemy_resource.children_resource
		init_resource()
	else:
		for i in range(enemy_resource.children_quantity):
			var enemy_instance := enemy_scene.instantiate() as Enemy
			enemy_instance.enemy_resource  = enemy_resource.children_resource
			get_parent().add_child(enemy_instance)
			enemy_instance.progress_ratio = progress_ratio
			#TODO: set slow effect
			
		die()
	
func die():
	queue_free()
	
func init_resource():
	base_animated_sprite.sprite_frames = enemy_resource.base_sprite_frames
	base_animated_sprite.play("move")
	
	camo_sprite.texture = enemy_resource.camo_texture
	lead_sprite.texture = enemy_resource.lead_texture
	col_shape.shape = enemy_resource.col_shape
	
	current_health = enemy_resource.base_health
	current_speed = enemy_resource.base_speed
	
	#TODO: Adjust when adding effects
	camo_sprite.visible = enemy_resource.is_camo
	lead_sprite.visible = enemy_resource.is_lead
