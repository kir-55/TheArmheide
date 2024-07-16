extends Control

@onready var openMenuButton = $"VBoxContainer/Open Menu"
@onready var mainHouseMenu = $"Main House Menu"
@onready var button = $VBoxContainer

func _ready():
	close_popup()
	close_menu()
	
func close_popup():
	button.visible = false
	
func close_menu():
	mainHouseMenu.visible = false
	
func open_popup():
	button.visible = true
	
func open_menu():
	close_popup()
	mainHouseMenu.visible = true

func _on_open_menu_pressed():
	open_menu()
