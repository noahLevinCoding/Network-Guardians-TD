class_name Wiki
extends Node2D

@export var visible_node : Node
@export var wiki_enemy_scene : PackedScene
@export var wiki_tower_scene : PackedScene
@export var wiki_mechanics_scene : PackedScene

var wiki_tower_scene_instance
var wiki_mechanics_scene_instance

var wiki_entered_directly : bool = false

signal back
signal back_to_game

func _ready():
	SignalManager.enter_wiki_tower.connect(_on_enter_wiki_tower)
	SignalManager.enter_wiki_mechanics.connect(_on_enter_wiki_mechanics)
	
func _on_enter_wiki_tower(wiki_tower_index : int):
	_on_tower_button_up()
	wiki_tower_scene_instance.select_tower(wiki_tower_index)
	
func _on_enter_wiki_mechanics():
	_on_mechanics_button_up()


func _on_back_button_up():
	if wiki_entered_directly:
		back_to_game.emit()
	else:
		back.emit()
	queue_free()


func _on_enemy_button_up():
	var wiki_enemy_scene_instance = wiki_enemy_scene.instantiate()
	add_child(wiki_enemy_scene_instance)
	wiki_enemy_scene_instance.back.connect(_on_wiki_enemy_back)
	set_visibility(false)

func _on_wiki_enemy_back():
	set_visibility(true)

func _on_tower_button_up():
	wiki_tower_scene_instance = wiki_tower_scene.instantiate()
	add_child(wiki_tower_scene_instance)
	wiki_tower_scene_instance.back.connect(_on_wiki_tower_back)
	set_visibility(false)

func _on_wiki_tower_back():
	set_visibility(true)
	wiki_tower_scene_instance = null
	
	if wiki_entered_directly:
		_on_back_button_up()

func _on_mechanics_button_up():
	wiki_mechanics_scene_instance = wiki_mechanics_scene.instantiate()
	add_child(wiki_mechanics_scene_instance)
	wiki_mechanics_scene_instance.back.connect(_on_wiki_mechanics_back)
	set_visibility(false)
	
func _on_wiki_mechanics_back():
	set_visibility(true)
	wiki_mechanics_scene_instance = null
	
	if wiki_entered_directly:
		_on_back_button_up()

func set_visibility(is_visible : bool):
	visible_node.visible = is_visible
