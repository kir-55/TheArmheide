extends Area2D

@export var popup_prefab: PackedScene
@export var menu_prefab: PackedScene

@onready var camera_2d = get_node("/root/Game/Camera2D")

var popup_instance : Control
var player : Node2D
var is_collision_handled := false

func spawn_popup():
	popup_instance = popup_prefab.instantiate()
	popup_instance.menu_prefab = menu_prefab
	popup_instance.interactive_building = self
	camera_2d.add_child(popup_instance)
	is_collision_handled = true

func _on_body_entered(body):
	player = body
	spawn_popup()
	
func _on_body_exited(body):
	player = null
	if popup_instance and is_instance_valid(popup_instance) and !popup_instance.is_queued_for_deletion():
		popup_instance.queue_free()
		is_collision_handled = true
		
func _process(delta):
	if player and !is_collision_handled:
		spawn_popup()
