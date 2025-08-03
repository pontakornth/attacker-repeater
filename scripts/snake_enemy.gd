extends CharacterBody2D
@export var speed := 150
@export var score := 25
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var target: Node2D = null

func _physics_process(delta):
	if target == null:
		return
	if not is_instance_valid(target):
		seek_new_target()
	if position.distance_squared_to(target.position) < 10: return
	velocity = position.direction_to(target.position) * speed
	move_and_slide()
	
func seek_new_target():
	var new_target = get_tree().get_nodes_in_group("players").pick_random()
	if target == new_target:
		new_target = get_tree().get_nodes_in_group("players").pick_random()
	target = new_target

func _on_timer_timeout():
	# Seek new target
	seek_new_target()


func _on_damageable_on_death():
	SignalBus.add_score.emit(score)
	audio_stream_player_2d.play()
	queue_free()
