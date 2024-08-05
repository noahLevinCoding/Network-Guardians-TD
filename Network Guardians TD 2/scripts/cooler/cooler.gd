extends Node2D

@export var cooler_resource : CoolerResource
@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

func _ready():
	init_resource()
	
func init_resource():
	sprite.texture = cooler_resource.texture
	col_shape.shape = cooler_resource.col_shape
