class_name AttackManager
extends Node


### In order to use this class: 
### 1. Node should be a child of the enetity
### 2. Entity script should have function run_attack_animation()
### 3. Entity animation should call _on_attack_finished()

var enemies_near : Array[Node2D]


var last_time_attacked := 0 # In miliseconds
var is_attacking := false

@export var should_prepare_for_attack := false

@export var enemy_group := "enemies"

@export var trigger_area: Area2D



func _ready():
	trigger_area.body_entered.connect(_on_body_entered)
	trigger_area.body_exited.connect(_on_body_exited)


func _process(delta):
	#if ready_to_attack and  Time.get_ticks_msec() - last_time_attacked > chill_out_delay:
		#ready_to_attack = false
		
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


func prepare_for_attack():
	last_time_attacked = Time.get_ticks_msec()
	get_parent().run_prepare_animation()

func attack():
	get_parent().run_attack_animation()
	is_attacking = true

func _on_attack_finished():
	for enemy in enemies_near:
		enemy.get_node("HealthSystem").take_damage(20)
		
	last_time_attacked = Time.get_ticks_msec()
	

func _on_attack_animation_finished():
	print("attack finished, enemies near: " + str(enemies_near.size()))
	is_attacking = false
