extends VBoxContainer

@export var shop_node : Shop
@export var tower_name_label : Label
@export var prio_option_button : OptionButton
@export var damage_dealt_label : Label

var selected_tower : Tower

func _ready():
	SignalManager.select_tower_on_board.connect(_on_select_tower)
	SignalManager.deselect_tower_on_board.connect(_on_deselect_tower)
	SignalManager.reset_game.connect(_on_reset_game)
	SignalManager.selected_tower_damage_dealt_changed.connect(_on_damage_dealt_changed)
	
func _on_reset_game():
	_on_deselect_tower()	
	
func _on_select_tower(tower : Tower):
	_on_deselect_tower()
	
	if tower == null:
		return
	
	selected_tower = tower
	visible = true
	shop_node.visible = false
	selected_tower.enable_select_shader()
	
	tower_name_label.text = selected_tower.tower_resource.name
	prio_option_button.select(selected_tower.tower_resource.target_prio_type)
	damage_dealt_label.text = str(selected_tower.damage_dealt)
	

func _on_deselect_tower():
	visible = false
	shop_node.visible = true
	if selected_tower != null:
		selected_tower.disable_select_shader()
	selected_tower = null
	
	
func _on_damage_dealt_changed():
	damage_dealt_label.text = str(selected_tower.damage_dealt)
	
func _on_deselect_button_up():
	_on_deselect_tower()


func _on_upper_upgrade_button_button_up():
	GameManager.upgrade_tower(selected_tower, 1)


func _on_lower_upgrade_button_up():
	GameManager.upgrade_tower(selected_tower, 2)


func _on_prioritization_dropdown_item_selected(index):
	selected_tower.tower_resource.target_prio_type = index
