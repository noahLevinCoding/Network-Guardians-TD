class_name MapSelection
extends Node2D

signal set_map(map_scene_path : String)
signal back

func _ready():
	visible = false

func _on_map_1_button_up():
	set_map.emit("res://scenes/maps/map_1.tscn", 1)


func _on_map_2_button_up():
	set_map.emit("res://scenes/maps/map_2.tscn", 2)


func _on_map_3_button_up():
	set_map.emit("res://scenes/maps/map_3.tscn", 3)


func _on_back_button_up():
	back.emit()
	
