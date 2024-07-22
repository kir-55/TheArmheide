extends CharacterBody2D

const GRAVITY = 1000

func _physics_process(delta):
	if velocity.x > 0:
		$Sprite2D.flip_h = true
	elif velocity.x < 0:
		$Sprite2D.flip_h = false
	
	velocity.y += GRAVITY * delta
	move_and_slide()

func _process(delta: float) -> void:
	if is_on_floor():
		var normal : Vector2 = get_floor_normal()
		var offset : float = deg_to_rad(90)
		rotation = lerp_angle(rotation, get_floor_normal().angle() + deg_to_rad(90), 0.1)
