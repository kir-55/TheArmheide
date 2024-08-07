extends Node

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

@export var villadge: Node

@export var big_rock: PackedScene

@export var tower_prefab: PackedScene
@export var main_house_prefab: PackedScene

@export var player: Node2D

@onready var line_offset = ground_line.width / 2 - 1

# Measured with LINE POINTS!
@export var village_start = 20
@export var village_end = 50
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
		var new_shape = CollisionShape2D.new()
		floor_collider.add_child(new_shape)
		var segment = SegmentShape2D.new()
		segment.a = points[i] - Vector2(0, line_offset)
		segment.b = points[i + 1] - Vector2(0, line_offset)
		new_shape.shape = segment
		
	sloper.spawn_at_point(big_rock, self, 3, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(big_rock, self, points_amount - 3, rs.get_rnd_float(0, 1))
	
	sloper.spawn_at_point(tower_prefab, villadge, village_start, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(tower_prefab, villadge, village_end, rs.get_rnd_float(0, 1))
	sloper.spawn_at_point(main_house_prefab, villadge, main_house_pos, rs.get_rnd_float(0, 1))

	
func create_next_point(position: Vector2):
	ground_line.add_point(position)
	grass_line.add_point(position)
