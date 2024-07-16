extends Line2D

@export var rs: RandomSystem

@export var points_amount := 100

# x distance between points
@export var points_distance = 300

@export var grass_prefab: PackedScene
@export var tower_prefab: PackedScene
@export var main_house_prefab: PackedScene

@export var player: Node2D

@export var grass_spawn_range := 20.0

@onready var line_offset = width / 2 - 1




# Measured with LINE POINTS!
@export var village_start = 20
@export var village_end = 50
@onready var main_house_pos: int = village_start + (village_end - village_start)/2


func _ready():
	add_point(Vector2.ZERO)
	points_amount -= 1
	
	for i in range(points_amount):
		if i % 2 == 1:
			add_point(get_point_position(i) + Vector2(points_distance, rs.get_rnd_float(-100, 100)))
		else:
			add_point(get_point_position(i) + Vector2(points_distance, 0))
		
		var p1 = get_point_position(i)
		var p2 = get_point_position(i + 1)
		
		var a = (p2.y - p1.y) / (p2.x - p1.x)
		var b = -a * p2.x + p2.y
		
		var distance = p2 - p1
		var grass_per_line := rs.get_rnd_int(1, 5)
		

		if i == village_start or i == village_end:
			var tower = tower_prefab.instantiate()
			var x = rs.get_rnd_float(p1.x, p2.x)
			
			tower.position = Vector2(x, x * a + b - line_offset)
			tower.rotation = distance.angle()
			
			add_child(tower)
		
		if i == main_house_pos:
			var main_house = main_house_prefab.instantiate()
			var x = rs.get_rnd_float(p1.x, p2.x)
			
			main_house.position = Vector2(x, x * a + b - line_offset)
			main_house.rotation = distance.angle()
			
			add_child(main_house)
		
		
		for g in range(grass_per_line):
			var grass = grass_prefab.instantiate()

			var x = randf_range(p1.x, p2.x)
			grass.position = Vector2(x, x * a + b - line_offset)
			grass.rotation = distance.angle()
			grass.player = player

			add_child(grass)

	for i in points.size() - 1:
		var new_shape = CollisionShape2D.new()
		$StaticBody2D.add_child(new_shape)
		var segment = SegmentShape2D.new()
		segment.a = points[i] - Vector2(0, line_offset)
		segment.b = points[i + 1] - Vector2(0, line_offset)
		new_shape.shape = segment

