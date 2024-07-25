extends Node

var display_health = true
var hp_bar
var hp = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	#hp_bar = get_node("/root/Game/Camera2D/HPBar")
	#hp_bar.text ="HP: " + str(hp) 
	pass

func takeDamage(damage):
	hp -= damage
	
	#if hp <= 0:
		#hp_bar.text = "DEAD"
	#else:
		#hp_bar.text ="HP: " + str(hp) 
	
func heal(value):
	hp += value
