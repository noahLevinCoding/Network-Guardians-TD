class_name Effect

enum EFFECT_TYPE {SLOW, CAMO_VISION, STAT_INCREASE}

var effect_resource : EffectResource
var source : Tower

func _init(effect_resource : EffectResource, source : Tower):
	self.effect_resource = effect_resource.duplicate()
	self.source = source
	
func apply_effect(object, delta):
	match effect_resource.effect_type:
		EFFECT_TYPE.SLOW:
			apply_slow_effect(object, delta)
			
		EFFECT_TYPE.CAMO_VISION:
			apply_camo_vision_effect(object)
	
		EFFECT_TYPE.STAT_INCREASE:
			apply_stat_increase_effect(object)
		
		

func apply_slow_effect(enemy, delta):
	if enemy.slow_multiplier > effect_resource.slow_multiplier:
		enemy.slow_multiplier = effect_resource.slow_multiplier
		
	decrease_duration(enemy, delta)

func apply_camo_vision_effect(tower):
	tower.has_camo_vision_effect = true
	

func apply_stat_increase_effect(tower):
	match effect_resource.stat_type:
		StatIncreaseEffectResource.STAT_TYPE.ATTACK_DAMAGE:
			if effect_resource.is_additive:
				tower.attack_damage_additive = max(tower.attack_damage_additive, effect_resource.summand) 
			if effect_resource.is_multiplicative:
				tower.attack_damage_multiplicative = max(tower.attack_damage_multiplicative, effect_resource.factor) 
		
		StatIncreaseEffectResource.STAT_TYPE.ATTACK_SPEED:
			if effect_resource.is_additive:
				tower.attack_speed_additive = max(tower.attack_speed_additive, effect_resource.summand) 
			if effect_resource.is_multiplicative:
				tower.attack_speed_multiplicative = max(tower.attack_speed_multiplicative, effect_resource.factor) 
			
		StatIncreaseEffectResource.STAT_TYPE.ATTACK_RANGE:
			if effect_resource.is_additive:
				tower.attack_range_additive = max(tower.attack_range_additive, effect_resource.summand) 
			if effect_resource.is_multiplicative:
				tower.attack_range_multiplicative = max(tower.attack_range_multiplicative, effect_resource.factor) 
			
			
		StatIncreaseEffectResource.STAT_TYPE.PIERCE:
			if effect_resource.is_additive:
				tower.pierce_additive = max(tower.pierce_additive, effect_resource.summand) 
			if effect_resource.is_multiplicative:
				tower.pierce_multiplicative = max(tower.pierce_multiplicative, effect_resource.factor) 


func decrease_duration(object, delta):
	effect_resource.duration -= delta
	
	if effect_resource.duration <= 0:
		object.end_of_effect(self)
		
