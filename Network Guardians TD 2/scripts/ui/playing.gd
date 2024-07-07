class_name Playing
extends Node2D

signal pause
signal start_next_wave

@export var health_value_label : Label 
@export var wave_counter_label : Label
@export var start_next_wave_button : Button


func _ready():
	SignalManager.player_health_changed.connect(_on_player_health_changed)
	SignalManager.on_start_next_wave.connect(_on_start_next_wave)
	SignalManager.on_wave_finished.connect(_on_wave_finished)

func _on_pause_button_up():
	pause.emit()


func _on_start_next_wave_button_up():
	start_next_wave.emit()

func _on_player_health_changed():
	health_value_label.text = str(GameManager.player_health)
	
func _on_start_next_wave(wave_counter : int):
	wave_counter_label.text = str(wave_counter)
	
	start_next_wave_button.disabled = true

func _on_wave_finished():
	start_next_wave_button.disabled = false

func _on_game_speed_toggle(toggled_on):
	GameManager.game_time_scale = 2.0 if toggled_on else 1.0
