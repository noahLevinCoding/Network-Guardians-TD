extends AudioStreamPlayer

@export var death_sound : AudioStream
@export var upgrade_click_sound : AudioStream
@export var tower_sell_sound : AudioStream
@export var wave_finished_sound : AudioStream

func _ready():
	SignalManager.on_enemy_death.connect(_on_enemy_death)
	SignalManager.on_upgrade_button_click.connect(_on_upgrade_button_click)
	SignalManager.on_tower_sell.connect(_on_tower_sell)
	SignalManager.on_wave_finished.connect(_on_wave_finished)

	
func _on_enemy_death():
	if not self.is_playing():
		reset_db()
		volume_db = -25
		stream = death_sound
		play()
	
func _on_wave_finished():
	reset_db()
	volume_db = -5
	stream = wave_finished_sound
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
