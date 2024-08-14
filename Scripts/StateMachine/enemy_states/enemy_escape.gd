class_name EnemyEscape
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 280.0
@export var chillout_delay := 3500

var move_direction := 0

var last_time_villager_detected := 0

func Enter():
	print(self.name)

func Physics_Update(delta: float):
	if enemy.is_on_wall():
			print("enemy's touching the wall")
			move_direction *= -1
			enemy.velocity.x = move_direction * move_speed
			return
	
	if enemy.is_queued_for_deletion() and !enemy.raycast_follow.is_colliding() and !enemy.raycast_back.is_colliding() and last_time_villager_detected == 0:
		last_time_villager_detected = Time.get_ticks_msec()
	elif enemy.raycast_follow.is_colliding() or enemy.raycast_back.is_colliding():
		last_time_villager_detected = Time.get_ticks_msec()
		if (Time.get_ticks_msec() - last_time_villager_detected) < chillout_delay:
			if enemy.raycast_follow.is_colliding():
				if move_direction == 0:
					if enemy.flippable.scale.x > 0:
						move_direction = -1
					else:
						move_direction = 1
			else:
				if move_direction == 0:
					move_direction = -1
			
			enemy.velocity.x = move_direction * move_speed
	elif (Time.get_ticks_msec() - last_time_villager_detected) >= chillout_delay:
		RequestTransition.emit(self, "Idle")
		return

