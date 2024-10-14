class_name Guard
extends State

@export var villager_ai: VillagerAI

@export var villager : CharacterBody2D
@export var move_speed := 270.0

@onready var day_night_cycle = get_node("/root/Game/DayNightCycle")
@onready var village_control = get_node("/root/Game/VillageControl")

@export var exhaustion_level: float = 1

var closest_least_occupied_tower # tower that is either least occupied or closest or both

func _ready():
	var tower1 = village_control.towers[0]
	var tower2 = village_control.towers[1]
	
	# set tower1 as closest_tower if tower1 is closer to villager than tower2 and vice versa
	var closest_tower = tower1 if (abs(tower1[0].global_position.x - villager.global_position.x) <  abs(tower2[0].global_position.x - villager.global_position.x)) else tower2
	
	# tower_x[y] is the capacity of tower_x
	if tower1[1] < tower2[1]:
		closest_least_occupied_tower = tower1
		tower1[1] += 1
	elif tower1[1] > tower2[1]:
		closest_least_occupied_tower = tower2
		tower2[1] += 1
	else:
		closest_least_occupied_tower = closest_tower
		closest_tower[1] += 1

func Update(delta: float):
	villager_ai.villager_data.exhaustion += delta*villager_ai.day_night_cycle.time_per_second/60*exhaustion_level
	if villager_ai.villager_data.exhaustion >= 16:
		closest_least_occupied_tower[1] -= 1
		RequestTransition.emit(self, "Return")


func Physics_Update(delta: float):
	var destination = closest_least_occupied_tower[0].global_position
	if destination.x - villager.global_position.x > 5:
		villager.direction = 1
	elif destination.x - villager.global_position.x < -5:
		villager.direction = -1
	else:
		villager.direction = 0
	
	villager.velocity.x = move_speed * villager.direction
