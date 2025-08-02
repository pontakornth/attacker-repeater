extends CharacterBody2D
@export var speed := 150

var player_node: Node2D

func _ready():
	player_node = get_tree().get_first_node_in_group("playable")

func _physics_process(delta):
	if player_node == null: return
	if position.distance_squared_to(player_node.position) < 10:
		return
	velocity = position.direction_to(player_node.position) * speed
	move_and_slide()
	pass

func _on_damageable_on_death():
	queue_free()
