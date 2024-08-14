extends CharacterBody2D

const GRAVITY = 1000
var direction = 0

@export var attack_manager: AttackManager
@export var raycast_follow : RayCast2D
@export var raycast_back : RayCast2D
@export var default_speed := 250

@export_category("Distances")
@export var attack_distance := 50

@onready var animation_player = $AnimationPlayer
@onready var flippable = get_node("Flippable")

func _physics_process(delta):
	if velocity.x > 0:
		direction = 1
	elif velocity.x < 0:
		direction = -1
	else:
		direction = 0
		
	if direction != 0:
		flippable.scale.x = direction * -0.25
	
	velocity.y += GRAVITY * delta
	
	move_and_slide()

func run_attack_animation():
	animation_player.play("attack")

func die():
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack" and is_instance_valid(attack_manager):
		attack_manager._on_attack_animation_finished()
		print("villager attack finished: " + str(attack_manager.enemies_near.size()))
