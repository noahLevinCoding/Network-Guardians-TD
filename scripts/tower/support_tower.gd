class_name SupportTower
extends Tower

@export var sprite : Sprite2D
@export var support_col_shape : CollisionShape2D
@export var place_col_shape : CollisionShape2D
@export var range_indicator : Polygon2D

var towers = []

var is_selectable : bool = false
var is_selected : bool = false :
	set(value):
		is_selected = value
		range_indicator.visible = is_selected
		sprite.material.set_shader_parameter("line_color", select_shader_color if is_selected else Color(0,0,0,0))

var is_in_buff_range : bool = false:
	set(value):
		is_in_buff_range = value
		sprite.material.set_shader_parameter("line_color", buff_shader_color if is_in_buff_range else Color(0,0,0,0))


var towers_buffed : int

func _ready():
	range_indicator.color = Color(1, 1, 1, 0.2)
	init_resource()
	
	
func init_resource():
	sprite.texture = tower_resource.tower_texture
	support_col_shape.shape.radius = tower_resource.support_range
	place_col_shape.shape = tower_resource.place_col_shape
	
	var radius = tower_resource.support_range
	var segments = 64
	var points = []
	
	for i in range(segments):
		var angle = 2 * PI * i / segments
		points.append(Vector2(cos(angle) * radius, sin(angle) * radius))
		
	range_indicator.polygon = points
	
	
func _on_support_area_entered(area):
	if area.owner is Tower and area.owner != self and not area.owner is SupportTower:
		towers.append(area.owner)
		towers_buffed = towers.size()
		
		for effect in tower_resource.effects:
			area.owner.buffs.append(TowerEffect.new(effect, self))
			area.owner.reset_buff_parameters()
			area.owner.apply_buff_parameters()
	

func _on_support_area_exited(area):
	if area.owner is Tower and not area.owner is SupportTower:
		towers.erase(area.owner)
		towers_buffed = towers.size()
		
		for effect in area.owner.buffs:
			if effect.source == self:
				area.owner.buffs.erase(effect)
				area.owner.reset_buff_parameters()
				area.owner.apply_buff_parameters()
			
		
func _on_place_area_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed('left_mouse_button'):
		if is_selectable:
			SignalManager.select_support_tower_on_board.emit(self)
		else:
			is_selectable = true
