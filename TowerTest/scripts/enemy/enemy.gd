class_name Enemy
extends PathFollow2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

@export var enemy_resource : EnemyResource

func _ready():
	sprite.texture = enemy_resource.texture
	col_shape.shape = enemy_resource.col_shape

func _process(delta):
	move(delta)
	check_if_end()
	
func move(delta : float):
	progress += enemy_resource.base_speed * delta
	
func check_if_end():
	if progress_ratio >= 1:
		queue_free()
	
