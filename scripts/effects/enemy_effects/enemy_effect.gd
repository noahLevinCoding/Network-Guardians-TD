class_name EnemyEffect

enum EFFECT_TYPE {SLOW, KNOCKBACK}

var effect_resource : EnemyEffectResource

func _init(_effect_resource : EnemyEffectResource, source_tower : Tower):
	self.effect_resource = _effect_resource.duplicate()
	
	match effect_resource.effect_type:
		EFFECT_TYPE.SLOW:
			init_slow_effect(source_tower)
		EFFECT_TYPE.KNOCKBACK:
			init_knockback_effect()
	
func init_slow_effect(source_tower : Tower):
	source_tower.show_range(0.15, Color(0,0,1,0.2))
	
func init_knockback_effect():
	pass
	
	
func apply_effect(enemy, delta):
	match effect_resource.effect_type:
		EFFECT_TYPE.SLOW:
			apply_slow_effect(enemy, delta)
		EFFECT_TYPE.KNOCKBACK:
			apply_knockback_effect(enemy, delta)
		
		
		

func apply_slow_effect(enemy, delta):
	enemy.slow_multiplier = max(enemy.slow_multiplier, effect_resource.slow_multiplier)	
		
	decrease_duration(enemy, delta)

func apply_knockback_effect(enemy, delta):
	enemy.knockback_speed = max(enemy.knockback_speed, effect_resource.speed)
	enemy.is_knockbacked = true
	
	decrease_duration(enemy, delta)


func decrease_duration(enemy, delta):
	effect_resource.duration -= delta
	
	if effect_resource.duration <= 0:
		enemy.end_of_effect(self)
		
