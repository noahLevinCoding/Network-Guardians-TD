class_name Tower
extends Node2D

const ENEMY_LAYER_NORMAL = 16
const ENEMY_LAYER_CAMO = 32
const ENEMY_LAYER_LEAD = 64
const ENEMY_LAYER_CAMO_LEAD = 128

var enemies = []

func _on_area_2d_area_entered(area):
	if(area.collision_layer == ENEMY_LAYER_MASK):
	


func _on_area_2d_area_exited(area):
	if(area.collision_layer == ENEMY_LAYER_MASK):
		print("Enemy exited")
	
