extends Node

@export var ground_line: Line2D
@export var grass_line: Line2D
@export var floor_collider: StaticBody2D

@export var rs: RandomSystem

@export var points_amount := 100

# x distance between points
@export var points_distance = 300

@export var grass_prefab: PackedScene
@export var decorations: Array[Decoration]

@export var willadge: Node

@export var tower_prefab: PackedScene
@export var main_house_prefab: PackedScene

@export var player: Node2D

@export var grass_spawn_range := 20.0

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
			create_next_point(ground_line.get_point_position(i) + Vector2(points_distance, rs.get_rnd_float(-100, 100)))
		else:
			create_next_point(ground_line.get_point_position(i) + Vector2(points_distance, 0))
		
		var p1 = ground_line.get_point_position(i)
		var p2 = ground_line.get_point_position(i + 1)
		
		var a = (p2.y - p1.y) / (p2.x - p1.x)
		var b = -a * p2.x + p2.y
		
		var distance = p2 - p1
		var grass_per_line := rs.get_rnd_int(1, 5)
		

		if i == village_start or i == village_end:
			var tower = tower_prefab.instantiate()
			var x = rs.get_rnd_float(p1.x, p2.x)
			
			tower.position = Vector2(x, x * a + b - line_offset)
			tower.rotation = distance.angle()
			
			willadge.add_child(tower)
		
		if i == main_house_pos:
			var main_house = main_house_prefab.instantiate()
			var x = rs.get_rnd_float(p1.x, p2.x)
			
			main_house.position = Vector2(x, x * a + b - line_offset)
			main_house.rotation = distance.angle()
			
			willadge.add_child(main_house)
		
		
		for decoration in decorations:
			if decoration and decoration.prefab:
				var rnd_i = rs.get_rnd_int(0, 100)
				if decoration.initial_chance > rnd_i:
					for _i in range(decoration.chance_multiplyer):
						var rnd = rs.get_rnd_int(0, 100)
					
						if decoration.chance_to_spawn > rnd:
							var decoration_instance = decoration.prefab.instantiate()
							
							var x = rs.get_rnd_float(p1.x, p2.x)
							decoration_instance.position = Vector2(x, x * a + b - line_offset)
							decoration_instance.rotation = distance.angle()
							if decoration.min_scale != 0 and decoration.max_scale != 0:
								var scale = rs.get_rnd_float(decoration.min_scale, decoration.max_scale)
								decoration_instance.scale = Vector2(scale, scale)
							#decoration_instance.player = player
							
							add_child(decoration_instance)

	var points = ground_line.points
	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		floor_collider.add_child(new_shape)
		var segment = SegmentShape2D.new()
		segment.a = points[i] - Vector2(0, line_offset)
		segment.b = points[i + 1] - Vector2(0, line_offset)
		new_shape.shape = segment



	
func create_next_point(position: Vector2):
	ground_line.add_point(position)
	grass_line.add_point(position)
