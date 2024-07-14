extends Line2D

@export var points_amount := 10

@export var grass_prefab: PackedScene

@export var temp_tower_prefab: PackedScene

@export var player: Node2D

@export var grass_spawn_range := 20.0

@onready var line_offset = width / 2 - 1


# Called when the node enters the scene tree for the first time.
func _ready():
	add_point(Vector2.ZERO)
	print(position)
	points_amount -= 1
	for i in range(points_amount):
		if i % 2 == 1:
			add_point(get_point_position(i) + Vector2(300, randi() % 200 - 100))
		else:
			add_point(get_point_position(i) + Vector2(300, 0))

		var grass_per_line := int(randi() % 5 + 2)

		if i == 10:
			var tower = temp_tower_prefab.instantiate()
			var p1 = get_point_position(i)
			var p2 = get_point_position(i + 1)

			var a = (p2.y - p1.y) / (p2.x - p1.x)
			var b = -a * p2.x + p2.y

			var x = randf_range(p1.x, p2.x)
			tower.position = Vector2(x, x * a + b - line_offset)

			var distance = p2 - p1
			tower.rotation = distance.angle()
			add_child(tower)

		for g in range(grass_per_line):
			var grass = grass_prefab.instantiate()
			var p1 = get_point_position(i)
			var p2 = get_point_position(i + 1)

			var a = (p2.y - p1.y) / (p2.x - p1.x)
			var b = -a * p2.x + p2.y

			var x = randf_range(p1.x, p2.x)
			grass.position = Vector2(x, x * a + b - line_offset)

			var distance = p2 - p1
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

