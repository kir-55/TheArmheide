class_name VillagerAttack
extends State

@export var villager_ai: VillagerAI


@export var villager : CharacterBody2D
@export var move_speed := 200.0

@export var exhoustion_level: float = 2
#means how much energy does this state take per hour

var body

func Enter():
	villager.velocity.x = 0
	
func Update(delta: float):
	villager_ai.villager_data.exhaustion += delta*villager_ai.day_night_cycle.time_per_second/60*exhoustion_level


func Physics_Update(delta: float):
	if villager.is_on_floor() and (villager.raycast_follow.is_colliding() or villager.raycast_back.is_colliding()):
		if villager.get_node("HealthSystem").is_at_low_health:
			RequestTransition.emit(self, "Escape")
			return
		
		if villager.raycast_follow.is_colliding():
			body = villager.raycast_follow.get_collider()
		else:
			body = villager.raycast_back.get_collider()
		
		var distance_x = abs(body.global_position.x - villager.global_position.x)
		if distance_x > villager.attack_distance:
			RequestTransition.emit(self, "Follow")
	else:
		RequestTransition.emit(self, "Idle")
