extends Controller
class_name PlayerController
@export var player: Player


var time_since_last_record := 0.0
var current_direction := Vector2.ZERO
var record_origin := Vector2.ZERO
var is_recording := false
var can_record_actions := true

# Dictionary
var current_action = null

var actions: Array[Dictionary] = []

func _input(event):
	var record_pressed:bool = event.is_action_pressed("record")
	if not is_recording and record_pressed and can_record_actions and not player.is_control_locked:
		print("Record start")
		is_recording = true
		record_origin = Vector2(player.position)
		print(record_origin)
		# Start a new action
		# Player can only record their action when not casting a spell.
		current_action = {
			'type': 'move',
			'direction': current_direction,
			# We will add 
			'time': 0
		}
	elif is_recording and record_pressed and not player.is_control_locked:
		print("Record end")
		actions.append(current_action)
		record_origin = Vector2.ZERO
		time_since_last_record = 0
		is_recording = false
		SignalBus.record_end.emit(actions)
		print(actions)
	var replay_pressed: bool = event.is_action_pressed("replay")
	if replay_pressed and not actions.is_empty() and not is_recording:
		SignalBus.replay.emit(player.position)
		actions = []
		
	#region Spell
	# TODO: Handle recording and casting delay
	if event.is_action_pressed("spell_1") and not player.is_control_locked:
		cast_spell.emit(Spell.SHURIKEN)
		#SignalBus.start_spell.emit(get_parent(), Spell.SHURIKEN)
		if is_recording:
			# Flush
			actions.append(current_action)
			var new_action = {
				'type': 'spell',
				'spell': Spell.SHURIKEN,
				'time': 0
			}
			actions.append(new_action)
			current_action = {
				'type': 'move',
				'direction': Vector2.ZERO,
				'time': 0
			}
	#endregion

func _physics_process(delta):
	var prev_direction = current_direction
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x = 1
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("up"):
		direction.y = -1
	if Input.is_action_pressed("down"):
		direction.y = 1
	direction = direction.normalized()
	if player.is_control_locked:
		direction = Vector2.ZERO
	var changing_direction = not current_direction.is_equal_approx(direction)
	if changing_direction:
		current_direction = direction
	if is_recording:
		current_action['time'] += delta
		if changing_direction:
			# Change direction push recording
			actions.append(current_action)
			current_direction = direction
			current_action = {
				'type': 'move',
				'direction': current_direction,
				'time': 0
			}
	player.velocity = direction * player.speed
	player.move_and_slide()
