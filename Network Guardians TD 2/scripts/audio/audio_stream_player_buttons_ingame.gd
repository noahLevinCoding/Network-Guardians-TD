extends AudioStreamPlayer

@export var click_sound : AudioStream

func _ready():
	SignalManager.on_button_ingame_click.connect(_on_button_ingame_click)

	
func _on_button_ingame_click():
	stream = click_sound
	play()
	
