extends Node

signal died(body)

@export var sprite: Sprite2D
@export var max_HP: float = 20
var HP: float


func _ready():
	HP = max_HP
	pass


func take_damage(damage):
	if HP - damage <= 0:
		died.emit(get_parent())
		get_parent().die()
		
	HP -= damage
	sprite.self_modulate = Color(1, HP/max_HP, HP/max_HP, 1)
	

func heal(value):
	if HP == max_HP:
		return
	
	sprite.self_modulate = Color(1, HP/max_HP, HP/max_HP, 1)
	if HP + value > max_HP:
		HP = max_HP
	else:
		HP += value
