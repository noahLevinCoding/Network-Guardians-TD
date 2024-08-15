class_name PowerSupply
extends Node2D

@export var power_supply_resource : PowerSupplyResource
@export var sprite : Sprite2D
@export var col_shape : CollisionShape2D

var is_selected : bool = false :
	set(value):
		is_selected = value
		sprite.material.set_shader_parameter("line_color", Color(1,1,1,1) if is_selected else Color(0,0,0,0))
		

func _ready():
	init_resource()
	GameManager.power_supply = self
	
func init_resource():
	sprite.texture = power_supply_resource.texture
	col_shape.shape = power_supply_resource.col_shape

func upgrade():
	if power_supply_resource.upgrade_power_supply_resource != null:
		power_supply_resource = power_supply_resource.upgrade_power_supply_resource
		init_resource()


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		SignalManager.select_power_supply.emit()
