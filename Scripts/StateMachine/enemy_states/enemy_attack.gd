class_name EnemyAttack
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 200.0

var body

func Enter():
	print(self.name)
	enemy.velocity.x = 0


func Physics_Update(delta: float):
	if enemy.is_on_floor() and (enemy.raycast_follow.is_colliding() or enemy.raycast_back.is_colliding()):
		if enemy.get_node("HealthSystem").is_at_low_health:
			RequestTransition.emit(self, "Escape")
			return
		
		if enemy.raycast_follow.is_colliding():
			body = enemy.raycast_follow.get_collider()
		else:
			body = enemy.raycast_back.get_collider()
		
		var distance_x = abs(body.global_position.x - enemy.global_position.x)
		if distance_x > enemy.attack_distance:
			RequestTransition.emit(self, "Follow")
	else:
		RequestTransition.emit(self, "Idle")
