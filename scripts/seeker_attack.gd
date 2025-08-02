extends CharacterBody2D
@export var speed := 500
@onready var enemies_seeking_area = $EnemiesSeekingArea

var is_seeking := false
var destination := Vector2.ZERO

func _physics_process(delta):
	if not is_seeking:
		return
	move_and_slide()
	pass


func _on_seeking_timer_timeout():
	var detected_enemies = enemies_seeking_area.get_overlapping_bodies()
	if detected_enemies.is_empty():
		is_seeking = false
		return
	var selected_enemy: Node2D = detected_enemies.pick_random()
	destination = selected_enemy.position


func _on_death_timer_timeout():
	queue_free()
