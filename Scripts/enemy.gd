extends CharacterBody2D

const GRAVITY = 100

var current_closest_target

func _ready():
	$Timer.start()

func _physics_process(delta):
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
	
	velocity.y += GRAVITY * delta
	move_and_slide()

func _process(delta: float) -> void:
	if is_on_floor():
		var normal := get_floor_normal()
		var offset := deg_to_rad(90)
		rotation = lerp_angle(rotation, get_floor_normal().angle() + deg_to_rad(90), 0.1)


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
