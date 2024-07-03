class_name Playing
extends Node2D

signal pause
signal start_next_wave

@export var health_value_label : Label 


func _ready():
	SignalManager.player_health_changed.connect(_on_player_health_changed)

func _on_pause_button_up():
	pause.emit()


func _on_start_next_wave_button_up():
	start_next_wave.emit()

func _on_player_health_changed():
	health_value_label.text = str(GameManager.player_health)
	
