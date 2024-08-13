class_name StatIncreaseEffectResource
extends TowerEffectResource

var effect_type : TowerEffect.EFFECT_TYPE = TowerEffect.EFFECT_TYPE.STAT_INCREASE

enum STAT_TYPE {ATTACK_DAMAGE, ATTACK_SPEED, ATTACK_RANGE, PIERCE}

@export var stat_type : STAT_TYPE

@export var is_additive : bool = false
@export var is_multiplicative : bool = false

@export var summand : float = 0
@export var factor : float = 1.0
