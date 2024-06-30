class_name Enemy
extends PathFollow2D

@onready var sprite_2d = %Sprite2D

var enemy_resource : EnemyResource 
		
func _ready():
	sprite_2d.texture = enemy_resource.texture


func _process(delta):
	progress += enemy_resource.default_speed * delta
