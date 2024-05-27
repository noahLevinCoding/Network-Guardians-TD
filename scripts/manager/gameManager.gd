extends Node

var isRunning : bool = false
var health : int = 0
var temperature : float = 0
var power : float = 0
var bitcoin : int = 0

var mapScenePath : String = ""

enum DIFFICULTY {EASY, MEDIUM, HARD}
var difficulty : DIFFICULTY = DIFFICULTY.MEDIUM
