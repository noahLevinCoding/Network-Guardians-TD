class_name LoadGame
extends Node2D

signal back
signal new_game
signal load_game

func _on_back_button_down():
	back.emit()


func _on_new_game_button_down():
	new_game.emit()


func _on_load_game_button_down():
	load_game.emit()
