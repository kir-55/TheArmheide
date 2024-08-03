class_name EnemyFollow
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 200.0

func Enter():
	print(self.name)


func Physics_Update(delta: float):
	if enemy.is_on_floor() and enemy.current_closest_target:
		var distance_x = abs(enemy.current_closest_target.global_position.x - enemy.global_position.x)
		var direction = (enemy.current_closest_target.global_position - enemy.global_position).normalized().x
		
		if distance_x < enemy.follow_distance:
			if distance_x < enemy.attack_distance:
				RequestTransition.emit(self, "Attack")
			else:
				enemy.velocity.x = move_speed * direction
		else:
			RequestTransition.emit(self, "Idle")
