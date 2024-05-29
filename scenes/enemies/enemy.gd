class_name Enemy
extends PathFollow2D

func _process(delta):
	progress += 400 * delta
	
	if progress_ratio == 1:
		queue_free()
		EventManager.take_damage.emit()
