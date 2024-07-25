extends CharacterBody2D
@onready var collision_shape_2d = $CollisionShape2D

var speed = 1000
const GRAVITY = 1000
const air_resistance = 20
var angle_change = 0.02

var in_flight := true

var motion = Vector2()
#var gravity = 500
#var maxLifetime = 5
#var lifetime = maxLifetime
#
func _ready():
	## Apply initial force to the arrow in the direction it's facing
	#apply_impulse(Vector2(1, -1).normalized() * speed)
	print("I'm present too")
	pass
func _physics_process(delta):
	motion = Vector2(0, -1).rotated(rotation) * speed
	if speed - 2 >= 0 and in_flight:
		speed -= 2
	else:
		speed = 0
	set_velocity(motion)
	move_and_slide()
	motion = velocity
	
	var probable_roatation = rotation + angle_change
	if(abs(probable_roatation) <= 180 and in_flight):
		if rotation > 0:
			rotation += angle_change
		else:
			rotation -= angle_change
			
		
	if is_on_floor() or is_on_wall():
		in_flight = false
