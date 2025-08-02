extends CharacterBody2D
class_name FireAttack
@export var target: Node2D
@export var radius: float = 100
@export var clockwise: bool = true
@export_range(0, 360, 0.1, "radians_as_degrees") var angle_per_second :=  deg_to_rad(45)

func _physics_process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	var direction_to_target := position.direction_to(target.position)
	var direction_to_move: Vector2
	if clockwise:
		direction_to_move = direction_to_target.rotated(0.5 * PI)
	else:
		direction_to_move = direction_to_target.rotated(-0.5 * PI)
	var linear_velocity = angle_per_second * direction_to_move * radius
	velocity = linear_velocity * delta
	move_and_slide()
