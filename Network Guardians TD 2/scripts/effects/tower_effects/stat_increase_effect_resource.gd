class_name StatIncreaseEffectResource
extends EffectResource

var effect_type : Effect.EFFECT_TYPE = Effect.EFFECT_TYPE.STAT_INCREASE

enum STAT_TYPE {ATTACK_DAMAGE, ATTACK_SPEED, ATTACK_RANGE, PIERCE}

@export var stat_type : STAT_TYPE

@export var is_additive : bool = false
@export var is_multiplicative : bool = false

@export var summand : float = 0
@export var factor : float = 1.0
