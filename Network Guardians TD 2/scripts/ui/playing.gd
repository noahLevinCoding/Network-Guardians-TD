class_name Playing
extends Node2D

signal pause
signal start_next_wave

func _on_pause_button_up():
	pause.emit()


func _on_start_next_wave_button_up():
	start_next_wave.emit()
