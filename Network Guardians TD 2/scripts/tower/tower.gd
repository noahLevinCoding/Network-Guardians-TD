class_name Tower
extends Node2D

var tower_resource : TowerResource	
var select_shader_color : Color = Color(1,1,1,1)

var sell_value : int

func upgrade(path : int, price : int):
	if path == 1:
		tower_resource = tower_resource.upgrade_path_1_tower_resource
		init_resource()
	elif path == 2:
		tower_resource = tower_resource.upgrade_path_2_tower_resource
		init_resource()
		
	sell_value += price / 2
		
func init_resource():
	pass
