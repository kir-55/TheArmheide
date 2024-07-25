extends Control

@export var menu_prefab: PackedScene

@onready var openMenuButton = $"VBoxContainer/Open Menu"
@onready var button = $VBoxContainer
@onready var camera_2d = get_node("/root/Game/Camera2D")

var menu_instance : Control

var interactive_building : Node2D

func close_popup():
	queue_free()

func open_popup():
	button.visible = true
	
func open_menu():
	interactive_building.player.stop()
	close_popup()
	menu_instance = menu_prefab.instantiate()
	menu_instance.interactive_building = interactive_building
	camera_2d.add_child(menu_instance)

func _on_open_menu_pressed():
	open_menu()
