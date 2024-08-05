class_name AttackManager
extends Node


### In order to use this class: 
### 1. Node should be a child of the enetity
### 2. Entity script should have function run_attack_animation()
### 3. Entity animation should call _on_attack_finished()

var enemies_near : Array[Node2D]

var ready_to_attack = false
var last_time_attacked := 0 # In miliseconds



@export var enemy_group := "enemies"

@export var trigger_area: Area2D

@export var chill_out_delay := 4000 # In miliseconds

func _ready():
	trigger_area.body_entered.connect(_on_body_entered)
	trigger_area.body_exited.connect(_on_body_exited)


func _process(delta):
	if ready_to_attack and  Time.get_ticks_msec() - last_time_attacked > chill_out_delay:
		ready_to_attack = false


func _on_body_entered(body):
	print(body.get_groups())
	if body and body.is_in_group(enemy_group):
		enemies_near.append(body)
	if enemies_near.size() > 0 and !ready_to_attack:
		prepare_for_attack()


func _on_body_exited(body):
	if body and body.is_in_group(enemy_group):
		enemies_near.erase(body)


func prepare_for_attack():
	ready_to_attack = true
	last_time_attacked = Time.get_ticks_msec()
	attack()


func attack():
	get_parent().run_attack_animation()
	

func _on_attack_finished():
	for enemy in enemies_near:
		enemy.get_node("HealthSystem").take_damage(20)
		
	last_time_attacked = Time.get_ticks_msec()
	

func _on_attack_animation_finished():
	if enemies_near.size() > 0:
		attack()
