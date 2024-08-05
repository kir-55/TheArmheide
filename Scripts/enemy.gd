extends CharacterBody2D

const GRAVITY = 1000

@export var attack_manager: AttackManager

@export_category("Distances")
@export var follow_distance := 500
@export var attack_distance := 50

@onready var animation_player = $AnimationPlayer

var direction = 0
var current_closest_target

func _ready():
	$Timer.start()

func _physics_process(delta):
	if direction != 0:
		get_node("Flippable").scale.x = direction * -0.25
	
	if velocity.x > 0:
		direction = 1
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		direction = -1
		$Sprite2D.flip_h = false
	
	velocity.y += GRAVITY * delta
	move_and_slide()

func _process(delta: float) -> void:
	if is_on_floor():
		var normal := get_floor_normal()
		var offset := deg_to_rad(90)
		rotation = lerp_angle(rotation, get_floor_normal().angle() + offset, 0.1)


func _find_closest_target(): #this is a signal from a timer
	var targets = get_tree().get_nodes_in_group("villagers")
	
	if targets and targets.size() > 0:
		var min_dist = global_position.distance_to(targets[0].global_position)
		var min_target = targets[0] #min_dist and min_target set beforehand to avoid comparing null
		
		for target in targets:
			var dist = global_position.distance_to(target.global_position)
			if (dist < min_dist):
				min_dist = dist
				min_target = target
		current_closest_target = min_target

func run_attack_animation():
	animation_player.play("attack")

func die():
	print("enemy is dying")
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	print("finished: " + str(anim_name))
	
	if anim_name == "attack":
		attack_manager._on_attack_animation_finished()
