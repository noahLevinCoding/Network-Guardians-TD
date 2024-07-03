class_name Defeat
extends Node2D

signal restart
signal back_to_titlescreen

func _on_restart_button_up():
	restart.emit()


func _on_back_to_titlescreen_button_up():
	back_to_titlescreen.emit()

