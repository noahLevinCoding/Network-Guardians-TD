class_name Shop
extends Control

@export var item_list : ItemList
@export var items : Array[ShopItemResource]

var selected_item : ShopItemResource = null

func _on_item_list_item_selected(index):
	selected_item = items[index]
	Input.set_custom_mouse_cursor(selected_item.icon)
	
func _input(event):
	if event.is_action_pressed("place") and selected_item != null:
		place_tower(event.position)
	elif event.is_action_released("deselect"):
		deselect()
		
func deselect():
	selected_item = null
	Input.set_custom_mouse_cursor(null)

	
func _ready():
	for item in items:
		if GameManager.difficulty == 0:
			item.price = item.price_easy
		elif GameManager.difficulty == 1:
			item.price = item.price_medium
		else:
			item.price = item.price_hard
	
		item_list.add_item(str(item.price) + "$ \n " + str(item.power) + "W", item.icon)
	
	SignalManager.money_has_changed.connect(_on_money_has_changed)

func _on_money_has_changed():
	for i in range(items.size()):
		item_list.set_item_disabled(i, GameManager.money < selected_item.price)

func place_tower(position):
	GameManager.place_tower(selected_item.tower_resource, selected_item.price, position)
	deselect()
