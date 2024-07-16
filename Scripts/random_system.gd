class_name RandomSystem

extends Node


# Use this script when generating terain, objects positions, man stats and other static stuff
# For dynamic stuff like man wounder direction don't use this script
@export var seed = "kirill"
var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = hash(seed)

func get_rnd_int(min: int, max: int) -> int:
	return randi_range(min, max)
	
func get_rnd_float(min: float, max: float) -> float:
	return randf_range(min, max)
