extends CharacterBody2D

const GRAVITY = 1000


var direction = 0
var current_closest_target: Node2D

@export var attack_manager: AttackManager

@export_category("Distances")
@export var follow_distance := 500
@export var attack_distance := 50

@onready var animation_player = $AnimationPlayer



func _physics_process(delta):
	if velocity.x > 0:
		direction = 1
	elif velocity.x < 0:
		direction = -1
		
	if direction != 0:
		get_node("Flippable").scale.x = direction * -0.25
	
	velocity.y += GRAVITY * delta
	move_and_slide()


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
	queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack" and is_instance_valid(attack_manager):
		attack_manager._on_attack_animation_finished()
