extends CharacterBody2D

const SPEED = 300
const GRAVITY = 1000
const JUMP_STRENGTH = 700

var motion = Vector2()
var direction = 0

var run_endless = false
var destination_x: float = 0.0



var ready_to_attack = false
var last_time_attacked := 0 # In miliseconds

@export var chill_out_delay := 4000 # In miliseconds

@export var animation_transitions_speed := 0.3 # In range 0-1
@onready var animation_tree = $"AnimationTree"

var last_floor_normal = Vector2.UP

func _ready():
	destination_x = position.x

func _physics_process(delta):
	if direction != 0:
		get_node("Flippable").scale.x = direction * -0.25
	if !run_endless:
		if destination_x - global_position.x > 5:
			direction = 1
		elif destination_x - global_position.x < -5:
			direction = -1
		else:
			direction = 0

	motion.y += delta * GRAVITY
	motion.x = SPEED * direction
	set_velocity(motion)
	move_and_slide()
	motion = velocity

	if is_on_floor():
		var floor_normal = get_floor_normal()
		last_floor_normal = floor_normal
		rotation = lerp_angle(rotation, floor_normal.angle() + deg_to_rad(90), 0.1)
	else:
		last_floor_normal = Vector2.UP  # Reset to default if not on floor

func _process(delta):
	if ready_to_attack and  Time.get_ticks_msec() - last_time_attacked > chill_out_delay:
		ready_to_attack = false
	elif ready_to_attack:
		animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), -1.0, animation_transitions_speed))
		
		
	
	if direction == 0:
		if !ready_to_attack:
			animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), 0.0, animation_transitions_speed))
		animation_tree.set("parameters/walking_legs/blend_amount", lerp(animation_tree.get("parameters/walking_legs/blend_amount"), 0.0, animation_transitions_speed))
	else:
		# Setting animation to walk
		if !ready_to_attack:
			animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), 1.0, animation_transitions_speed))
		animation_tree.set("parameters/walking_legs/blend_amount", lerp(animation_tree.get("parameters/walking_legs/blend_amount"), 1.0, animation_transitions_speed))
	

func prepare_for_attack():
	ready_to_attack = true
	last_time_attacked = Time.get_ticks_msec()
	



func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if event.double_click:
				run_endless = true
			else:
				destination_x = get_global_mouse_position().x
				run_endless = false
		
		
func stop():
	direction = 0
	run_endless = false
	destination_x = position.x



func _on_area_2d_body_entered(body):
	print("some body enetered")
	if body.is_in_group("enemies"):
		prepare_for_attack()
