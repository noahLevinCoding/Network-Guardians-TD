class_name DifficultySelection
extends Node2D

signal set_difficulty(difficulty : int)
signal back



func _on_back_button_up():
	back.emit()


func _on_easy_button_up():
	set_difficulty.emit(0)


func _on_medium_button_up():
	set_difficulty.emit(1)


func _on_hard_button_up():
	set_difficulty.emit(2)
