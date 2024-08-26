extends AudioStreamPlayer

@export var death_sound : AudioStream
@export var upgrade_click_sound : AudioStream
@export var tower_sell_sound : AudioStream

func _ready():
	SignalManager.on_enemy_death.connect(_on_enemy_death)
	SignalManager.on_upgrade_button_click.connect(_on_upgrade_button_click)
	SignalManager.on_tower_sell.connect(_on_tower_sell)

	
func _on_enemy_death():
	stream = death_sound
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
