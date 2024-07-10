class_name Playing
extends Node2D

signal pause
signal start_next_wave

@export var health_label : Label 
@export var money_label : Label
@export var temperature_label : Label
@export var power_label : Label

@export var auto_start_label : Label
@export var speed_label : Label

@export var wave_status_label : Label

@export var auto_start_check_button : TextureCheckButton
@export var speed_check_button : TextureCheckButton

@export var wave_index_value_label : Label

var auto_start_enabled : bool = false :
	set(value):
		auto_start_enabled = value
		
		if value == true:
			auto_start_label.text = "On"
		else:
			auto_start_label.text = "Off"


func _ready():
	connect_signals()
	
func connect_signals():
	SignalManager.on_wave_finished.connect(_on_wave_finished)
	SignalManager.on_start_next_wave.connect(_on_start_next_wave)
	
	SignalManager.health_changed.connect(_on_health_changed)
	SignalManager.money_changed.connect(_on_money_changed)
	SignalManager.temperature_changed.connect(_on_temperature_changed)
	SignalManager.power_changed.connect(_on_power_changed)
	SignalManager.max_power_changed.connect(_on_max_power_changed)
	
	SignalManager.wave_index_changed.connect(_on_wave_index_changed)
	
	auto_start_check_button.toggle.connect(_on_autostart_check_button_toggled)
	speed_check_button.toggle.connect(_on_game_speed_toggle)
	
	
	
func _on_pause_button_up():
	pause.emit()

func reset():
	pass
	

func _on_start_next_wave_button_up():
	start_next_wave.emit()

func _on_health_changed(player_health : int):
	health_label.text = str(player_health)
	
func _on_money_changed(money: int):
	money_label.text = str(money)
	
func _on_temperature_changed(temperature: float):
	temperature_label.text = str(temperature)
	
func _on_power_changed(power: int):
	power_label.text = str(power)
	
func _on_max_power_changed(max_power : int):
	pass
	#max_power_label.text = str(max_power)

func _on_start_next_wave():
	wave_status_label.text = "Wave is active"

func _on_wave_finished():
	
	wave_status_label.text = "Start next wave"

	if auto_start_enabled:
		start_next_wave.emit()

func _on_game_speed_toggle(toggled_on):
	GameManager.game_time_scale = 2.0 if toggled_on else 1.0
	speed_label.text = "2x" if toggled_on else "1x"

func _on_autostart_check_button_toggled(toggled_on):
	auto_start_enabled = toggled_on

func _on_wave_index_changed(wave_index):
	wave_index = max(wave_index, 0)
	wave_index_value_label.text = str(wave_index)


