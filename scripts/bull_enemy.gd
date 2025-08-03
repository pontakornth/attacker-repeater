extends CharacterBody2D
@export var speed := 150
@export var score := 10

var player_node: Node2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func _ready():
	#print(get_tree().get_nodes_in_group("enemies"))
	player_node = get_tree().get_first_node_in_group("playable")
	#print(player_node)
	if (player_node == null):
		print("Cannot find playable node")

func _physics_process(delta):
	if player_node == null: return
	if position.distance_squared_to(player_node.position) < 10:
		return
	velocity = position.direction_to(player_node.position) * speed
	move_and_slide()
	pass

func _on_damageable_on_death():
	SignalBus.add_score.emit(score)
	audio_stream_player_2d.play()
	queue_free()
