extends Node

var is_running : bool = false
var health : int = 0
var temperature : float = 0
var power : float = 0
var bitcoin : int = 0

var map_scene_path : String = ""

enum DIFFICULTY {EASY, MEDIUM, HARD}
var difficulty : DIFFICULTY = DIFFICULTY.MEDIUM
