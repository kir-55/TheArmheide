extends CharacterBody2D

# State constants
const STATE_IDLE = 0
const STATE_WALK = 1
const STATE_ATTACK = 2

# Direction constants
const DIRECTION_LEFT = -1
const DIRECTION_RIGHT = 1

var normalSpeed = 200
var chaseSpeed = 600
var speed

const MASS = 50
const GRAVITY_SCALE = 1

var last_target

var state = STATE_WALK
var direction = DIRECTION_RIGHT
var motion = Vector2()
# Cached references
@onready var sprite = $Animator
@onready var rayCastFront = $RayCastFront
@onready var rayCastBack = $RayCastBack
@onready var rayCastGround = $RayCastGround
@onready var rayCastAttack = $RayCastAttack
@onready var timer = $Timer

func _ready():
	# Initialize sprite direction
	scale.x = direction
	speed = normalSpeed

func _physics_process(delta):
	motion.y = GRAVITY_SCALE * MASS
	handleMovement()
	
	
func _process(delta):	
	updateSpriteAnimation()

func handleMovement():
	motion.x = direction * speed
	#print("big speed: "  + str(speed))
	#print("dir: "  + str(direction))
	set_velocity(motion)
	move_and_slide()
	if state == STATE_WALK:
		# Check for obstacles or ground
		if not rayCastGround.is_colliding():
			changeDirection()
		elif rayCastFront.is_colliding():
			var collision = rayCastFront.get_collider()
			processCollision(collision, true)
		elif rayCastBack.is_colliding():
			print("back")
			var collision = rayCastBack.get_collider()
			processCollision(collision, false)
		else:
			normalizeSpeed()
			#print("state: " + str(state))
			#print("speed: " + str(speed))

func attack(target):
	if state != STATE_ATTACK:
		state = STATE_ATTACK
		speed = 0
		timer.start(0.5)
		last_target = target
	

func chase(target):
	if state != STATE_ATTACK:
		if rayCastAttack.is_colliding():
			attack(target)
			return
		
		if speed < chaseSpeed:
			if chaseSpeed - speed > 0.1:
				speed += (chaseSpeed - speed)/2
			else:
				speed = chaseSpeed
	

func normalizeSpeed():
	if speed > normalSpeed:
		
		if speed - normalSpeed > 0.1:
			speed -= (speed - normalSpeed)/2
		else:
			speed = normalSpeed
	elif speed < normalSpeed and state == STATE_WALK:
		
		if normalSpeed - speed > 20:
			speed += (normalSpeed - speed)/2
		else:
			speed = normalSpeed

func processCollision(collision, front):
	if collision.is_in_group("BoarTarget") and state == STATE_WALK:
		if not front:
			changeDirection()
		chase(collision)
	elif front:
		changeDirection()


func changeDirection():
	# Change direction and flip sprite
	direction *= -1
	sprite.scale.x  = sprite.scale.x * -1
	rayCastFront.scale.x = direction
	rayCastBack.scale.x = direction
	rayCastGround.scale.x = direction
	rayCastAttack.scale.x = direction

func updateSpriteAnimation():
	if state == STATE_IDLE:
		sprite.play("BoarIdle")
	elif state == STATE_WALK:
		sprite.play("BoarWalk")
	elif state == STATE_ATTACK:
		sprite.play("BoarAttack")



func _on_timer_timeout():
	timer.stop()
	#print("Вомбат")
	if state == STATE_ATTACK:
		var push = Vector2(direction, 0)
		last_target.set_velocity(push*1000)
		last_target.move_and_slide()
		state = STATE_WALK
