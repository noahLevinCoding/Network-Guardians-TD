extends VBoxContainer

@export var shop_node : Shop

var selected_tower : Tower

func _ready():
	SignalManager.select_tower_on_board.connect(_on_select_tower)
	SignalManager.deselect_tower_on_board.connect(_on_deselect_tower)
	
func _on_select_tower(tower : Tower):
	if tower == null:
		return
	
	selected_tower = tower
	visible = true
	shop_node.visible = false

func _on_deselect_tower():
	visible = false
	shop_node.visible = true
	
	
func _on_deselect_button_up():
	_on_deselect_tower()


func _on_upper_upgrade_button_button_up():
	GameManager.upgrade_tower(selected_tower, 1)


func _on_lower_upgrade_button_up():
	GameManager.upgrade_tower(selected_tower, 2)
