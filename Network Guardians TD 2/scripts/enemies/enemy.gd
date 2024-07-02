class_name Enemy
extends PathFollow2D

@onready var sprite_2d = %Sprite2D

var enemy_resource : EnemyResource 
		
func _ready():
	sprite_2d.texture = enemy_resource.texture


func _process(delta):
	progress += enemy_resource.base_speed * delta
	
	if progress_ratio >= 1.0:
		GameManager.deal_damage_to_player(enemy_resource.damage_to_player)
		self.queue_free()
