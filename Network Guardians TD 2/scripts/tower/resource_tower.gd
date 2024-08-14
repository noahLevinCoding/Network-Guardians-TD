class_name ResourceTower
extends Tower

@export var sprite : Sprite2D
@export var place_col_shape : CollisionShape2D
@export var drop_timer : Timer

var money_generated : int = 0
var money_generated_this_wave : int = 0

var is_selectable : bool = false
var is_selected : bool = false :
	set(value):
		is_selected = value
		sprite.material.set_shader_parameter("line_color", select_shader_color if is_selected else Color(0,0,0,0))
		

func _on_place_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		if is_selectable:
			SignalManager.select_resource_tower_on_board.emit(self)
		else:
			is_selectable = true

func _ready():
	init_resources()
	SignalManager.on_start_next_wave.connect(on_start_next_wave)
	SignalManager.on_wave_finished.connect(on_wave_finished)
	
func init_resources():
	sprite.texture = tower_resource.tower_texture
	drop_timer.wait_time = tower_resource.drop_time 
	place_col_shape.shape = tower_resource.place_col_shape

func on_start_next_wave():
	money_generated_this_wave = 0
	drop_timer.start()
	
func on_wave_finished():
	drop_timer.stop()
	var remaining_drop = tower_resource.max_drop_amount - money_generated_this_wave
	GameManager.money += remaining_drop
	money_generated += remaining_drop

func _on_drop_timer_timeout():
	
	if money_generated_this_wave + tower_resource.drop_amount <= tower_resource.max_drop_amount:
		GameManager.money += tower_resource.drop_amount
		money_generated += tower_resource.drop_amount
		money_generated_this_wave += tower_resource.drop_amount
		
		if is_selected:
			SignalManager.selected_tower_money_generated_changed.emit()
	
	else:
		drop_timer.stop()
