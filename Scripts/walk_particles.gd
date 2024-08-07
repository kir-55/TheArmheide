extends CPUParticles2D


var parent: Node2D
func _ready():
	parent = get_parent()
	

func _process(delta):
	if parent.direction == 0:
		emitting = false
	else:
		emitting = true
