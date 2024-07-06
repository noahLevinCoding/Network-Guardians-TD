class_name EnemyResource
extends Resource

enum ENEMY_TYPES {NONE, VIRUS, MOAB}

@export_group("Enemy type")
@export var enemy_type : ENEMY_TYPES

@export_group("Visuals & Collision")
@export var base_texture : Texture2D
@export var camo_texture : Texture2D
@export var lead_texture : Texture2D
@export var col_shape : Shape2D

@export_group("Stats")
@export var base_speed : float 
@export var base_health : float

@export_group("Visibility and vulnerability")
@export var is_lead : bool = false
@export var is_camo : bool = false
@export var is_immune_to_pierce : bool = false

@export_group("Children")
@export var children_resource : EnemyResource
@export var children_quantity : int

