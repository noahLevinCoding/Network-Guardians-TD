class_name GameProgressResource
extends Resource

@export var map_scene_path : String
@export var difficulty : int

@export var money : int
@export var health : int
@export var power : int
@export var max_power : int
@export var temperature : float
@export var wave_index : int

@export var tower_resource_paths : Array[String]
@export var tower_positions  : Array[Vector2]
@export var tower_damage_dealt : Array[float]
@export var tower_money_generated : Array[int]
@export var tower_sell_values : Array[int]

@export var cooler_resource_path : String
@export var power_supply_resource_path : String
