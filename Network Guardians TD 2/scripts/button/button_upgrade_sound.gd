extends Button

func _ready():
	self.button_up.connect(_on_button_up)
	


func _on_button_up():
	SignalManager.on_upgrade_button_click.emit()

