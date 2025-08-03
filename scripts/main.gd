extends Node2D
@onready var hud = $HUD
@onready var stage = $Stage

const STAGE = preload("res://scenes/stage.tscn")

func _ready():
	SignalBus.game_over.connect(game_over)
	SignalBus.start_game.connect(start_game)

func game_over():
	get_tree().paused = true

func restart():
	get_tree().paused = false
	for child in stage.get_children():
		child.queue_free()
	stage.queue_free()
	# Required as queue does not immediately remove nodes
	await get_tree().process_frame
	Globals.reset_variables()
	var new_stage = STAGE.instantiate()
	stage = new_stage
	add_child(new_stage)
	
func start_game():
	# Beginning only
	stage.process_mode = Node.PROCESS_MODE_INHERIT

func _on_hud_try_again():
	restart()
