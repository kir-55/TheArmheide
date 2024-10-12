extends Node


signal day_started
signal night_started

@export var light: DirectionalLight2D
@export var background: Sprite2D

@export_color_no_alpha var night_color: Color
@export_color_no_alpha var day_color: Color

@export_category("given in hours") 
@export_range(0, 24) var start_time: float = 12

var time: float
var day: int = 0

var is_day: bool

@export_category("given in minutes") 
@export var time_per_second: float = false


# Called when the node enters the scene tree for the first time.
func _ready():
	time = start_time
	is_day = true if start_time >= 9 and start_time <= 21 else false
	light.energy = 0 if is_day else 1
	background.self_modulate = day_color if is_day else night_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_day:
		light.energy = lerpf(light.energy, 0, 0.05)
		background.self_modulate = Color(lerpf(background.self_modulate.r,day_color.r, 0.01),
										 lerpf(background.self_modulate.g,day_color.g, 0.01),
										 lerpf(background.self_modulate.b,day_color.b,0.01))
	elif !is_day:
		light.energy = lerpf(light.energy, 1, 0.05)
		background.self_modulate = Color(lerpf(background.self_modulate.r,night_color.r, 0.01),
										 lerpf(background.self_modulate.g,night_color.g, 0.01),
										 lerpf(background.self_modulate.b,night_color.b, 0.01))




func _on_timer_timeout():
	if time + time_per_second/60 > 24:
		time = time + time_per_second/60 - 24
		day += 1 
	else:
		time += time_per_second/60 
		
	if time >= 9 and time <= 21 and !is_day: 
		is_day = true
		emit_signal("day_started")
	elif (time < 9 or time > 21) and is_day:
		is_day = false
		emit_signal("night_started")

	print("time: " + str(time) + " is day?: " + str(is_day))
	print("energy: " + str(light.energy))
