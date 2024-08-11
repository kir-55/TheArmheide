class_name AttackManager
extends Node


### In order to use this class: 
### 1. Node should be a child of the enetity
### 2. Entity script should have function run_attack_animation()
### 3. Entity animation should call _on_attack_finished()

var enemies_near : Array[Node2D]


var last_time_attacked := 0 # In miliseconds
var is_attacking := false

@export var damage := 20.0

@export var should_prepare_for_attack := false

@export var enemy_group := "enemies"

@export var trigger_area: Area2D



func _ready():
	trigger_area.body_entered.connect(_on_body_entered)
	trigger_area.body_exited.connect(_on_body_exited)


func _process(delta):
	if enemies_near.size() > 0 and !is_attacking:
		if !should_prepare_for_attack or (should_prepare_for_attack and get_parent().ready_to_attack):
			attack()
		elif should_prepare_for_attack:
			get_parent().preparation_requested = true
		
func _on_body_entered(body):
	if body and body.is_in_group(enemy_group):
		enemies_near.append(body)
	print("enemies near:" + str(enemies_near.size()))	

func _on_body_exited(body):
	if body and body.is_in_group(enemy_group):
		enemies_near.erase(body)
	print("enemies near:" + str(enemies_near.size()))	


func attack():
	get_parent().run_attack_animation()
	is_attacking = true

func _on_attack_finished():
	for enemy in enemies_near:
		enemy.get_node("HealthSystem").take_damage(damage)
		
	last_time_attacked = Time.get_ticks_msec()
	

func _on_attack_animation_finished():
	is_attacking = false
