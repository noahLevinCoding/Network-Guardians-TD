class_name Effect

enum EFFECT_TYPE {SLOW}

var effect_resource : EffectResource

func _init(effect_resource : EffectResource):
	self.effect_resource = effect_resource.duplicate()
	
func apply_effect(object, delta):
	match effect_resource.effect_type:
		EFFECT_TYPE.SLOW:
			apply_slow_effect(object, delta)
		
		

func apply_slow_effect(enemy, delta):
	if enemy.slow_multiplier > effect_resource.slow_multiplier:
		enemy.slow_multiplier = effect_resource.slow_multiplier
		
	decrease_duration(enemy, delta)


func decrease_duration(object, delta):
	effect_resource.duration -= delta
	
	if effect_resource.duration <= 0:
		object.end_of_effect(self)
		
