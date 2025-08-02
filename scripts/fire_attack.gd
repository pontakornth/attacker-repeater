extends CharacterBody2D
class_name FireAttack
@export var target: Node2D
@export var radius: float = 100
@export var clockwise: bool = true
@export_range(0, 360, 0.1, "radians_as_degrees") var angle_per_second :=  deg_to_rad(45)
@onready var attack = $Attack

var angle: float

func _ready():
	attack.attack_hit.connect(func(body): delete_attack())
	angle = (position - target.position).angle()

func _physics_process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	angle += angle_per_second * delta
	var offset = Vector2.from_angle(angle) * radius
	var destination = target.position + offset
	position = destination
	
func delete_attack():
	queue_free()

func _on_timer_timeout():
	delete_attack()
