extends Node

signal on_destroy

var is_active : bool = false
var time_to_destroy : float = 0.0

func _process(delta):
	if is_active:
		time_to_destroy -= delta
		if time_to_destroy <= 0.0:
			queue_free()

func _exit_tree():
	on_destroy.emit()
