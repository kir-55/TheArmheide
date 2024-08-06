class_name EnemyIdle
extends State


@export var enemy: CharacterBody2D
@export var move_speed := 170.0


var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3.5)

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
		enemy.velocity = move_direction * move_speed
	
	if enemy.current_closest_target:
		var direction = enemy.current_closest_target.global_position - enemy.global_position
		
		if direction.length() < enemy.follow_distance:
			if enemy.get_node("HealthSystem").is_at_low_health:
				RequestTransition.emit(self, "Escape")
			else:
				RequestTransition.emit(self, "Follow")
