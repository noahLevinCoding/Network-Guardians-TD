class_name EnemyResource
extends Resource

enum ENEMY_TYPES {NONE, VIRUS, TROJAN}

@export_group("Enemy type")
@export var enemy_type : ENEMY_TYPES

@export_group("Visuals & Collision")
@export var base_sprite_frames : SpriteFrames
@export var camo_texture : Texture2D
@export var fortified_texture : Texture2D
@export var regrow_texture : Texture2D
@export var col_shape : Shape2D

@export_group("Stats")
@export var base_speed : float 
@export var base_health : float
#just used for prio type healthiest
#is hard coded due to performance (not worth to calculate every enemy instance the total health recursively)
@export var total_health : float

@export_group("Visibility and vulnerability")
@export var is_immune_to_light : bool = false
@export var is_immune_to_electricity : bool = false
@export var is_immune_to_magnetism : bool = false

@export var is_immune_to_pierce : bool = false
@export var is_immunte_to_slow : bool = false

@export var is_camo : bool = false
@export var is_fortified : bool = false
@export var can_regrow : bool = false

@export_group("Children")
@export var child_resources : Array[EnemyResource]
@export var child_quantities : Array[int]

@export_group("Loot")
@export var money_on_death : int = 1 

