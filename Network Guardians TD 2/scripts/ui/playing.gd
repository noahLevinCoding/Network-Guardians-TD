class_name Playing
extends Node2D

signal pause
signal start_next_wave

@export var health_label : Label 
@export var money_label : Label
@export var temperature_label : Label
@export var power_label : Label
@export var max_power_label : Label

@export var wave_index_value_label : Label
@export var start_next_wave_button : Button

var auto_start_enabled : bool = false


func _ready():
	connect_signals()
	
func connect_signals():
	SignalManager.on_start_next_wave.connect(_on_start_next_wave)
	SignalManager.on_wave_finished.connect(_on_wave_finished)
	
	SignalManager.health_changed.connect(_on_health_changed)
	SignalManager.money_changed.connect(_on_money_changed)
	SignalManager.temperature_changed.connect(_on_temperature_changed)
	SignalManager.power_changed.connect(_on_power_changed)
	SignalManager.max_power_changed.connect(_on_max_power_changed)
	
	SignalManager.wave_index_changed.connect(_on_wave_index_changed)
	
func _on_pause_button_up():
	pause.emit()

func reset():
	start_next_wave_button.disabled = false
	

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
	max_power_label.text = str(max_power)

	
func _on_start_next_wave():
	start_next_wave_button.disabled = true

func _on_wave_finished():
	start_next_wave_button.disabled = false
	
	if auto_start_enabled:
		start_next_wave.emit()

func _on_game_speed_toggle(toggled_on):
	GameManager.game_time_scale = 2.0 if toggled_on else 1.0

func _on_autostart_check_button_toggled(toggled_on):
	auto_start_enabled = toggled_on

func _on_wave_index_changed(wave_index):
	wave_index = max(wave_index, 0)
	wave_index_value_label.text = str(wave_index)
