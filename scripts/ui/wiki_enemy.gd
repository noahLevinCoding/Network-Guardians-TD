class_name WikiEnemy
extends Node2D

signal back

func _on_back_button_up():
	back.emit()
	queue_free()
