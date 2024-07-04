class_name Bullet
extends Node2D

@export var bullet_resource : BulletResource
@export var sprite_2d : Sprite2D
@export var col_shape : CollisionShape2D


func _ready():
	sprite_2d.texture = bullet_resource.texture
	col_shape.shape = bullet_resource.col_shape
	
func _process(delta):
	if bullet_resource.target != null:
		var direction = (bullet_resource.target.global_position - global_position).normalized()
		global_position += direction * bullet_resource.speed * delta
		
		if direction.length() > 0:
			var angle = atan2(direction.y, direction.x)
			rotation = angle + PI / 2
	else:
		queue_free()

func _on_area_2d_area_entered(area):
	if area.owner == bullet_resource.target:
		area.owner.receive_damage(bullet_resource)
		queue_free()
		
