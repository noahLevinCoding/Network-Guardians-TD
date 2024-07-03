class_name BulletResource
extends Resource

@export var texture : Texture2D
@export var speed : float
@export var col_shape : Shape2D

var can_pop_lead : bool = false
var attack_damage : float = 0
var target : Enemy = null
