class_name Options
extends Node2D

@export var wiki_scene : PackedScene
@export var credits_scene : PackedScene


@export var visible_node : Node

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var UI_BUS_ID = AudioServer.get_bus_index("UI")

@export var master_slider : HSlider
@export var music_slider: HSlider
@export var ui_slider: HSlider
@export var sfx_slider: HSlider

var save_folder_path : String = "saves/volume"

var wiki_scene_instance = null
var credits_scene_instance = null

signal back
	
func _on_enter_wiki():
	_on_wiki_button_up()
	wiki_scene_instance.wiki_entered_directly = true

func _on_credit_button_up():
	credits_scene_instance = credits_scene.instantiate()
	add_child(credits_scene_instance)
	credits_scene_instance.back.connect(_on_credit_back)
	set_visibility(false)


func _on_wiki_button_up():
	wiki_scene_instance = wiki_scene.instantiate()
	add_child(wiki_scene_instance)
	wiki_scene_instance.back.connect(_on_wiki_back)
	wiki_scene_instance.back_to_game.connect(_on_wiki_back_to_game)
	set_visibility(false)

func _on_wiki_back():
	set_visibility(true)
	wiki_scene_instance = null
	
func _on_credit_back():
	set_visibility(true)
	credits_scene_instance = null

func _on_wiki_back_to_game():
	_on_wiki_back()
	_on_back_button_up()
	

func _on_back_button_up():
	back.emit()
	save_volume()

func set_visibility(_is_visible : bool):
	visible_node.visible = _is_visible

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
	
	SignalManager.enter_wiki.connect(_on_enter_wiki)
	
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
		
	ResourceSaver.save(volume_resource, save_folder_path + "/volume.res")

func load_volume():
	
	if not ResourceLoader.exists(save_folder_path + "/volume.res"):
		return
		
	var volume_resource = ResourceLoader.load(save_folder_path + "/volume.res")
	master_slider.value = volume_resource.master_value
	music_slider.value = volume_resource.music_value
	sfx_slider.value = volume_resource.sfx_value
	ui_slider.value = volume_resource.ui_value


func on_escape():
	if wiki_scene_instance == null and credits_scene_instance == null:
		SignalManager.on_button_click.emit()
		_on_back_button_up()
	elif wiki_scene_instance != null:
		wiki_scene_instance.on_escape()
	else:
		pass
		credits_scene_instance.on_escape()
