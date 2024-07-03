class_name Enemy
extends PathFollow2D

@export var sprite_2d : Sprite2D
@export var collision_shape : CollisionShape2D

var enemy_resource : EnemyResource 
		
func _ready():
	sprite_2d.texture = enemy_resource.texture
	collision_shape.shape = enemy_resource.col_shape


func _process(delta):
	progress += enemy_resource.base_speed * delta
	
	if progress_ratio >= 1.0:
		GameManager.deal_damage_to_player(enemy_resource.damage_to_player)
		self.queue_free()
