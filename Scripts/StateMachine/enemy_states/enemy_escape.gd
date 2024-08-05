class_name EnemyEscape
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 280.0

func Enter():
	print(self.name)
	var move_direction = enemy.direction * -1
	enemy.velocity.x = move_direction * move_speed

func Physics_Update(delta: float):
	if !enemy.current_closest_target:
		RequestTransition.emit(self, "Idle")
		return
	
	var distance_x = abs(enemy.current_closest_target.global_position.x - enemy.global_position.x)
	if distance_x >= enemy.follow_distance:
		RequestTransition.emit(self, "Idle")
