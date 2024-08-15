extends VBoxContainer

@export var shop_node : Node
@export var attack_upgrade_node : Node
@export var support_upgrade_node : Node
@export var resource_upgrade_node : Node

@export var currently_temp : Label 
@export var upgrade_temp : Label
@export var price_temp : Label
@export var price_temp_text : Label
@export var upgrade_cooler_button : Button

@export var currently_power : Label
@export var upgrade_power : Label
@export var price_power : Label
@export var price_power_text : Label
@export var upgrade_power_supply_button : Button

var red_color : Color = Color(1.0, 0.46, 0.2, 1.0)
var white_color : Color = Color(1.0, 1.0, 1.0, 1.0)

func _ready():
	SignalManager.select_cooler.connect(_on_select)
	SignalManager.select_power_supply.connect(_on_select)
	SignalManager.reset_game.connect(_on_reset_game)
	
func _on_select():
	attack_upgrade_node.visible = false
	attack_upgrade_node._on_deselect_tower()
	support_upgrade_node.visible = false
	support_upgrade_node._on_deselect_tower()
	resource_upgrade_node.visible = false
	resource_upgrade_node._on_deselect_tower()
	shop_node.visible = false
	visible = true
	
	currently_temp.text = "-" + str(GameManager.cooler.cooler_resource.temperature_decrease) + " °C"
	
	if GameManager.cooler.cooler_resource.upgrade_cooler_resource != null:
		upgrade_temp.text =  "-" + str(GameManager.cooler.cooler_resource.upgrade_cooler_resource.temperature_decrease) + " °C"
		
		var price = GameManager.get_upgrade_cooler_price(GameManager.cooler.cooler_resource.upgrade_cooler_resource)
		price_temp.text = str(price) + " $"
		upgrade_cooler_button.disabled = GameManager.money < price
		price_temp.set_modulate(red_color if GameManager.money < price else white_color)
		price_temp_text.set_modulate(red_color if GameManager.money < price else white_color)
	else:
		upgrade_temp.text = "MAX"
		price_temp.text = "-"
		upgrade_cooler_button.disabled = true
	
	currently_power.text = str(GameManager.power_supply.power_supply_resource.max_power) + " W"
	
	if GameManager.power_supply.power_supply_resource.upgrade_power_supply_resource != null:
		upgrade_power.text = str(GameManager.power_supply.power_supply_resource.upgrade_power_supply_resource.max_power) + " W"
		
		var price = GameManager.get_upgrade_power_supply_price(GameManager.power_supply.power_supply_resource.upgrade_power_supply_resource)
		price_power.text = str(price) + " $"
		upgrade_power_supply_button.disabled = GameManager.money < price
		price_power.set_modulate(red_color if GameManager.money < price else white_color)
		price_power_text.set_modulate(red_color if GameManager.money < price else white_color)
		
	else:
		upgrade_power.text = "MAX"
		price_power.text = "-"
		upgrade_power_supply_button.disabled = true
	
func _on_deselect():
	shop_node.visible = true
	visible = false
	
	price_power.set_modulate(white_color)
	price_power_text.set_modulate(white_color)
	price_temp.set_modulate(white_color)
	price_temp_text.set_modulate(white_color)

func _on_reset_game():
	_on_deselect()


func _on_upgrade_cooler():
	GameManager.upgrade_cooler()
	_on_select()


func _on_upgrade_power_supply():
	GameManager.upgrade_power_supply()
	_on_select()
