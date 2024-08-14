class_name EnemyEffect

enum EFFECT_TYPE {SLOW, KNOCKBACK}

var effect_resource : EnemyEffectResource

func _init(effect_resource : EnemyEffectResource):
	self.effect_resource = effect_resource.duplicate()
	
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
		
