class_name EnemyResource
extends Resource

enum ENEMY_TYPES {NONE, VIRUS, MOAB}

@export var texture : Texture
@export var col_shape : Shape2D

@export var base_speed : float 
@export var base_health : float

@export var is_lead : bool = false
@export var is_camo : bool = false
@export var is_immune_to_pierce : bool = false

@export var children_resource : EnemyResource
@export var children_quantity : int

@export var enemy_type : ENEMY_TYPES
