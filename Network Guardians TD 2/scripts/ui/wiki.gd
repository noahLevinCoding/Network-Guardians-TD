class_name Wiki
extends Node2D

@export var visible_node : Node
@export var wiki_enemy_scene : PackedScene
@export var wiki_tower_scene : PackedScene
@export var wiki_mechanics_scene : PackedScene

signal back


func _on_back_button_up():
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
	var wiki_tower_scene_instance = wiki_tower_scene.instantiate()
	add_child(wiki_tower_scene_instance)
	wiki_tower_scene_instance.back.connect(_on_wiki_tower_back)
	set_visibility(false)

func _on_wiki_tower_back():
	set_visibility(true)

func _on_mechanics_button_up():
	var wiki_mechanics_scene_instance = wiki_mechanics_scene.instantiate()
	add_child(wiki_mechanics_scene_instance)
	wiki_mechanics_scene_instance.back.connect(_on_wiki_mechanics_back)
	set_visibility(false)
	
func _on_wiki_mechanics_back():
	set_visibility(true)

func set_visibility(is_visible : bool):
	visible_node.visible = is_visible
