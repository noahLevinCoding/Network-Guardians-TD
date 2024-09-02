class_name WikiTower
extends Node2D

@export var texture_rect : TextureRect
@export var tower_entries : Array[Texture2D]
var tower_index = 0

signal back

func _ready():
	if tower_entries.size() > 0:
		texture_rect.texture = tower_entries[0]

func select_tower(wiki_tower_index : int):
	if 0 <= wiki_tower_index and wiki_tower_index < tower_entries.size():
		tower_index = wiki_tower_index
		texture_rect.texture = tower_entries[tower_index]

func _on_back_button_up():
	back.emit()
	queue_free()


func _on_previous_button_up():
	if tower_entries.size() > 0:
		tower_index -= 1
		if tower_index < 0:
			tower_index = tower_entries.size() - 1
		texture_rect.texture = tower_entries[tower_index]


func _on_next_button_up():
	if tower_entries.size() > 0:
		tower_index += 1
		tower_index %= tower_entries.size()
		texture_rect.texture = tower_entries[tower_index]

func on_escape():
	SignalManager.on_button_click.emit()
	_on_back_button_up()
