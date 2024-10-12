class_name VillagerIdle
extends State


@export var villager: CharacterBody2D
@export var move_speed := 170.0
@export var follow_state_transition_chance := 0.65

@onready var day_night_cycle = get_node("/root/Game/DayNightCycle")

var move_direction : int
var wander_time : float

func _ready():
	day_night_cycle.connect("night_started", go_to_sleep)

func randomize_wander():
	move_direction = randi_range(-1, 1)
	wander_time = randf_range(1, 3.5)
	if move_direction == 0:
		wander_time = randf_range(0.7, 2)

func Enter():
	print(self.name, villager.name)
	randomize_wander()
	

func go_to_sleep():
	RequestTransition.emit(self, "Return")

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func Physics_Update(delta: float):
	if villager and villager.is_on_floor():
		if villager.is_on_wall():
			print("villager's touching the wall")
			move_direction *= -1
			villager.velocity.x = move_direction * move_speed
			return
		
		villager.velocity.x = move_direction * move_speed
		
	if villager.raycast_follow.is_colliding() or villager.raycast_back.is_colliding():
		if villager.get_node("HealthSystem").is_at_low_health:
			RequestTransition.emit(self, "Escape")
			return
		
		if randf_range(0, 1) <= follow_state_transition_chance:
			print("tak")
			RequestTransition.emit(self, "Follow")
		else:
			print("nie")
			RequestTransition.emit(self, "Escape")
