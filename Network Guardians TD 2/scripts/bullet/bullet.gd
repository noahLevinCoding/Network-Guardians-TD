class_name Bullet
extends Node2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D
@export var effect_col_shape : CollisionShape2D

var bullet_resource : BulletResource 

var enemies_in_range = []


func _ready():
	call_deferred("init")

	
func init():
	sprite.texture = bullet_resource.bullet_visual_resource.texture
	col_shape.shape = bullet_resource.bullet_visual_resource.col_shape
	
	if bullet_resource.bullet_effect != null:
		bullet_resource.bullet_effect.init_effect(self)
	
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
		if bullet_resource.bullet_effect != null:
			bullet_resource.bullet_effect.apply_effect(self, area.owner)
		area.owner.take_damage(bullet_resource)
		queue_free()


		


func _on_effect_area_entered(area):
	if area.owner is Enemy:
		enemies_in_range.append(area.owner)


func _on_effect_area_exited(area):
	if area.owner is Enemy:
		enemies_in_range.erase(area.owner)
