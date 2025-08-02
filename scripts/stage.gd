extends Node2D
@export var original_player: Player
@export var player_scene: PackedScene

const FIRE_ATTACK = preload("res://scenes/fire_attack.tscn")
const SHURIKEN_ATTACK = preload("res://scenes/shuriken_attack.tscn")
var current_actions = []
const Spell = SignalBus.Spell

const SHURIKEN_DIRECTIONS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT
]

func _ready():
	SignalBus.record_end.connect(record_actions)
	SignalBus.replay.connect(spawn_clone_player)
	SignalBus.start_spell.connect(spawn_spell)
	

func record_actions(actions: Array):
	current_actions = actions
	

func spawn_clone_player(spawn_position: Vector2):
	var cloned_player_node: Player = player_scene.instantiate()
	cloned_player_node.position = Vector2(spawn_position.x, spawn_position.y)
	var cpu_controller = CpuController.new()
	cloned_player_node.add_child(cpu_controller)
	add_child(cloned_player_node)
	cloned_player_node.sprite_2d.modulate = Color.RED
	cpu_controller.actions = current_actions
	cpu_controller.player = cloned_player_node
	cpu_controller.origin = Vector2(spawn_position.x, spawn_position.y)
	cloned_player_node.add_child(cpu_controller)

func spawn_spell(origin: Node2D, spell: SignalBus.Spell):
	match spell:
		Spell.FIRE:
			spawn_fireballs(origin)
		Spell.SHURIKEN:
			spawn_shuriken(origin)
			
func spawn_fireballs(origin: Node2D):
	pass

func spawn_shuriken(origin: Node2D):
	print("Spawning shuriken")
	for direction in SHURIKEN_DIRECTIONS:
		var shuriken = SHURIKEN_ATTACK.instantiate()
		shuriken.direction = direction
		shuriken.position = origin.position
		add_child(shuriken)
