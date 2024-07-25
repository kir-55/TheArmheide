class_name EnemyFollow
extends State

@export var enemy : CharacterBody2D
@export var move_speed := 120.0

var target : CharacterBody2D

func Enter():
	target = get_tree().get_first_node_in_group("Willagers")


func Physics_Update(delta: float):
	print(self.name)
	
	if enemy.is_on_floor():
		var direction = target.global_position - enemy.global_position
		
		if direction.length() < 500:
			enemy.velocity = direction.normalized() * move_speed
		else:
			enemy.velocity = Vector2()
		
		if direction.length() > 500:
			RequestTransition.emit(self, "Idle")
