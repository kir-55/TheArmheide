extends Area2D

@onready var menu = get_node("/root/Game/Camera2D/CanvasLayer/Menu")

func _on_body_entered(body):
	menu.open_popup()


func _on_body_exited(body):
	menu.close_popup()
	menu.close_menu()
