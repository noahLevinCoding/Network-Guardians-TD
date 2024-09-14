class_name Titlescreen
extends Node2D

signal play
signal exit
signal options

func _enter_tree():
	var dir = DirAccess.open(".")
	if dir.dir_exists("./" + GameManager.save_folder_path):
		if not dir.dir_exists("./" + GameManager.save_folder_path + "/games"):	
			dir.make_dir("./" + GameManager.save_folder_path + "/games")
		if not dir.dir_exists("./" + GameManager.save_folder_path + "/highscores"):	
			dir.make_dir("./" + GameManager.save_folder_path + "/highscores")
		if not dir.dir_exists("./" + GameManager.save_folder_path + "/volume"):	
			dir.make_dir("./" + GameManager.save_folder_path + "/volume")
			
	else:
		dir.make_dir("./" + GameManager.save_folder_path)
		dir.make_dir("./" + GameManager.save_folder_path + "/games")
		dir.make_dir("./" + GameManager.save_folder_path + "/highscores")
		dir.make_dir("./" + GameManager.save_folder_path + "/volume")

func _on_play_button_up():
	play.emit()

func _on_exit_button_up():
	exit.emit()

func _on_option_button_up():
	options.emit()
