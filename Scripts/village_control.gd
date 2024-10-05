extends Node

@export var terrain: Node2D
var houses

@export var villagers_amount = 5


@export var villager_prefab: PackedScene
@export var villagers: Array[Villager]


@export var possible_names: Array[String]


func _ready():
	houses = terrain.generate_houses(villagers_amount/2 + villagers_amount%2)
	
	for i in range(villagers_amount / 2):
		generate_villager(i, Enums.Gender.Male)
		generate_villager(i, Enums.Gender.Female)
	if villagers_amount % 2 == 1:
		generate_villager(villagers_amount/2, Enums.Gender.Male)
	
func generate_villager(family: int, gender: Enums.Gender):
	var villager := Villager.new()
	villager.name = possible_names.pick_random()
	villager.gender = gender
	villager.family = family
	villager.house = houses[family]
	villagers.append(villager)
	
	var villager_instance = villager_prefab.instantiate()
	villager_instance.villager_data = villager
	add_child(villager_instance)
