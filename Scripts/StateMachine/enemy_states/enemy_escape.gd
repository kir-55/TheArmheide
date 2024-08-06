class_name EnemyEscape
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 280.0

var move_direction

func Enter():
	print(self.name)

func Physics_Update(delta: float):
	if !enemy.current_closest_target:
		RequestTransition.emit(self, "Idle")
		return
	
	var distance_x = enemy.current_closest_target.global_position.x - enemy.global_position.x
	if abs(distance_x) >= enemy.follow_distance:
		RequestTransition.emit(self, "Idle")
	
	if distance_x < 0:
		move_direction = 1
	else:
		move_direction = -1
	
	enemy.velocity.x = move_direction * move_speed
	
