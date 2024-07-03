class_name TowerResource
extends Resource

enum target_prio_types {FIRST, LAST}

@export var attack_speed : float
@export var attack_range : float
@export var attack_damage : float
@export var number_of_targets : int
@export var bullet_resource : BulletResource
@export var texture : Texture2D
@export var target_prio : target_prio_types
@export var can_see_camo : bool 
@export var can_pop_lead: bool
