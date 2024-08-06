class_name Cooler
extends Node2D

@export var cooler_resource : CoolerResource
@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

func _ready():
	init_resource()
	GameManager.cooler = self
		
func init_resource():
	sprite.texture = cooler_resource.texture
	col_shape.shape = cooler_resource.col_shape

func upgrade():
	if cooler_resource.upgrade_cooler_resource != null:
		cooler_resource = cooler_resource.upgrade_cooler_resource
		init_resource()


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		SignalManager.select_cooler.emit()
