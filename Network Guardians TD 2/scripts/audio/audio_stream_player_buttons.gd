extends AudioStreamPlayer

@export var click_sound : AudioStream
@export var click_dip_sound : AudioStream
@export var click_wave_button_sound : AudioStream
@export var hover_sound : AudioStream
@export var select_shop_sound : AudioStream

func _ready():
	SignalManager.on_button_click.connect(_on_button_click)
	SignalManager.on_button_hover.connect(_on_button_hover)
	SignalManager.on_button_dip_click.connect(_on_button_dip_click)
	SignalManager.on_button_wave_start_click.connect(_on_button_wave_start_click)
	SignalManager.on_select_shop.connect(_on_select_shop)
	
func _on_button_click():
	stream = click_sound
	play()
	
func _on_button_hover():
	if not self.is_playing():
		stream = hover_sound
		play()

func _on_button_dip_click():
	stream = click_dip_sound
	play()
	
func _on_button_wave_start_click():
	stream = click_wave_button_sound
	play()
	
func _on_select_shop():
	stream = select_shop_sound
	play()
