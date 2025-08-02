extends CharacterBody2D
class_name ShurikenAttack
@export var speed := 300
@export var direction: Vector2 = Vector2.DOWN

@onready var normalized_direction := direction.normalized()
@onready var attack = $Attack

func _physics_process(delta):
	velocity = normalized_direction * speed
	move_and_slide()
	attack.attack_hit.connect(func(body): queue_free())

func _on_timer_timeout():
	queue_free()
