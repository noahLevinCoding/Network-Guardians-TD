class_name Bullet
extends Node2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

var bullet_resource : BulletResource 

func _ready():
	sprite.texture = bullet_resource.bullet_visual_resource.texture
	col_shape.shape = bullet_resource.bullet_visual_resource.col_shape
	
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
		area.owner.take_damage(bullet_resource)
		#apply effects
		queue_free()
