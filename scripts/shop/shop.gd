class_name Shop
extends VBoxContainer

@export var item_list : ItemList
@export var items : Array[ShopItemResource]

var selected_item : ShopItemResource = null
var mouse_in_placable_area : bool = false

@export var tower_name_label : Label
@export var tower_power_label : Label
@export var tower_power_text_label : Label
@export var tower_temperature_label : Label

#var red_color : Color = Color(1.0, 0.55, 0.55,  1.0)
var red_color : Color = Color(1.0, 0.46, 0.2, 1.0)
var white_color : Color = Color(1.0, 1.0, 1.0, 1.0)

@export var tower_range_polygon : Polygon2D
@export var tower_range_area : Area2D
@export var tower_place_col : CollisionShape2D
@export var tower_place_area : Area2D
@export var tower_place_sprite : Sprite2D

var hovered_item := -1

func _on_item_list_item_selected(index):
	select(index)

func _process(_delta):
	if selected_item != null:
		tower_range_polygon.global_position = get_global_mouse_position()
		tower_place_col.global_position = get_global_mouse_position()
		tower_place_sprite.global_position = get_global_mouse_position()
		tower_range_area.global_position = get_global_mouse_position()
		
		var has_not_enough_power = GameManager.max_power < GameManager.power + selected_item.tower_resource.power
		
		if tower_place_area.has_overlapping_areas() or tower_place_area.has_overlapping_bodies() or not mouse_in_placable_area or has_not_enough_power:
			tower_range_polygon.color = Color(1, 0, 0, 0.2)
		else:
			tower_range_polygon.color = Color(1, 1, 1, 0.2)
		
		
func select(index : int):
	SignalManager.on_select_shop.emit()
	
	selected_item = items[index]
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	tower_place_sprite.texture = selected_item.mouse_cursor_texture
	tower_place_sprite.visible = true
	
	tower_name_label.text = selected_item.name
	tower_power_label.text = str(selected_item.tower_resource.power) + " W"
	tower_temperature_label.text = "+" + str(selected_item.tower_resource.temperature_increase) + " °C"
	
	tower_power_label.set_modulate(red_color if GameManager.max_power < GameManager.power + selected_item.tower_resource.power else white_color)
	tower_power_text_label.set_modulate(red_color if GameManager.max_power < GameManager.power + selected_item.tower_resource.power else white_color)
	
	var radius = 0
	if selected_item.tower_resource is ResourceTowerResource:
		radius = 4000
	
	if selected_item.tower_resource is AttackTowerResource:
		radius = selected_item.tower_resource.attack_range
		tower_range_area.get_child(0).shape.radius = radius
		tower_range_area.monitorable = true
			
	if selected_item.tower_resource is SupportTowerResource:
		radius = selected_item.tower_resource.support_range
		tower_range_area.get_child(0).shape.radius = radius
		
	var segments = 64
	var points = []
		
	for i in range(segments):
		var angle = 2 * PI * i / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
			
	tower_range_polygon.polygon = points
	tower_range_polygon.visible = true
	
	tower_place_col.position = get_global_mouse_position()
	tower_place_col.get_parent().monitorable = true
	tower_place_col.shape = selected_item.tower_resource.place_col_shape
	

func deselect():
	if selected_item != null:
		SignalManager.on_deselect_shop.emit()
	
	selected_item = null
	Input.set_custom_mouse_cursor(null)
	item_list.deselect_all()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	tower_place_sprite.texture = null
	tower_place_sprite.visible = false
	
	tower_name_label.text = "Shop"
	tower_power_label.text = "0 W"
	tower_temperature_label.text = "0 °C"
	
	tower_power_label.set_modulate(white_color)
	tower_power_text_label.set_modulate(white_color)
	
	tower_range_polygon.visible = false
	tower_range_area.monitoring = false
	tower_range_area.monitorable = false
	tower_range_area.get_child(0).shape.radius = 0

	tower_place_col.shape = null
	tower_place_col.get_parent().monitorable = false
	
	#TODO cursor shape
	
func _ready():
	connect_signals()
	
	tower_range_polygon.visible = false
	
