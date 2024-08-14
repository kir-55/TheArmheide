extends Node

@export var villagers: Array[Villager]


@export var possible_names: Array[String]


func _ready():
	generate_villager() 
	generate_villager()
	
func generate_villager():
	var villager := Villager.new()
	villager.name = possible_names.pick_random()
	villagers.append(villager)
