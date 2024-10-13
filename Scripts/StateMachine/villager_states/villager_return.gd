class_name VillagerReturn
extends State



@export var villager_ai: VillagerAI

@export var villager : CharacterBody2D
@export var move_speed := 270.0

@onready var day_night_cycle = get_node("/root/Game/DayNightCycle")

@export var regeneration_level = 2

@export var timer: Timer

func _ready():
	day_night_cycle.connect("day_started", start_wakeup)
	timer.connect("timeout", wakeup)

func start_wakeup():
	var random = RandomNumberGenerator.new()
	timer.start(random.randf()*4)
	
	
func wakeup():
	villager.visible = true
	RequestTransition.emit(self, "Idle")

func Update(delta: float):
	if villager_ai.villager_data.exhaustion > 0:
		villager_ai.villager_data.exhaustion -= delta*villager_ai.day_night_cycle.time_per_second/60*regeneration_level
	
func Physics_Update(delta: float):
	var destination = villager.villager_data.house.global_position
	if destination.x - villager.global_position.x > 5:
		villager.direction = 1
	elif destination.x - villager.global_position.x < -5:
		villager.direction = -1
	else:
		villager.visible = false
		villager.direction = 0
	
	villager.velocity.x = move_speed * villager.direction
