class_name EnemyFollow
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 120.0

func Enter():
	print(self.name)


func Physics_Update(delta: float):
	if enemy.is_on_floor() and enemy.current_closest_target:
		var direction = enemy.current_closest_target.global_position - enemy.global_position
		
		if direction.length() < 500:
			enemy.velocity = direction.normalized() * move_speed
		else:
			enemy.velocity = Vector2()
		
		if direction.length() > 500:
			RequestTransition.emit(self, "Idle")
