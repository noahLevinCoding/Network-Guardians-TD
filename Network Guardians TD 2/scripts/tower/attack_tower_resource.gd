class_name AttackTowerResource
extends TowerResource

@export var name : String

@export_group("Stats")
@export var damage_type : DAMAGE_TYPE 
@export var attack_damage : float
@export var attack_speed : float
@export var attack_range : float
@export var pierce : int = 1
@export var number_of_targets : int = 1
@export var power : int = 0
@export var temperature_increase : float = 0

@export_group("Bullet Stats")
@export var bullet_speed : float = 1000
@export var bullet_effect : BulletEffectResource = null

@export_group("Enemy Effects")
@export var effects : Array[EnemyEffectResource]

@export_group("Visibility and vulnerability")
@export var ignores_damage_type_immunity : bool = false
@export var can_see_camo : bool = false
@export var extra_damage_to_trojan : bool = false

@export_group("Visuals")
@export var sprite_frames : SpriteFrames
@export var place_col_shape : Shape2D
@export var bullet_visual_resource : BulletVisualResource

@export_group("Upgrades")

@export_subgroup("Upgrade 1")
@export var upgrade_path_1_icon : Texture2D

@export var upgrade_path_1_description : String

@export var upgrade_path_1_price_easy : int = 0
@export var upgrade_path_1_price_medium : int = 0
@export var upgrade_path_1_price_hard : int = 0

@export var upgrade_path_1_tower_resource : TowerResource

@export_subgroup("Upgrade 2")
@export var upgrade_path_2_icon : Texture2D

@export var upgrade_path_2_description : String

@export var upgrade_path_2_price_easy : int = 0
@export var upgrade_path_2_price_medium : int = 0
@export var upgrade_path_2_price_hard : int = 0

@export var upgrade_path_2_tower_resource : TowerResource


