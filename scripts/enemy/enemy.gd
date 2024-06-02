class_name Enemy
extends PathFollow2D

@export var speed : float = 200
@export var damage : int = 1
@export var max_health : float = 1

@export var children : Array[ChildEnemyResource]

var current_health : float = max_health

func _process(delta):
	progress += speed * delta
	
	if progress_ratio == 1:
		reached_end()
	
	###debug
	if Input.is_action_just_pressed("ui_accept"):
		current_health -= 1
		if current_health <= 0:
			instantiate_scenes()
			queue_free()
			
	

func instantiate_scenes():
	for enemy in children:
		if enemy.child_enemy_count and enemy.child_enemy_path:
			var scene = load(enemy.child_enemy_path)
			if scene:
				for i in range(enemy.child_enemy_count):
					var instance = scene.instantiate()
					get_parent().add_child(instance)
					instance.progress_ratio = progress_ratio
			else:
				print("Failed to load scene at path: ", enemy.child_enemy_path)
		else:
			print("Invalid scene path or pair data")
#####################

func reached_end():
	EventManager.enemy_reached_goal.emit(self)
	queue_free()
	
