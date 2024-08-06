class_name SlowEffect
extends Effect

var slow_multiplier : float = 1.0

func _init(duration : float, slow_multiplier : float):
	super(duration)
	self.slow_multiplier = slow_multiplier
	
func apply_effect(enemy):
	if enemy.slow_multiplier > self.slow_multiplier:
		enemy.slow_multiplier = self.slow_multiplier
