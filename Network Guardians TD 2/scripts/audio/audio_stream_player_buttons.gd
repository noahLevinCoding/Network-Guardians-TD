extends AudioStreamPlayer

@export var click_sound : AudioStream
@export var click_dip_sound : AudioStream
@export var click_wave_button_sound : AudioStream
@export var hover_sound : AudioStream
@export var select_shop_sound : AudioStream
@export var deselect_shop_sound : AudioStream
@export var open_prio_type_sound : AudioStream
@export var select_prio_type_sound : AudioStream
@export var upgrade_click_sound : AudioStream
@export var tower_sell_sound : AudioStream

func _ready():
	SignalManager.on_button_click.connect(_on_button_click)
	SignalManager.on_button_hover.connect(_on_button_hover)
	SignalManager.on_button_dip_click.connect(_on_button_dip_click)
	SignalManager.on_button_wave_start_click.connect(_on_button_wave_start_click)
	SignalManager.on_select_shop.connect(_on_select_shop)
	SignalManager.on_deselect_shop.connect(_on_deselect_shop)
	SignalManager.on_open_prio_type.connect(_on_open_prio_type)
	SignalManager.on_select_prio_type.connect(_on_select_prio_type)
	SignalManager.on_upgrade_button_click.connect(_on_upgrade_button_click)
	SignalManager.on_tower_sell.connect(_on_tower_sell)
	
	
func _on_button_click():
	reset_db()
	stream = click_sound
	play()
	
func _on_button_hover():
	reset_db()
	if not self.is_playing():
		stream = hover_sound
		play()

func _on_button_dip_click():
	reset_db()
	stream = click_dip_sound
	play()
	
func _on_button_wave_start_click():
	reset_db()
	stream = click_wave_button_sound
	play()
	
func _on_select_shop():
	reset_db()
	stream = select_shop_sound
	volume_db = -5
	play()

func _on_deselect_shop():
	reset_db()
	stream = deselect_shop_sound
	volume_db = -5
	play()
	
func _on_select_prio_type():
	reset_db()
	stream = select_prio_type_sound
	volume_db = -5
	play()

func _on_open_prio_type():
	reset_db()
	stream = open_prio_type_sound
	volume_db = -5
	play()

func _on_upgrade_button_click():
	reset_db()
	stream = upgrade_click_sound
	play()
	
func _on_tower_sell():
	reset_db()
	stream = tower_sell_sound
	play()

func reset_db():
	volume_db = -15
