class_name Shop
extends VBoxContainer

@export var item_list : ItemList
@export var items : Array[ShopItemResource]

var selected_item : ShopItemResource = null
var mouse_in_placable_area : bool = false

@export var tower_name_label : Label
@export var tower_power_label : Label
@export var tower_temperature_label : Label

func _on_item_list_item_selected(index):
	select(index)
		
func select(index : int):
	selected_item = items[index]
	Input.set_custom_mouse_cursor(selected_item.icon)	
	
	tower_name_label.text = selected_item.name
	tower_power_label.text = str(selected_item.tower_resource.power) + " W"
	tower_temperature_label.text = "+" + str(selected_item.tower_resource.temperature_increase) + " °C"
	
	
	#TODO cursor shape

func deselect():
	selected_item = null
	Input.set_custom_mouse_cursor(null)
	item_list.deselect_all()
	
	tower_name_label.text = "Shop"
	tower_power_label.text = "0 W"
	tower_temperature_label.text = "0 °C"
	
	
	#TODO cursor shape
	
func _ready():
	fill_item_list()
	connect_signals()
	
func connect_signals():
	SignalManager.money_changed.connect(_on_shop_parameter_changed)
	SignalManager.power_changed.connect(_on_shop_parameter_changed)
	SignalManager.max_power_changed.connect(_on_shop_parameter_changed)

func fill_item_list():
	for item in items:
		set_item_price(item)
		#item_list.add_item(str(item.price) + "$ " + "0 W", item.icon)
		item_list.add_item("150$", item.icon)
		
	for i in range(items.size()):
		item_list.set_item_tooltip_enabled(i, false)
				
func set_item_price(item : ShopItemResource):
	if GameManager.difficulty == GameManager.DIFFICULTY.EASY:
		item.price = item.price_easy
	elif GameManager.difficulty == GameManager.DIFFICULTY.MEDIUM:
		item.price = item.price_medium
	else:
		item.price = item.price_hard
	
func _on_shop_parameter_changed(value):
	update_shop_availability()

func update_shop_availability():
	for i in range(items.size()):
		#TODO: power, max power
		item_list.set_item_disabled(i, GameManager.money < items[i].price)

func buy_tower(position):
	GameManager.buy_tower(selected_item, position)
	deselect()

func _input(event):
	if event.is_action_pressed("left_mouse_button") and selected_item != null and mouse_in_placable_area:
		buy_tower(event.position)
	elif event.is_action_pressed("right_mouse_button"):
		deselect()


func _on_deselect_item_area_mouse_entered():
	deselect()


func _on_placable_area_mouse_entered():
	mouse_in_placable_area = true


func _on_placable_area_mouse_exited():
	mouse_in_placable_area = false


