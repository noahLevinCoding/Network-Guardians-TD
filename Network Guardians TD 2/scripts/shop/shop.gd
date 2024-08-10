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
@export var tower_place_col : CollisionShape2D
@export var tower_place_area : Area2D
@export var tower_place_sprite : Sprite2D

func _on_item_list_item_selected(index):
	select(index)

func _process(_delta):
	if selected_item != null:
		tower_range_polygon.global_position = get_global_mouse_position()
		tower_place_col.global_position = get_global_mouse_position()
		tower_place_sprite.global_position = get_global_mouse_position()
		
		if tower_place_area.has_overlapping_areas() or tower_place_area.has_overlapping_bodies() or not mouse_in_placable_area:
			tower_range_polygon.color = Color(1, 0, 0, 0.2)
		else:
			tower_range_polygon.color = Color(1, 1, 1, 0.2)
		
		
func select(index : int):
	selected_item = items[index]
	#TODO: change custom cursor to sprite
	#Input.set_custom_mouse_cursor(selected_item.icon, Input.CURSOR_ARROW, selected_item.icon.get_size() / 2)	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	tower_place_sprite.texture = selected_item.icon
	tower_place_sprite.visible = true
	
	tower_name_label.text = selected_item.name
	tower_power_label.text = str(selected_item.tower_resource.power) + " W"
	tower_temperature_label.text = "+" + str(selected_item.tower_resource.temperature_increase) + " °C"
	
	tower_power_label.set_modulate(red_color if GameManager.max_power < GameManager.power + selected_item.tower_resource.power else white_color)
	tower_power_text_label.set_modulate(red_color if GameManager.max_power < GameManager.power + selected_item.tower_resource.power else white_color)
	
	if not selected_item.tower_resource is ResourceTowerResource:
	
		var radius = 0
	
		if selected_item.tower_resource is AttackTowerResource:
			radius = selected_item.tower_resource.attack_range
			
		if selected_item.tower_resource is SupportTowerResource:
			radius = selected_item.tower_resource.support_range
		
		var segments = 64
		var points = []
		
		for i in range(segments):
			var angle = 2 * PI * i / segments
			points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
			
		tower_range_polygon.polygon = points
		tower_range_polygon.visible = true
	
	tower_place_col.shape = selected_item.tower_resource.place_col_shape
	
	#TODO cursor shape

func deselect():
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

	tower_place_col.shape = null
	
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
		item_list.set_item_disabled(i, GameManager.money < items[i].price)

func buy_tower(mouse_position):
	GameManager.buy_tower(selected_item, mouse_position)
	deselect()

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


