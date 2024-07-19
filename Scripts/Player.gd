extends CharacterBody2D

const SPEED = 300
const GRAVITY = 1000
const JUMP_STRENGTH = 700

var motion = Vector2()
var direction = 0
var jump_pressed = false
var run_endless = false

var destination_x: float = 0.0

@export var is_in_air = true

@onready var animation = $AnimationPlayer

var last_floor_normal = Vector2.UP

func _ready():
	pass

func _physics_process(delta):
	if direction != 0:
		get_node("Sprite2D").scale.x = direction * 0.25
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

	if is_on_floor() and !jump_pressed:
		is_in_air = false

func _process(delta):
	if direction != 0 and !jump_pressed and !is_in_air:
		animation.play("PlayerWalk")
	elif !jump_pressed and !is_in_air:
		animation.play("PlayerIdle")
	elif is_on_floor() and jump_pressed:
		jump()
	elif is_in_air:
		if motion.y > 0:
			animation.play("PlayerFall")
		else:
			animation.play("PlayerJump")
	elif !is_on_floor() or get_floor_normal().angle() > deg_to_rad(100) or get_floor_normal().angle() < deg_to_rad(-80):
		animation.play("PlayerFly")

func _unhandled_input(event):
	print("cos")
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

func jump():
	motion.y = -JUMP_STRENGTH
	is_in_air = true
