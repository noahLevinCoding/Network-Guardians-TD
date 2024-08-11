class_name Tower
extends Node2D

var tower_resource : TowerResource	
var select_shader_color : Color = Color(1,1,1,1)

var sell_value : int

var buffs : Array[Effect]

var has_camo_vision_effect : bool = false

var attack_damage_additive : float = 0
var attack_damage_multiplicative : float = 1.0
var attack_speed_additive : float = 0 :
	set(value):
		if attack_speed_additive != value:
			attack_speed_additive = value
			init_attack_speed()
			
var attack_speed_multiplicative : float = 1.0 :
	set(value):
		if attack_speed_multiplicative != value:
			attack_speed_multiplicative = value
			init_attack_speed()
var attack_range_additive : float = 0 : 
	set(value):
		if attack_range_additive != value:
			attack_range_additive = value
			init_attack_range()
var attack_range_multiplicative : float = 1.0 :
	set(value):
		if attack_range_multiplicative != value:
			attack_range_multiplicative = value
			init_attack_range()
var pierce_additive : float = 0 
var pierce_multiplicative : float = 1.0

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

func reset_buff_parameters():
	has_camo_vision_effect = false
	
	attack_damage_additive = 0
	attack_damage_multiplicative = 1.0
	attack_speed_additive = 0
	attack_speed_multiplicative = 1.0
	attack_range_additive = 0
	attack_range_multiplicative = 1.0
	pierce_additive = 0
	pierce_multiplicative = 1.0

func apply_buff_parameters():
	for buff in buffs:
		buff.apply_effect(self, 0)


func init_attack_speed():
	pass
	
func init_attack_range():
	pass
