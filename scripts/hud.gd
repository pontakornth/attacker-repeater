extends CanvasLayer
@onready var score_text = %ScoreText
@onready var recording_text = %RecordingText
@onready var status_label = %StatusLabel
@onready var game_over_score_text = %GameOverScoreText
@onready var game_over_panel = $GameOverPanel
@onready var game_over_music = %GameOverMusic
@onready var title_panel = %TtitlePanel


signal try_again()

const Spell = SignalBus.Spell

const BOTTOM_TEXT_FORMAT = "SHURIKEN: %d, FIREBALLS: %d, SEEKER: %d, LOOPS: %d"

func _ready():
	SignalBus.record_start.connect(on_record_start)
	SignalBus.record_end.connect(on_record_end)
	SignalBus.start_game.connect(hide_title)
	SignalBus.game_over.connect(show_game_over_panel)

func _process(delta):
	score_text.text = "Score: %06d" % Globals.score
	game_over_score_text.text = score_text.text
	status_label.text = BOTTOM_TEXT_FORMAT % [
		Globals.attack_available[Spell.SHURIKEN],
		Globals.attack_available[Spell.FIRE],
		Globals.attack_available[Spell.SEEKER],
		Globals.loops_possible
	]
	
	
func on_record_start():
	recording_text.visible = true
	
func on_record_end(a, b):
	recording_text.visible = false

func show_game_over_panel():
	game_over_panel.show()
	game_over_music.play()

func hide_title():
	title_panel.hide()

func _on_try_again_button_pressed():
	try_again.emit()
	recording_text.hide()
	game_over_panel.hide()
	game_over_music.stop()

func _on_start_button_pressed():
	SignalBus.start_game.emit()
