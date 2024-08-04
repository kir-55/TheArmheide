extends Node

var line_start_x: float
var line_section_length: int

@export var rs: RandomSystem

@export var player: Node2D

@export var line: Line2D
@export var terrain_generator: Node2D

var current_point: int

@export var decorations: Array[Decoration]

func _ready():
	line_start_x = line.global_position.x
	line_section_length = terrain_generator.line_section_length

func _process(delta):
	var x = player.position.x
	var closest_point = (x - line_start_x)/line_section_length
	if  !current_point or int(closest_point) != current_point:
		spawn_decoration(int(closest_point))
		current_point = int(closest_point)
		

func spawn_decoration(point):
	print("spawning")
	
	var line_global = line.global_position
	var p1 = line.get_point_position(point) + line_global
	var p2 = line.get_point_position(point + 1) + line_global
	
	var a = (p2.y - p1.y) / (p2.x - p1.x)
	var b = -a * p2.x + p2.y
	
	var distance = p2 - p1
	
	var i := 0
	for decoration in decorations:
		if decoration and decoration.prefab:
			
			var rnd_i = rs.get_rnd_int_at(0, 100, rs.main_seed + "mult" + str(i)+str(point))
			if decoration.initial_chance > rnd_i:
				for _i in range(decoration.chance_multiplyer):
					var rnd = rs.get_rnd_int_at(0, 100, rs.main_seed + "init" + str(_i) + str(i) + str(point))
					if decoration.chance_to_spawn > rnd:
						
						var decoration_instance = decoration.prefab.instantiate()
						print("p1.x: " + str(p1.x))
						var x = rs.get_rnd_float_at(p1.x, p2.x, rs.main_seed + "x" + str(_i) + str(i) + str(point))
						decoration_instance.position = Vector2(x, x * a + b - terrain_generator.line_offset)
						decoration_instance.rotation = distance.angle()
						if decoration.min_scale != 0 and decoration.max_scale != 0:
							var scale = rs.get_rnd_float(decoration.min_scale, decoration.max_scale)
							decoration_instance.scale = Vector2(scale, scale)
						#decoration_instance.player = player
						
						add_child(decoration_instance)
			i += 1
