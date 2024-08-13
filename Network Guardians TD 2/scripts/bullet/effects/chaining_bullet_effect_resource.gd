class_name ChainingBulletEffectResource
extends BulletEffectResource

var effect_type : BulletEffect.EFFECT_TYPE = BulletEffect.EFFECT_TYPE.CHAINING

@export var radius : float
@export var number_of_targets : int = 1

var enemy
var enemies_visited = []
var line : Line2D
