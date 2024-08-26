class_name Titlescreen
extends Node2D

signal play
signal exit
signal options

func _on_play_button_up():
	play.emit()

func _on_exit_button_up():
	exit.emit()

func _on_option_button_up():
	options.emit()
