class_name Shop
extends VBoxContainer

@export var item_list : ItemList
@export var items : Array[ShopItemResource]

var selected_item : ShopItemResource = null

func _on_item_list_item_selected(index):
	select(index)
	
func _input(event):
	pass
	#if event.is_action_pressed("place") and selected_item != null:
		#place_tower(event.position)
	#elif event.is_action_released("deselect"):
		#deselect()
	
func select(index : int):
	selected_item = items[index]
	Input.set_custom_mouse_cursor(selected_item.icon)	
	#TODO cursor shape

func deselect():
	selected_item = null
	Input.set_custom_mouse_cursor(null)
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
		item_list.add_item(str(item.price) + "$ " + "0 W", item.icon)
		
func set_item_price(item : ShopItemResource):
	if GameManager.difficulty == GameManager.DIFFICULTY.EASY:
		item.price = item.price
	elif GameManager.difficulty == GameManager.DIFFICULTY.MEDIUM:
		item.price = 1.5 * item.price
	else:
		item.price = 2 * item.price
	
func _on_shop_parameter_changed():
	update_shop_availability()

func update_shop_availability():
	for i in range(items.size()):
		#TODO: power, max power
		item_list.set_item_disabled(i, GameManager.money < selected_item.price)

func place_tower(position):
	pass
	
	#GameManager.place_tower(selected_item.tower_resource, selected_item.price, position)
	#deselect()
