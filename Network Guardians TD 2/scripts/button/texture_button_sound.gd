extends TextureButton

func _ready():
	self.button_up.connect(_on_button_up)
	self.mouse_entered.connect(_on_hover)


func _on_button_up():
	SignalManager.on_button_click.emit()

func _on_hover():
	SignalManager.on_button_hover.emit()
