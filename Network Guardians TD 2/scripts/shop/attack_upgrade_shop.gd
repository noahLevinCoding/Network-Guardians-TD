extends VBoxContainer

@export var shop_node : Shop
@export var cooler_power_supply_upgrade_node : Node
@export var resource_upgrade_node : Node
@export var support_upgrade_node : Node

@export var tower_name_label : Label
@export var prio_option_button : OptionButton
@export var damage_dealt_label : Label
@export var upgrade_1_price : Label
@export var upgrade_2_price : Label
@export var upgrade_1_icon : TextureRect
@export var upgrade_2_icon : TextureRect
@export var upgrade_1 : HBoxContainer
@export var upgrade_2 : HBoxContainer
@export var sell_button : Button
@export var selected_temperature_label : Label
@export var selected_power_label : Label

var selected_tower : Tower

func _ready():
	SignalManager.select_attack_tower_on_board.connect(_on_select_tower)
	SignalManager.deselect_tower_on_board.connect(_on_deselect_tower)
	SignalManager.reset_game.connect(_on_reset_game)
	SignalManager.selected_tower_damage_dealt_changed.connect(_on_damage_dealt_changed)
	
func _on_reset_game():
	_on_deselect_tower()	
	
func _on_select_tower(tower : Tower):
	_on_deselect_tower()
	resource_upgrade_node._on_deselect_tower()
	support_upgrade_node._on_deselect_tower()
	cooler_power_supply_upgrade_node._on_deselect()
	
	if tower == null:
		return
	
	selected_tower = tower
	visible = true
	shop_node.visible = false
	cooler_power_supply_upgrade_node.visible = false
	resource_upgrade_node.visible = false
	selected_tower.is_selected = true
	support_upgrade_node.visible = false
	
	tower_name_label.text = selected_tower.tower_resource.name
	prio_option_button.select(selected_tower.target_prio_type)
	damage_dealt_label.text = str(selected_tower.damage_dealt)
	sell_button.text = "Sell: " + str(selected_tower.sell_value)
	selected_power_label.text = str(selected_tower.tower_resource.power) + " W"
	selected_temperature_label.text = "+ " + str(selected_tower.tower_resource.temperature_increase) + " °C"
	
	if selected_tower.tower_resource.upgrade_path_1_tower_resource != null:
		upgrade_1_price.text = str(GameManager.get_upgrade_tower_price(selected_tower.tower_resource, 1)) + " $"
		upgrade_1_icon.texture = tower.tower_resource.upgrade_path_1_icon
		
		var description = tower.tower_resource.upgrade_path_1_description
		var temp_increase = tower.tower_resource.upgrade_path_1_tower_resource.temperature_increase - tower.tower_resource.temperature_increase
		var power_increase = tower.tower_resource.upgrade_path_1_tower_resource.power - tower.tower_resource.power
		 
		upgrade_1.tooltip_text =  description + "\n\nTemp: + " + str(temp_increase) + " °C\nPower: + " + str(power_increase) + " W"
	else:
		upgrade_1_price.text = "-"
		
	if selected_tower.tower_resource.upgrade_path_2_tower_resource != null:
		upgrade_2_price.text = str(GameManager.get_upgrade_tower_price(selected_tower.tower_resource, 2)) + " $"
		upgrade_2_icon.texture = tower.tower_resource.upgrade_path_2_icon
		var description = tower.tower_resource.upgrade_path_1_description
		
		var temp_increase = tower.tower_resource.upgrade_path_2_tower_resource.temperature_increase - tower.tower_resource.temperature_increase
		var power_increase = tower.tower_resource.upgrade_path_2_tower_resource.power - tower.tower_resource.power
		 
		upgrade_2.tooltip_text =  description + "\n\nTemp: + " + str(temp_increase) + " °C\nPower: + " + str(power_increase) + " W"
	else:
		upgrade_2_price.text = "-"
	

func _on_deselect_tower():
	visible = false
	shop_node.visible = true
	if selected_tower != null:
		selected_tower.is_selected = false
	selected_tower = null
	
	
func _on_damage_dealt_changed():
	damage_dealt_label.text = str(selected_tower.damage_dealt)
	
func _on_deselect_button_up():
	_on_deselect_tower()


func _on_upper_upgrade_button_button_up():
	GameManager.upgrade_tower(selected_tower, 1)
	_on_select_tower(selected_tower)


func _on_lower_upgrade_button_up():
	GameManager.upgrade_tower(selected_tower, 2)
	_on_select_tower(selected_tower)


func _on_prioritization_dropdown_item_selected(index):
	selected_tower.target_prio_type = index


func _on_sell_button_down():
	GameManager.sell_tower(selected_tower)
	_on_deselect_tower()

func _input(event):
	if event.is_action_pressed("right_mouse_button"):
		_on_deselect_tower()


