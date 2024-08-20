extends AudioStreamPlayer

@export var death_sound : AudioStream

func _ready():
	SignalManager.on_enemy_death.connect(_on_enemy_death)

	
func _on_enemy_death():
	stream = death_sound
	play()
	
