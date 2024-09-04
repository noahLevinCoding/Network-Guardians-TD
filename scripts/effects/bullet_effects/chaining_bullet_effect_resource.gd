class_name ChainingBulletEffectResource
extends BulletEffectResource

var effect_type : BulletEffect.EFFECT_TYPE = BulletEffect.EFFECT_TYPE.CHAINING

@export var radius : float
@export var number_of_targets : int = 1

var enemy
var enemies_visited = []
var line_1 : Line2D
var line_2 : Line2D
var line_3 : Line2D
var line_4 : Line2D
var line_5 : Line2D
var line_6 : Line2D
