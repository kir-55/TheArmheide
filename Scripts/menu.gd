extends Node

var interactive_building : Node2D

func _unhandled_input(event):
	interactive_building.is_collision_handled = false
	queue_free()
