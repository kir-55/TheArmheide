extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}



func _ready():
	load_states()
	


func _process(delta):
	if current_state and is_instance_valid(current_state):
		current_state.Update(delta)

func _physics_process(delta):
	if current_state and is_instance_valid(current_state):
			current_state.Physics_Update(delta)
			
func load_states():
	var signals = get_signal_list();
	for child in get_children():
		if child is State:
			var already_added:= false
			for state in states:
				if state == child.name.to_lower():
					already_added = true
					break
			
			if !already_added or child is Job:
				states[child.name.to_lower()] = child
				child.RequestTransition.connect(on_child_transition)
				print("connected: "+ child.name)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state
