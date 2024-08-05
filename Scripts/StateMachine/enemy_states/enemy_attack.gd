class_name EnemyAttack
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 200.0

func Enter():
	print(self.name)
	enemy.velocity.x = 0


func Physics_Update(delta: float):
	if enemy.is_on_floor() and enemy.current_closest_target:
		if enemy.get_node("HealthSystem").HP <= 20:
			RequestTransition.emit(self, "Escape")
		
		var distance_x = abs(enemy.current_closest_target.global_position.x - enemy.global_position.x)
		if distance_x > enemy.attack_distance:
			RequestTransition.emit(self, "Follow")
	else:
		RequestTransition.emit(self, "Idle")
