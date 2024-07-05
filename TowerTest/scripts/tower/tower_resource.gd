class_name TowerResource
extends Resource

enum TARGET_PRIO_TYPES {FIRST, LAST, CAMO, LEAD, HEALTHIEST}

@export var tower_texture : Texture2D
@export var attack_speed : float
@export var attack_range : float
@export var attack_damage : float
@export var pierce : int = 1
@export var can_pop_lead : bool = false
@export var can_see_camo : bool = false
@export var target_prio_type : TARGET_PRIO_TYPES 

@export var bullet_visual_resource : BulletVisualResource


