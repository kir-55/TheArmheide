extends Camera2D

@export var target: Node
@export var max_distance: Vector2
var distance_to_target: Vector2



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance_to_target.x = abs(position.x - target.position.x)
	distance_to_target.y = abs(position.y - target.position.y)
	
	if distance_to_target.x > max_distance.x:
		position.x = lerp(position.x, target.position.x, delta)
	
	if distance_to_target.y > max_distance.y:
		position.y = lerp(position.y, target.position.y, delta)
