class_name Enemy
extends PathFollow2D

@export var base_sprite : Sprite2D
@export var camo_sprite : Sprite2D
@export var lead_sprite : Sprite2D
@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource

var enemy_scene : PackedScene = load("res://scenes/enemy/enemy.tscn")

var current_health : float
var current_speed : float

func _ready():
	init_resource()

func _process(delta):
	move(delta)
	check_if_end()
	
func move(delta : float):
	progress += current_speed * delta
	
func check_if_end():
	if progress_ratio >= 1:
		#TODO lose hp
		queue_free()
		
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
	base_sprite.texture = enemy_resource.base_texture
	camo_sprite.texture = enemy_resource.camo_texture
	lead_sprite.texture = enemy_resource.lead_texture
	col_shape.shape = enemy_resource.col_shape
	
	current_health = enemy_resource.base_health
	current_speed = enemy_resource.base_speed
	
	#TODO: Adjust when adding effects
	camo_sprite.visible = enemy_resource.is_camo
	lead_sprite.visible = enemy_resource.is_lead
