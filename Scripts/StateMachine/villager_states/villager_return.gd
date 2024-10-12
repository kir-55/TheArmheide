class_name VillagerReturn
extends State

@export var villager_ai: VillagerAI

@export var villager : CharacterBody2D
@export var move_speed := 270.0


func Enter():
	print(self.name, villager.name)

func Physics_Update(delta: float):
	
	
	var is_day : bool = get_node("/root/Game/DayNightCycle").is_day
	
	if !is_day:
		var destination = villager.villager_data.house.global_position
		if destination.x - villager.global_position.x > 5:
			villager.direction = 1
		elif destination.x - villager.global_position.x < -5:
			villager.direction = -1
		else:
			villager.direction = 0
		
		villager.velocity.x = move_speed * villager.direction
	else:
		RequestTransition.emit(self, "Idle")
