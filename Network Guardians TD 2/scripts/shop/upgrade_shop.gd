extends VBoxContainer

@export var shop_node : Shop

func _ready():
	SignalManager.select_tower_on_board.connect(_on_select_tower)
	SignalManager.deselect_tower_on_board.connect(_on_deselect_tower)
	
func _on_select_tower(tower_resource : TowerResource):
	if tower_resource == null:
		return
	
	visible = true
	shop_node.visible = false

func _on_deselect_tower():
	visible = false
	shop_node.visible = true