func connect_signals():
	SignalManager.money_changed.connect(_on_shop_parameter_changed)
	SignalManager.power_changed.connect(_on_shop_parameter_changed)
	SignalManager.max_power_changed.connect(_on_shop_parameter_changed)
	
	SignalManager.pause_game.connect(_on_pause_game)
	SignalManager.init_game.connect(_on_init_game)
	SignalManager.reset_game.connect(_on_reset_game)
	
func _on_reset_game():
	deselect()
	
func _on_pause_game():
	deselect()

func _on_init_game():
	delete_item_list()
	fill_item_list()
	update_shop_availability()

func delete_item_list():
	item_list.clear()

func fill_item_list():
	for item in items:
		set_item_price(item)
		item_list.add_item(str(item.price) + "$", item.icon)
		
	for i in range(items.size()):
		item_list.set_item_tooltip_enabled(i, false)
				
func set_item_price(item : ShopItemResource):
	if GameManager.difficulty == GameManager.DIFFICULTY.EASY:
		item.price = item.price_easy
	elif GameManager.difficulty == GameManager.DIFFICULTY.MEDIUM:
		item.price = item.price_medium
	else:
		item.price = item.price_hard
	
	
func _on_shop_parameter_changed(_value):
	update_shop_availability()

func update_shop_availability():
	for i in range(item_list.get_item_count()):
		var has_not_enough_money = GameManager.money < items[i].price
		var has_not_enough_power = GameManager.max_power < GameManager.power + items[i].tower_resource.power
		
		var tooltip = ""
		if has_not_enough_power:
			tooltip += "Not enough power:\nUpgrade your power supply or sell other towers.\n\n"
			
		if has_not_enough_money:
			tooltip += "Not enought money:\nDefeat enemies or use GPUs to earn money."
		
		var can_not_buy = has_not_enough_money or has_not_enough_power
		
		item_list.set_item_disabled(i, can_not_buy)
		item_list.set_item_tooltip_enabled(i, can_not_buy)
		item_list.set_item_tooltip(i, tooltip)
		

func buy_tower(mouse_position):
	var selected_item_copy = selected_item
	deselect()
	GameManager.buy_tower(selected_item_copy, mouse_position)

func _input(event):
	if event.is_action_pressed("left_mouse_button") and selected_item != null and mouse_in_placable_area and not tower_place_area.has_overlapping_areas() and not tower_place_area.has_overlapping_bodies():
		buy_tower(event.position)
	elif event.is_action_pressed("right_mouse_button"):
		deselect()


func _on_deselect_item_area_mouse_entered():
	deselect()
	
func _on_placable_area_mouse_entered():
	mouse_in_placable_area = true

func _on_placable_area_mouse_exited():
	mouse_in_placable_area = false

func _on_wiki_button_up():
	SignalManager.wiki_shop_button.emit()


func _on_wiki_shop_button_up():
	SignalManager.wiki_shop_button.emit()

func _on_shop_item_list_gui_input(event):
	if event is InputEventMouseMotion:
		var mouse_pos := item_list.get_local_mouse_position()
		var index := item_list.get_item_at_position(mouse_pos, true)
		if hovered_item != index:
			if index != -1:
				_on_item_hovered(index)
			hovered_item = index


func _on_shop_item_list_mouse_exited():
	hovered_item = -1
	
	tower_name_label.text = "Shop"
	tower_power_label.text = "0 W"
	tower_temperature_label.text = "0 °C"
	
	tower_power_label.set_modulate(white_color)
	tower_power_text_label.set_modulate(white_color)
	
func _on_item_hovered(index : int):
	tower_name_label.text = items[index].name
	tower_power_label.text = str(items[index].tower_resource.power) + " W"
	tower_temperature_label.text = "+" + str(items[index].tower_resource.temperature_increase) + " °C"
	
	tower_power_label.set_modulate(red_color if GameManager.max_power < GameManager.power + items[index].tower_resource.power else white_color)
	tower_power_text_label.set_modulate(red_color if GameManager.max_power < GameManager.power + items[index].tower_resource.power else white_color)


func _on_tower_range_area_entered(area):
	if area.owner is Tower:
		area.owner.is_in_buff_range = true


func _on_tower_range_area_exited(area):
	if area.owner is Tower:
		area.owner.is_in_buff_range = false
