extends Node2D

@export var path : Path2D
@export var enemy_scene : PackedScene

@export var enemy_resource_1 : EnemyResource
@export var enemy_resource_2 : EnemyResource
@export var enemy_resource_3 : EnemyResource
#@export var enemy_resource_4 : EnemyResource
#@export var enemy_resource_5 : EnemyResource


func _process(delta):
	if Input.is_action_just_pressed("one"):
		var enemy_scene_instance = enemy_scene.instantiate()
		enemy_scene_instance.enemy_resource = enemy_resource_1
		path.add_child(enemy_scene_instance)
	elif Input.is_action_just_pressed("two"):
		var enemy_scene_instance = enemy_scene.instantiate()
		enemy_scene_instance.enemy_resource = enemy_resource_2
		path.add_child(enemy_scene_instance)
	elif Input.is_action_just_pressed("three"):
		var enemy_scene_instance = enemy_scene.instantiate()
		enemy_scene_instance.enemy_resource = enemy_resource_3
		path.add_child(enemy_scene_instance)
	#elif Input.is_action_just_pressed("four"):
		#var enemy_scene_instance = enemy_scene.instantiate()
		#enemy_scene_instance.enemy_resource = enemy_resource_4
		#path.add_child(enemy_scene_instance)
	#elif Input.is_action_just_pressed("five"):
		#var enemy_scene_instance = enemy_scene.instantiate()
		#enemy_scene_instance.enemy_resource = enemy_resource_5
		#path.add_child(enemy_scene_instance)
