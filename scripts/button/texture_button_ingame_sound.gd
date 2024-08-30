extends TextureButton

func _ready():
	self.button_up.connect(_on_button_up)
	


func _on_button_up():
	SignalManager.on_button_wave_start_click.emit()

