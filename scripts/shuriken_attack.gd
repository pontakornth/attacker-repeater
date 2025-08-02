extends CharacterBody2D
class_name ShurikenAttack
@export var speed := 300
@export var direction: Vector2 = Vector2.DOWN

@onready var normalized_direction := direction.normalized()

func _physics_process(delta):
	velocity = normalized_direction * speed
	move_and_slide()


func _on_timer_timeout():
	queue_free()
