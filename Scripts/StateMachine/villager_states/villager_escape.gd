class_name VillagerEscape
extends State

@export var villager_ai: VillagerAI

@export var villager : CharacterBody2D
@export var move_speed := 280.0
@export var chillout_delay := 3500

var move_direction := 0

var last_time_enemy_detected := 0

@export var exhoustion_level: float = 2

	
func Update(delta:float):
	villager_ai.villager_data.exhaustion +=delta*villager_ai.day_night_cycle.time_per_second/60*exhoustion_level

func Physics_Update(delta: float):
	if villager.is_on_wall():
			move_direction *= -1
			villager.velocity.x = move_direction * move_speed
			return
	
	if !villager.is_queued_for_deletion() and !villager.raycast_follow.is_colliding() and !villager.raycast_back.is_colliding() and last_time_enemy_detected == 0:
		last_time_enemy_detected = Time.get_ticks_msec()
	elif villager.raycast_follow.is_colliding() or villager.raycast_back.is_colliding():
		last_time_enemy_detected = Time.get_ticks_msec()
		if (Time.get_ticks_msec() - last_time_enemy_detected) < chillout_delay:
			if villager.raycast_follow.is_colliding():
				if move_direction == 0:
					if villager.flippable.scale.x > 0:
						move_direction = -1
					else:
						move_direction = 1
			else:
				if move_direction == 0:
					move_direction = -1
			
			villager.velocity.x = move_direction * move_speed
	elif (Time.get_ticks_msec() - last_time_enemy_detected) >= chillout_delay:
		RequestTransition.emit(self, "Idle")
		return

