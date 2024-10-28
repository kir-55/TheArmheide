class_name Guard
extends Job

@export var villager_ai: VillagerAI

@export var villager: CharacterBody2D
@export var move_speed := 170.0

@export var work_place: Node2D
var move_direction : int

@onready var day_night_cycle = get_node("/root/Game/DayNightCycle")
@onready var village_control = get_node("/root/Game/VillageControl")

@export var exhaustion_level: float = 1.5



func Update(delta: float):
	villager_ai.villager_data.exhaustion += delta*villager_ai.day_night_cycle.time_per_second/60*exhaustion_level
	if villager_ai.villager_data.exhaustion >= 16:
		RequestTransition.emit(self, "GoSleep")

func Physics_Update(delta: float):
	if work_place.global_position.x - villager.global_position.x > 5:
		villager.direction = 1
	elif work_place.global_position.x - villager.global_position.x < -5:
		villager.direction = -1
	else:
		villager.direction = 0
	
	villager.velocity.x = move_speed * villager.direction
