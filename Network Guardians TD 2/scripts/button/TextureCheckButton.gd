class_name TextureCheckButton
extends TextureButton

@export var texture_unchecked : Texture2D
@export var texture_checked : Texture2D

signal toggle(toggled_on : bool)

var checked : bool :
	set(value):
		checked = value
		texture_normal = texture_checked if checked else texture_unchecked
		toggle.emit(checked)

func _ready():
	checked = false
	
	self.button_up.connect(_on_button_up)

func _on_button_up():
	checked = !checked	
