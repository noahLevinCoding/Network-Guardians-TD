class_name ResourceTowerResource
extends TowerResource

@export var name : String

@export_group("Stats")
@export var drop_time : float
@export var drop_amount : int
@export var max_drop_amount : int
@export var power : int = 0
@export var temperature_increase : float = 0

@export_group("Visuals")
@export var sprite_frames : SpriteFrames
@export var place_col_shape : Shape2D

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

