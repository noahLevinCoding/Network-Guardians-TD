class_name Bullet
extends Node2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

#for effects like explosion and lightning
@export var effect_col_shape : CollisionShape2D
@export var effect_area : Area2D

var bullet_resource : BulletResource 

func _ready():
	call_deferred("init")

	
func init():
	sprite.texture = bullet_resource.bullet_visual_resource.texture
	col_shape.shape = bullet_resource.bullet_visual_resource.col_shape
	
	if bullet_resource.bullet_effect != null:
		bullet_resource.bullet_effect.init_effect(self)
		
	if bullet_resource.target != null:
		var direction = (bullet_resource.target.global_position - global_position).normalized()
		if direction.length() > 0:
			var angle = atan2(direction.y, direction.x)
			rotation = angle + PI / 2
	
func _physics_process(delta):
	if bullet_resource.target != null:
		var direction = (bullet_resource.target.global_position - global_position).normalized()
		var step = direction * bullet_resource.speed * delta
		
		if step.length() > bullet_resource.target.global_position.distance_to(global_position):
			global_position = bullet_resource.target.global_position
		else:
			global_position += step
			
		#calculate one step ahead, otherwise the bullet is not centered when hitting
		if step.length() > bullet_resource.target.global_position.distance_to(global_position):
			global_position = bullet_resource.target.global_position	
		
	
		if direction.length() > 0:
			var angle = atan2(direction.y, direction.x)
			rotation = angle + PI / 2
	else:
		bullet_resource.bullet_effect.end_effect(self)
		queue_free()

func _on_area_2d_area_entered(area):
	if area.owner == bullet_resource.target:
		if bullet_resource.bullet_effect != null:
			bullet_resource.bullet_effect.apply_effect(self, area.owner)
		
		area.owner.take_damage(bullet_resource)
	
		#bullet effects can change their target
		if area.owner == bullet_resource.target:
			queue_free()


	
