extends CharacterBody2D
@export var speed := 60
@export var teleport_in_radius := 400
@export var teleport_out_radius := 300
@export var score := 75
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


var target: Node2D

func _ready():
	target = get_tree().get_first_node_in_group("playable")
	
func _physics_process(delta):
	if target == null:
		return
	var distance_squared_to_target = target.position.distance_squared_to(position)
	if distance_squared_to_target < 2:
		teleport_to_target(teleport_out_radius)
		return
	if distance_squared_to_target > teleport_in_radius ** 2:
		teleport_to_target(teleport_in_radius)
		return
	velocity = position.direction_to(target.position) * speed
	move_and_slide()
	

func teleport_to_target(radius: float):
	var random_angle = randf_range(0, 2 * PI)
	var offset = Vector2.UP.rotated(random_angle) * radius
	var teleport_target = target.position  + offset
	position = teleport_target

func _on_damageable_on_death():
	audio_stream_player_2d.play()
	SignalBus.add_score.emit(score)
	queue_free()
