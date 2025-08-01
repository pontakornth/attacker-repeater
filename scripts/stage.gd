extends Node2D
@export var original_player: Player
@export var player_scene: PackedScene

var current_actions = []

func _ready():
	SignalBus.record_end.connect(record_actions)
	SignalBus.replay.connect(spawn_clone_player)

func record_actions(actions: Array):
	current_actions = actions
	

func spawn_clone_player(spawn_position: Vector2):
	var cloned_player_node: Player = player_scene.instantiate()
	cloned_player_node.position = Vector2(spawn_position.x, spawn_position.y)
	add_child(cloned_player_node)
	cloned_player_node.sprite_2d.modulate = Color.RED
	var cpu_controller = CpuController.new()
	cpu_controller.actions = current_actions
	cpu_controller.player = cloned_player_node
	cpu_controller.origin = Vector2(spawn_position.x, spawn_position.y)
	cloned_player_node.add_child(cpu_controller)
