extends CharacterBody2D



const WALK_SPEED = 300
const RUN_SPEED = 400
const GRAVITY = 5000

var speed

var motion = Vector2()
var direction = 0

var run = false
var destination_x: float = 0.0

var floor_normal = Vector2.UP
var closest_point: int

var ready_to_attack := false
var preparation_requested := false


@export var attack_manager: AttackManager
@export var chill_out_delay := 4000 # In miliseconds

@export var animation_transitions_speed := 0.3 # In range 0-1
@onready var animation_tree = $AnimationTree



func _ready():
	destination_x = position.x


func _physics_process(delta):
	if direction != 0:
		get_node("Flippable").scale.x = direction * -0.25
	if !run:
		speed = WALK_SPEED
		if destination_x - global_position.x > 5:
			direction = 1
		elif destination_x - global_position.x < -5:
			direction = -1
		else:
			direction = 0
	else:
		speed = RUN_SPEED

	motion.y += delta * GRAVITY
	motion.x = speed * direction
	set_velocity(motion)
	move_and_slide()
	motion = velocity

func _process(delta):
	if !attack_manager.is_attacking:
		if preparation_requested:
			animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), -1.0, animation_transitions_speed))		
			
			if animation_tree.get("parameters/arms_state/blend_amount") < -0.99:
				animation_tree.set("parameters/arms_state/blend_amount", -1.0)
		
		if ready_to_attack and Time.get_ticks_msec() - attack_manager.last_time_attacked > chill_out_delay:
			ready_to_attack = false
		elif !ready_to_attack and animation_tree.get("parameters/arms_state/blend_amount") == -1.0:
			ready_to_attack = true
			preparation_requested = false
	
	if direction == 0:
		# Setting idle animation
		if !ready_to_attack and !preparation_requested:
			animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), 0.0, animation_transitions_speed))
		animation_tree.set("parameters/walking_legs/blend_amount", lerp(animation_tree.get("parameters/walking_legs/blend_amount"), 0.0, animation_transitions_speed))
	else:
		# Setting walk animation
		if !ready_to_attack and !preparation_requested:
			if run:
				animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), 1.0, animation_transitions_speed))
			else:
				animation_tree.set("parameters/arms_state/blend_amount", lerp(animation_tree.get("parameters/arms_state/blend_amount"), 0.5, animation_transitions_speed))
		
		if run:
			animation_tree.set("parameters/walking_legs/blend_amount", lerp(animation_tree.get("parameters/walking_legs/blend_amount"), 1.0, animation_transitions_speed))
		else: 
			animation_tree.set("parameters/walking_legs/blend_amount", lerp(animation_tree.get("parameters/walking_legs/blend_amount"), 0.7, animation_transitions_speed))
			



func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			if event.double_click:
				run = true
			else:
				destination_x = get_global_mouse_position().x
				run = false
		

func run_attack_animation():
	animation_tree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func stop():
	direction = 0
	run = false
	destination_x = position.x

func die():
	pass

func _on_animation_tree_animation_finished(anim_name):
	print("finished: " + str(anim_name))
	
	if anim_name == "attack":
		attack_manager._on_attack_animation_finished()
