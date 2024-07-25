extends Node2D

#@export var arrow: Node
var arrow = preload("res://Scenes/arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_released("shoot"):
		print("sigma is present")
		var arrow_instance = arrow.instantiate()
		get_node("/root/Game").add_child(arrow_instance)
		arrow_instance.position = global_position
		arrow_instance.look_at(get_global_mouse_position())
		arrow_instance.rotate(90)                     
		#get_node("/root/Game/Arrow").position = position
