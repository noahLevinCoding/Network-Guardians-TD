class_name Bullet
extends Node2D

var target = null

var speed = 1500

func _process(delta):
	if target != null:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		queue_free()


func _on_area_2d_area_entered(area):
	if area.owner == target:
		queue_free()
		target.die()
