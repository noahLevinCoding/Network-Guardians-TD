class_name Options
extends Node2D

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var UI_BUS_ID = AudioServer.get_bus_index("UI")

@export var master_slider : HSlider
@export var music_slider: HSlider
@export var ui_slider: HSlider
@export var sfx_slider: HSlider

var save_folder_path : String = "res://saves/volume"

signal credits
signal wiki
signal back

func _on_credit_button_up():
	credits.emit()


func _on_wiki_button_up():
	wiki.emit()


func _on_back_button_up():
	back.emit()
	save_volume()


func _on_master_slider_value_changed(value):
	SignalManager.on_volume_slider_changed.emit()
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, value < .05)


func _on_music_slider_value_changed(value):
	SignalManager.on_volume_slider_changed.emit()
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value):
	SignalManager.on_volume_slider_changed.emit()
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


func _on_ui_slider_value_changed(value):
	SignalManager.on_volume_slider_changed.emit()
	AudioServer.set_bus_volume_db(UI_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(UI_BUS_ID, value < .05)
	
	
func _ready():
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS_ID))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	ui_slider.value = db_to_linear(AudioServer.get_bus_volume_db(UI_BUS_ID))
	
	load_volume()


func save_volume():
	
	var volume_resource = VolumeResource.new()
	volume_resource.master_value = master_slider.value
	volume_resource.music_value = music_slider.value
	volume_resource.sfx_value = sfx_slider.value
	volume_resource.ui_value = ui_slider.value
		
	ResourceSaver.save(volume_resource, save_folder_path + "/volume.tres")

func load_volume():
	
	if not ResourceLoader.exists(save_folder_path + "/volume.tres"):
		return
		
	var volume_resource = ResourceLoader.load(save_folder_path + "/volume.tres")
	master_slider.value = volume_resource.master_value
	music_slider.value = volume_resource.music_value
	sfx_slider.value = volume_resource.sfx_value
	ui_slider.value = volume_resource.ui_value
