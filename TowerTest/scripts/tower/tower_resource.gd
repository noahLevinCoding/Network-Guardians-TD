class_name TowerResource
extends Resource

enum TARGET_PRIO_TYPES {FIRST, LAST, CAMO, LEAD, HEALTHIEST}

@export_group("Stats")
@export var attack_speed : float
@export var attack_range : float
@export var attack_damage : float
@export var pierce : int = 1

@export_group("Visibility and vulnerability")
@export var can_pop_lead : bool = false
@export var can_see_camo : bool = false

@export_group("Target prioritization")
@export var target_prio_type : TARGET_PRIO_TYPES 

@export_group("Visuals")
@export var tower_texture : Texture2D
@export var bullet_visual_resource : BulletVisualResource

@export_group("Upgrades")
@export var upgrade_icon : Texture2D
@export var upgrade_description : String

@export var upgrade_path_1_tower_resource : TowerResource
@export var upgrade_path_2_tower_resource : TowerResource



