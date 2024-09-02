class_name ResourceTower
extends Tower

@export var animated_sprite : AnimatedSprite2D
@export var place_col_shape : CollisionShape2D
@export var drop_timer : Timer

var money_generated : int = 0
var money_generated_this_wave : int = 0

var wave_is_active : bool = false

var is_selectable : bool = false
var is_selected : bool = false :
	set(value):
		is_selected = value
		animated_sprite.material.set_shader_parameter("line_color", select_shader_color if is_selected else Color(0,0,0,0))
		
var is_in_buff_range : bool = false:
	set(value):
		is_in_buff_range = value
		animated_sprite.material.set_shader_parameter("line_color", buff_shader_color if is_in_buff_range else Color(0,0,0,0))
		
		

func _on_place_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		if is_selectable:
			SignalManager.select_resource_tower_on_board.emit(self)
		else:
			is_selectable = true

func _ready():
	SignalManager.response_wave_is_active.connect(_on_response_wave_is_active)
	SignalManager.request_wave_is_active.emit()
	init_resource()
	SignalManager.on_start_next_wave.connect(on_start_next_wave)
	SignalManager.on_wave_finished.connect(on_wave_finished)
	
func _on_response_wave_is_active(_wave_is_active):
	wave_is_active = _wave_is_active
	
func init_resource():
	animated_sprite.sprite_frames = tower_resource.sprite_frames
	drop_timer.wait_time = tower_resource.drop_time 
	place_col_shape.shape = tower_resource.place_col_shape
	
	if wave_is_active:
		animated_sprite.play("mining")
		drop_timer.start()

func on_start_next_wave():
	money_generated_this_wave = 0
	drop_timer.start()
	animated_sprite.play("mining")
	wave_is_active = true
	print("start")
	
func on_wave_finished():
	drop_timer.stop()
	var remaining_drop = tower_resource.max_drop_amount - money_generated_this_wave
	GameManager.money += remaining_drop
	money_generated += remaining_drop
	animated_sprite.play("idle")
	wave_is_active = false
	print("finished")

func _on_drop_timer_timeout():
	
	if money_generated_this_wave + tower_resource.drop_amount <= tower_resource.max_drop_amount:
		GameManager.money += tower_resource.drop_amount
		money_generated += tower_resource.drop_amount
		money_generated_this_wave += tower_resource.drop_amount
		
		if is_selected:
			SignalManager.selected_tower_money_generated_changed.emit()
	
	else:
		drop_timer.stop()
