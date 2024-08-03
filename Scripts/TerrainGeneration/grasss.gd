extends Sprite2D


@export var max_angle := 30.0
@export var max_distance := 20
@export var rotation_speed := 0.1

var moving: Array[Node2D]

func _ready():
	for obj in get_tree().get_nodes_in_group("villagers"):
		moving.append(obj)
	for obj in get_tree().get_nodes_in_group("enemies"):
		moving.append(obj)
		
	print("xd")

func _process(delta):
	if moving:
		for obj in moving:
			var diff_x = obj.position.x - global_position.x
			if diff_x >= 0 and diff_x < max_distance and rotation > -deg_to_rad(max_angle):
				rotation = lerp_angle(rotation, rotation - deg_to_rad(max_angle), rotation_speed)
			elif diff_x < 0 and diff_x > -max_distance and rotation < deg_to_rad(max_angle):
				rotation = lerp_angle(rotation, rotation + deg_to_rad(max_angle), rotation_speed)
			
