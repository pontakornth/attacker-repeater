extends Node2D
@export var original_player: Player
@export var player_scene: PackedScene
@export var enemies_amount := 50
@onready var health_bar = $MainPlayer/HealthBar

# Attacks
const FIRE_ATTACK = preload("res://scenes/fire_attack.tscn")
const SHURIKEN_ATTACK = preload("res://scenes/shuriken_attack.tscn")
const SEEKER_ATTACK = preload("res://scenes/seeker_attack.tscn")

# Enemies
const BULL_ENEMY = preload("res://scenes/bull_enemy.tscn")
const SNAKE_ENEMY = preload("res://scenes/snake_enemy.tscn")
const NINJA_ENEMY = preload("res://scenes/ninja_enemy.tscn")

var current_actions = []
const Spell = SignalBus.Spell

const SHURIKEN_DIRECTIONS = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP + Vector2.RIGHT,
	Vector2.DOWN + Vector2.RIGHT,
	Vector2.UP + Vector2.LEFT,
	Vector2.DOWN + Vector2.LEFT
]

func _ready():
	SignalBus.record_end.connect(record_actions)
	SignalBus.replay.connect(spawn_clone_player)
	SignalBus.start_spell.connect(spawn_spell)
	SignalBus.add_score.connect(add_score)
	

func record_actions(actions: Array, origin):
	current_actions = actions
	

func spawn_clone_player(spawn_position: Vector2):
	var cloned_player_node: Player = player_scene.instantiate()
	cloned_player_node.position = Vector2(spawn_position.x, spawn_position.y)
	var cpu_controller = CpuController.new()
	cpu_controller.loops = Globals.loops_possible
	Globals.loops_possible = 3
	cpu_controller.actions = current_actions
	cpu_controller.player = cloned_player_node
	cpu_controller.origin = Vector2(spawn_position.x, spawn_position.y)
	cloned_player_node.add_child(cpu_controller)
	add_child(cloned_player_node)
	cloned_player_node.sprite_2d.modulate = Color.WHITE
	cloned_player_node.sprite_2d.modulate.a = 0.5

func spawn_spell(origin: Node2D, spell: SignalBus.Spell):
	match spell:
		Spell.FIRE:
			spawn_fireballs(origin)
		Spell.SHURIKEN:
			spawn_shuriken(origin)
		Spell.SEEKER:
			spawn_seeker(origin)
			

func spawn_shuriken(origin: Node2D):
	for direction in SHURIKEN_DIRECTIONS:
		var shuriken = SHURIKEN_ATTACK.instantiate()
		shuriken.direction = direction
		shuriken.position = origin.position
		add_child(shuriken)

const FIREBALL_COUNT := 8

func spawn_fireballs(origin: Node2D):
	for i in FIREBALL_COUNT:
		var fireball := FIRE_ATTACK.instantiate()
		var spawn_offset: Vector2 = Vector2.RIGHT * fireball.radius
		var spawn_location: Vector2 = origin.position + Vector2.RIGHT * fireball.radius
		var rotation_angle := ((2*PI) / FIREBALL_COUNT) * i
		spawn_offset = spawn_offset.rotated(rotation_angle)
		fireball.position = origin.position + spawn_offset
		fireball.target = origin
		add_child(fireball)

func spawn_seeker(origin: Node2D):
	var seeker := SEEKER_ATTACK.instantiate()
	seeker.position = origin.position
	add_child(seeker)

func add_score(amount: int):
	Globals.score += amount


func _on_shuriken_timer_timeout():
	if Globals.attack_available[Spell.SHURIKEN] < 5:
		Globals.attack_available[Spell.SHURIKEN] += 1


func _on_fireballs_timer_timeout():
	if Globals.attack_available[Spell.FIRE] < 5:
		Globals.attack_available[Spell.FIRE] += 1



func _on_seeker_timer_timeout():
	if Globals.attack_available[Spell.SEEKER] < 5:
		Globals.attack_available[Spell.SEEKER] += 1


func _on_loop_timer_timeout():
	Globals.loops_possible += 1


var spawn_distance := 500
func _on_enemies_timer_timeout():
	var player_location = original_player.position
	for i in range(enemies_amount):
		var spawn_angle = randf_range(0, 2 * PI)
		var spawn_offset = Vector2.UP.rotated(spawn_angle) * spawn_distance
		var rng_result = randf()
		var spawn_scene: PackedScene
		if rng_result <= 0.7:
			spawn_scene = BULL_ENEMY
		elif rng_result <= 0.8:
			spawn_scene = SNAKE_ENEMY
		else:
			spawn_scene = NINJA_ENEMY
		var spawn_node = spawn_scene.instantiate()
		spawn_node.position = original_player.position + spawn_offset
		add_child(spawn_node) # Replace with function body.
	enemies_amount += randi_range(-10, 80)


func _on_damageable_on_health_changed(new_health):
	health_bar.value = new_health
