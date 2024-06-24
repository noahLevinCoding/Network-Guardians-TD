class_name Pause
extends Node2D

signal restart
signal back_to_titlescreen
signal resume

func _on_restart_button_up():
	restart.emit()


func _on_back_to_titlescreen_button_up():
	back_to_titlescreen.emit()


func _on_resume_button_up():
	resume.emit()
