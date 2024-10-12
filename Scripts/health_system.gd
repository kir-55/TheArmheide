extends Node

signal died(body)

@onready var day_night_cycle = get_node("/root/Game/DayNightCycle")

@export var sprite: Node2D
@export var blood_particles: PackedScene

@export var max_HP: float = 20
@export var low_health := 20

@export_range(0, 100) var dayly_regen_percent:= 20

var have_regened = true

var HP: float
var is_at_low_health := false


func _ready():
	HP = max_HP
	day_night_cycle.connect("day_started", heal,dayly_regen_percent/100 * max_HP)
	


func take_damage(damage):
	if HP > 0:
		if blood_particles:
			var particle_instance = blood_particles.instantiate()
			particle_instance.position = get_parent().global_position
			particle_instance.emitting = true
			get_node("/root/Game").add_child(particle_instance)
			
		if HP - damage <= 0:
			died.emit(get_parent())
			get_parent().die()
			
		HP -= damage
		if HP <= low_health:
			is_at_low_health = true
		else: 
			is_at_low_health = false
		sprite.modulate = Color(1, HP/max_HP, HP/max_HP, 1)
	

func heal(value):
	if HP == max_HP:
		return
	
	
	if HP + value > max_HP:
		HP = max_HP
	else:
		HP += value
	
	if HP > low_health:
		is_at_low_health = true
		
	sprite.self_modulate = Color(1, HP/max_HP, HP/max_HP, 1)
	print("healed")
