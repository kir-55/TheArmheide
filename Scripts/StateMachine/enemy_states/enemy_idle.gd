class_name EnemyIdle
extends State


@export var enemy: CharacterBody2D
@export var move_speed := 120.0



var target : CharacterBody2D
var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3.5)

func Enter():
	print(self.name)
	randomize_wander()
	target = get_tree().get_first_node_in_group("willagers")

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy and enemy.is_on_floor():
		enemy.velocity = move_direction * move_speed
	
	var direction = target.global_position - enemy.global_position
	
	if direction.length() < 500:
		RequestTransition.emit(self, "Follow")
