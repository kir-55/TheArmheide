class_name VillagerFollow
extends State

@export var villager_ai: VillagerAI

@export var villager : CharacterBody2D
@export var move_speed := 200.0

@export var exhoustion_level: float = 2


func Update(delta: float):
	villager_ai.villager_data.exhaustion += delta*villager_ai.day_night_cycle.time_per_second/60*exhoustion_level

func Physics_Update(delta: float):
	if !villager.is_queued_for_deletion() and villager.is_on_floor() and villager.raycast_follow.is_colliding():
		var distance_x = abs(villager.raycast_follow.get_collider().global_position.x - villager.global_position.x)
		var direction = (villager.raycast_follow.get_collider().global_position - villager.global_position).normalized().x
		
		if distance_x < villager.attack_distance:
			RequestTransition.emit(self, "Attack")
		else:
			villager.velocity.x = move_speed * direction
	else:
		RequestTransition.emit(self, "Idle")
