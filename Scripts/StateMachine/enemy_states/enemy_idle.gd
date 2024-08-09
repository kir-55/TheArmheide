class_name EnemyIdle
extends State


@export var enemy: CharacterBody2D
@export var move_speed := 170.0


var move_direction : int
var wander_time : float

func randomize_wander():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range(1, 3.5)
	if move_direction == 0:
		wander_time = randf_range(0.7, 2)

func Enter():
	print(self.name)
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		

func Physics_Update(delta: float):
	if enemy and enemy.is_on_floor():
		enemy.velocity.x = move_direction * move_speed
	
	if enemy.raycast_follow.is_colliding() or enemy.raycast_back.is_colliding():
		if enemy.get_node("HealthSystem").is_at_low_health:
			RequestTransition.emit(self, "Escape")
		else:
			RequestTransition.emit(self, "Follow")
