extends Node

@export var light_occuluder: LightOccluder2D
@export var ground_line: Line2D
@export var grass_line: Line2D
@export var floor_collider: StaticBody2D

@export var rs: RandomSystem
@export var sloper: Sloper

@export var points_amount := 100

# x distance between points
@export var line_section_length = 300
@export var section_y_change_amplitude = 200

@export var decorations: Array[Decoration]



@export var big_rock: PackedScene

@export var tower_prefab: PackedScene
@export var main_house_prefab: PackedScene

@export var player: Node2D

@onready var line_offset = ground_line.width / 2 - 1



# Measured with LINE POINTS!
@export_category("Village")
@export var village: Node2D
@export var village_start = 20
@export var village_end = 50
@export var normal_house_prefab: PackedScene
@onready var main_house_pos: int = village_start + (village_end - village_start)/2

func _ready():
	for decoration in decorations:
		print(decoration.chance_to_spawn)
		
	create_next_point(Vector2.ZERO)
	points_amount -= 1
	
	for i in range(points_amount):
		if i % 2 == 1:
			create_next_point(ground_line.get_point_position(i) + Vector2(line_section_length, rs.get_rnd_float(-section_y_change_amplitude, section_y_change_amplitude)))
		else:
			create_next_point(ground_line.get_point_position(i) + Vector2(line_section_length, 0))
	
	
	
	var points = ground_line.points
	for i in points.size() - 1:
		light_occuluder.occluder.polygon.append(points[i])
		#light_occuluder.occluder.polygon.append(points[i] - Vector2(0, line_offset))
		
		var new_shape = CollisionShape2D.new()
		floor_collider.add_child(new_shape)
		var segment = SegmentShape2D.new()
		segment.a = points[i] - Vector2(0, line_offset)
		segment.b = points[i + 1] - Vector2(0, line_offset)
		new_shape.shape = segment
		
	var poligon_points = points
	poligon_points.append(points[points.size()-1] - Vector2(0, line_offset - 300))
	poligon_points.append(points[0] - Vector2(0, line_offset - 300))
	
	light_occuluder.occluder.polygon = poligon_points
	
	print("occluder: " + str(light_occuluder.occluder.polygon[1]))
	sloper.spawn_at_point(big_rock, self, 3, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(big_rock, self, points_amount - 3, rs.get_rnd_float(0, 1))
	
	sloper.spawn_at_point(tower_prefab, village, village_start, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(tower_prefab, village, village_end, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(main_house_prefab, village, main_house_pos, rs.get_rnd_float(0, 1))

func generate_houses(amount: int, start_family := 0):
	var houses = []
	for i in range(amount):
		var house_instance = sloper.spawn_at_point(normal_house_prefab, village, rs.get_rnd_int(village_start, village_end), rs.get_rnd_float(0, 1))
		house_instance.family = start_family + i
		houses.append(house_instance)
	return houses
		

func create_next_point(position: Vector2):
	ground_line.add_point(position)
	grass_line.add_point(position)
