extends Node

enum Job {
	Jobless,
	Farmer,
	Doctor,
	Warrior,
	Guard,
	Scientist
}

@export var villagers: Array[Villager]
