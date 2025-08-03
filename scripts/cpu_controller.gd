extends Controller
class_name CpuController
@export var actions = []
@export var loops := 3
@export var player: Player

var origin := Vector2.ZERO
var running_sequence = []
var current_action = null
var current_time_left = 0

func _ready():
	running_sequence = actions.duplicate()

func _physics_process(delta):
	if loops <= 0 and current_action == null and running_sequence.is_empty():
		print("no more action")
		get_parent().queue_free()
		return
	if current_action:
		perform_action(current_action, delta)
	elif not running_sequence.is_empty():
		current_action = running_sequence.pop_front()
		current_time_left = current_action['time']
		perform_action(current_action, delta)
	current_time_left -= delta
	if current_time_left <= 0:
		current_action = null
	player.move_and_slide()
	if running_sequence.is_empty():
		loops -= 1
		if loops > 0:
			player.position = origin
			running_sequence = actions.duplicate()
	if loops <= 0 and current_action == null and running_sequence.is_empty():
		get_parent().queue_free()
		return

func perform_action(action, delta):
	match action['type']:
		'move':
			player.velocity = action['direction'] * player.speed
		'spell':
			cast_spell.emit(action['spell'])
