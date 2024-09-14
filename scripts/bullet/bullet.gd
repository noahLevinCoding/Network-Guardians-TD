class_name Bullet
extends Node2D

@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

#for effects like explosion and lightning
@export var effect_col_shape : CollisionShape2D
@export var effect_area : Area2D
@export var hit_area : Area2D

var bullet_resource : BulletResource 
var target_progress = 0

var area_entered_already_called : bool = false
var last_target = null :
	set(value):
		last_target = value
		area_entered_already_called = false


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
	else:
		if bullet_resource.bullet_effect != null:
			bullet_resource.bullet_effect.end_effect(self)
		queue_free()
	
func _physics_process(delta):
	if bullet_resource.target != last_target:
		last_target = bullet_resource.target
	
	if bullet_resource.target != null:
		target_progress = bullet_resource.target.progress
		
		for area in hit_area.get_overlapping_areas():
			if area.owner == bullet_resource.target:
				#if bullet_resource.bullet_effect != null:
					#bullet_resource.bullet_effect.apply_effect(self, area.owner)
				_on_area_2d_area_entered(area)
				return
		
		var direction = (bullet_resource.target.global_position - global_position).normalized()
		var step = direction * bullet_resource.speed * delta
		
		if step.length() > bullet_resource.target.global_position.distance_to(global_position):
			global_position = bullet_resource.target.global_position
		else:
			global_position += step
			
		if direction.length() > 0:
			var angle = atan2(direction.y, direction.x)
			rotation = angle + PI / 2
	else:
		if bullet_resource.bullet_effect != null:
			if bullet_resource.bullet_effect.can_terminate_effect(self):
				bullet_resource.bullet_effect.end_effect(self)
				queue_free()
		else:
			queue_free()


func _on_area_2d_area_entered(area):
	
	if area.owner == bullet_resource.target and not area_entered_already_called:
		area_entered_already_called = true
		
		global_position = bullet_resource.target.global_position
		
		if bullet_resource.bullet_effect != null:
			bullet_resource.bullet_effect.apply_effect(self, area.owner)
		
		var is_still_target = area.owner == bullet_resource.target
		
		area.owner.take_damage(bullet_resource)
	
		#bullet effects can change their target
		if is_still_target or bullet_resource.target == null:
			queue_free()


	
