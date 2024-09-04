extends VBoxContainer

@export var shop_node : Shop
@export var cooler_power_supply_upgrade_node : Node
@export var attack_upgrade_node : Node
@export var support_upgrade_node : Node
@export var tower_name_label : Label
@export var money_generated_label : Label
@export var upgrade_1_price : Label
@export var upgrade_2_price : Label
@export var upgrade_1_icon : TextureRect
@export var upgrade_2_icon : TextureRect
@export var upgrade_1_button : Button
@export var upgrade_2_button : Button
@export var upgrade_1 : HBoxContainer
@export var upgrade_2 : HBoxContainer
@export var sell_button : Button
@export var selected_temperature_label : Label
@export var selected_power_label : Label

var selected_tower : Tower
var upper_upgrade_price : int
var upper_power_increase : int
var lower_upgrade_price : int
var lower_power_increase : int

func _ready():
	SignalManager.money_changed.connect(_on_money_changed)
	SignalManager.select_resource_tower_on_board.connect(_on_select_tower)
	SignalManager.deselect_tower_on_board.connect(_on_deselect_tower)
	SignalManager.reset_game.connect(_on_reset_game)
	SignalManager.selected_tower_money_generated_changed.connect(_on_money_generated_changed)
	
func _on_money_changed(_money):
	if selected_tower != null:
		if selected_tower.tower_resource.upgrade_path_1_tower_resource != null:
			var has_enough_money = upper_upgrade_price <= GameManager.money 
			var has_enough_power = upper_power_increase + GameManager.power <= GameManager.max_power
			
			upgrade_1_button.disabled = not (has_enough_money and has_enough_power)
			
		if selected_tower.tower_resource.upgrade_path_2_tower_resource != null:
			var has_enough_money = lower_upgrade_price <= GameManager.money 
			var has_enough_power = lower_power_increase + GameManager.power <= GameManager.max_power
			
			upgrade_2_button.disabled = not (has_enough_money and has_enough_power)
	
func _on_reset_game():
	_on_deselect_tower()	
	
func _on_select_tower(tower : Tower):
	_on_deselect_tower()
	attack_upgrade_node._on_deselect_tower()
	support_upgrade_node._on_deselect_tower()
	cooler_power_supply_upgrade_node._on_deselect()
	
	if tower == null:
		return
	
	SignalManager.on_select_shop.emit()
	
	selected_tower = tower
	visible = true
	shop_node.visible = false
	cooler_power_supply_upgrade_node.visible = false
	attack_upgrade_node.visible = false
	support_upgrade_node.visible = false
	selected_tower.is_selected = true
	
	tower_name_label.text = selected_tower.tower_resource.name
	money_generated_label.text = str(selected_tower.money_generated)
	sell_button.text = "Sell: " + str(selected_tower.sell_value)
	selected_power_label.text = str(selected_tower.tower_resource.power) + " W"
	selected_temperature_label.text = "+ " + str(selected_tower.tower_resource.temperature_increase) + " °C"
	
	if selected_tower.tower_resource.upgrade_path_1_tower_resource != null:
		var price = GameManager.get_upgrade_tower_price(selected_tower.tower_resource, 1)
		upper_upgrade_price = price
		
		upgrade_1_price.text = str(price) + " $"
		upgrade_1_icon.texture = tower.tower_resource.upgrade_path_1_icon
		
		var description = tower.tower_resource.upgrade_path_1_description
		var temp_increase = tower.tower_resource.upgrade_path_1_tower_resource.temperature_increase - tower.tower_resource.temperature_increase
		var power_increase = tower.tower_resource.upgrade_path_1_tower_resource.power - tower.tower_resource.power
		upper_power_increase = power_increase 
		
		
		upgrade_1.tooltip_text =  description + "\n\nTemp: + " + str(temp_increase) + " °C\nPower: + " + str(power_increase) + " W"
	
		var has_enough_money = price <= GameManager.money 
		var has_enough_power = power_increase + GameManager.power <= GameManager.max_power
		
		upgrade_1_button.disabled = not (has_enough_money and has_enough_power)
	else:
		upgrade_1_price.text = "MAX"
		upgrade_1.tooltip_text = "Path maxed"
		upgrade_1_button.disabled = true
		
		
	if selected_tower.tower_resource.upgrade_path_2_tower_resource != null:
		var price = GameManager.get_upgrade_tower_price(selected_tower.tower_resource, 2)
		lower_upgrade_price = price
		
		upgrade_2_price.text = str(price) + " $"
		
		
		upgrade_2_icon.texture = tower.tower_resource.upgrade_path_2_icon
		var description = tower.tower_resource.upgrade_path_2_description
		
		var temp_increase = tower.tower_resource.upgrade_path_2_tower_resource.temperature_increase - tower.tower_resource.temperature_increase
		var power_increase = tower.tower_resource.upgrade_path_2_tower_resource.power - tower.tower_resource.power
		lower_power_increase = power_increase 
		
		upgrade_2.tooltip_text =  description + "\n\nTemp: + " + str(temp_increase) + " °C\nPower: + " + str(power_increase) + " W"
	
		var has_enough_money = price <= GameManager.money 
		var has_enough_power = power_increase + GameManager.power <= GameManager.max_power
		
		upgrade_2_button.disabled = not (has_enough_money and has_enough_power)
	else:
		upgrade_2_price.text = "MAX"
		upgrade_2.tooltip_text = "Path maxed"
		upgrade_2_button.disabled = true

func _on_deselect_tower():
	visible = false
	shop_node.visible = true
	if selected_tower != null:
		selected_tower.is_selected = false
		SignalManager.on_deselect_shop.emit()
	selected_tower = null
	
	
func _on_money_generated_changed():
	money_generated_label.text = str(selected_tower.money_generated)
	
func _on_deselect_button_up():
	_on_deselect_tower()


func _on_upper_upgrade_button_button_up():
	GameManager.upgrade_tower(selected_tower, 1)
	_on_select_tower(selected_tower)


func _on_lower_upgrade_button_up():
	GameManager.upgrade_tower(selected_tower, 2)
	_on_select_tower(selected_tower)


func _on_sell_button_down():
	var selected_tower_copy = selected_tower
	_on_deselect_tower()
	GameManager.sell_tower(selected_tower_copy)

func _input(event):
	if event.is_action_pressed("right_mouse_button"):
		_on_deselect_tower()


func _on_wiki_tower_button_up():
	SignalManager.wiki_tower_button.emit(selected_tower.tower_resource.wiki_index)


func _on_upper_upgrade_button_mouse_entered():
	SignalManager.on_shop_hover.emit()


func _on_lower_upgrade_button_mouse_entered():
	SignalManager.on_shop_hover.emit()


func _on_sell_button_mouse_entered():
	SignalManager.on_shop_hover.emit()


func _on_deselect_button_mouse_entered():
	SignalManager.on_shop_hover.emit()
