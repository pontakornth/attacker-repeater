extends CharacterBody2D
@export var speed := 500
@onready var enemies_seeking_area = $EnemiesSeekingArea

var is_seeking := false
var destination := Vector2.ZERO

func _physics_process(delta):
	if not is_seeking:
		return
	if position.distance_squared_to(destination) < 10:
		seek_new_target()
		return
	velocity = position.direction_to(destination) * speed
	move_and_slide()
	


func _on_seeking_timer_timeout():
	seek_new_target()

func seek_new_target():
	var detected_enemies = enemies_seeking_area.get_overlapping_bodies()
	if detected_enemies.is_empty():
		is_seeking = false
		return
	var selected_enemy: Node2D = detected_enemies.pick_random()
	is_seeking = true
	destination = selected_enemy.position

func _on_death_timer_timeout():
	queue_free()
