class_name BulletResource
extends Resource

var attack_damage : float
var ignores_damage_type_immunity : bool
var texture : Texture2D
var speed : float
var target : Enemy
var bullet_visual_resource : BulletVisualResource
var pierce : int
var source_tower : Tower
var effects : Array[EffectResource]
var bullet_effect : BulletEffect
var damage_type : TowerResource.DAMAGE_TYPE

