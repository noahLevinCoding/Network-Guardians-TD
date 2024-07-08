extends Node

var difficulty : int = 2
var money : int = 1000 :
	set(value):
		money = value
		SignalManager.money_has_changed.emit()
		
var tower_scene : PackedScene = preload("res://scenes/tower/tower.tscn")


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		money = money


func place_tower(tower_resource : TowerResource, price : int, position):
	print(tower_resource, price, position)
	money -= price
	
	var tower_instance = tower_scene.instantiate() as Tower
	tower_instance.tower_resource = tower_resource
	
	add_child(tower_instance)
	tower_instance.position = position
	
