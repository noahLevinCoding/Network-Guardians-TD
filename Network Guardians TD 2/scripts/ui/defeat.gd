class_name Defeat
extends Node2D

@export var score_label : Label
@export var highscore_label : Label

signal restart
signal back_to_titlescreen

func _on_restart_button_up():
	restart.emit()


func _on_back_to_titlescreen_button_up():
	back_to_titlescreen.emit()

func set_score(score : int):
	score_label.text = "Score: " + str(score)

func set_highscore(highscore : int):
	highscore_label.text = "Highscore: " + str(highscore)
