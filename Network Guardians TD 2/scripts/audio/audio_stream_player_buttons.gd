extends AudioStreamPlayer

@export var click_sound : AudioStream
@export var hover_sound : AudioStream

func _ready():
	SignalManager.on_button_click.connect(_on_button_click)
	SignalManager.on_button_hover.connect(_on_button_hover)
	
func _on_button_click():
	stream = click_sound
	play()
	
func _on_button_hover():
	stream = hover_sound
	play()
