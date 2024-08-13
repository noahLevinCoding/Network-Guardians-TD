class_name AttackTowerResource
extends TowerResource

@export var name : String

@export_group("Stats")
@export var attack_speed : float
@export var attack_range : float
@export var attack_damage : float
@export var pierce : int = 1
@export var bullet_speed : float = 1000
@export var bullet_effect : BulletEffectResource = null
@export var power : int = 0
@export var temperature_increase : float = 0
@export var number_of_targets : int = 1
@export var damage_type : DAMAGE_TYPE 

@export_group("Effects")
@export var effects : Array[EnemyEffectResource]

@export_group("Visibility and vulnerability")
@export var ignores_damage_type_immunity : bool = false
@export var can_see_camo : bool = false

@export_group("Visuals")
@export var tower_texture : Texture2D
@export var place_col_shape : Shape2D
@export var bullet_visual_resource : BulletVisualResource

@export_group("Upgrades")
@export var upgrade_path_1_icon : Texture2D
@export var upgrade_path_2_icon : Texture2D

@export var upgrade_path_1_description : String
@export var upgrade_path_2_description : String

@export var upgrade_path_1_price_easy : int = 0
@export var upgrade_path_1_price_medium : int = 0
@export var upgrade_path_1_price_hard : int = 0

@export var upgrade_path_2_price_easy : int = 0
@export var upgrade_path_2_price_medium : int = 0
@export var upgrade_path_2_price_hard : int = 0

@export var upgrade_path_1_tower_resource : TowerResource
@export var upgrade_path_2_tower_resource : TowerResource


