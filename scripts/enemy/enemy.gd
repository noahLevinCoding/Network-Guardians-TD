class_name Enemy
extends PathFollow2D

@export var default_speed : float = 200
@export var damage : int = 1
@export var max_health : float = 1

@export_group("Children")
@export var children : Array[ChildEnemyResource]
@export var children_spawn_delay : float = 0.05



var current_health : float = max_health
var slow_multiplier : float = 1.0
var current_speed : float = default_speed

var effects : Array[Effect] = []

func _process(delta):
	reset_effect_parameters()
	apply_effects(delta)
	calculate_speed()
	
	progress += current_speed * delta
	
	if progress_ratio == 1:
		reached_end()
	
	###debug
	if Input.is_action_just_pressed("ui_accept"):
		instantiate_children()
		queue_free()
	#####################		
	

func instantiate_children():
	var total_children_count = 0
	var children_counter = 0
	
	for enemy in children:
		total_children_count += enemy.child_enemy_count
	
	for enemy in children:
		if enemy.child_enemy_count and enemy.child_enemy_path:
			var scene = load(enemy.child_enemy_path)
			if scene:
				for enemy_index in range(enemy.child_enemy_count):
					var instance = scene.instantiate()
					get_parent().add_child(instance)
					instance.progress_ratio = progress_ratio
					instance.effects.append(SlowEffect.new(children_counter * children_spawn_delay, 0))
					instance.z_index = total_children_count - children_counter
					children_counter += 1
					

func reached_end():
	EventManager.enemy_reached_goal.emit(self)
	queue_free()
	
func apply_effects(delta : float):
	for effect in effects:
		effect.apply_effect(self)
		effect.duration -= delta
		if effect.duration <= 0:
			effects.erase(effect)

func calculate_speed():
	current_speed = default_speed * slow_multiplier

func reset_effect_parameters():
	slow_multiplier = 1.0
