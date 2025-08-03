extends CharacterBody2D
class_name Player

@export var speed := 200
@export var is_clone := false
@onready var sprite_2d = $Sprite2D
@onready var spell_cast_timer = $SpellCastTimer
@onready var shuriken_audio = $ShurikenAudio
@onready var fire_audio = $FireAudio
@onready var seeker_audio = $SeekerAudio


@export var is_control_locked := false

const Spell = SignalBus.Spell

func _ready():
	for child in get_children():
		# Assume one controller
		if child is Controller:
			child.cast_spell.connect(cast_spell)
		if child is Damageable:
			print("Playable = damageable")
			#child.on_invincible_start.connect(set_alpha)
			#child.on_invincible_end.connect(set_not_alpha)
			child.on_death.connect(on_death)

func cast_spell(spell: Spell):
	spell_cast_timer.start()
	sprite_2d.play("cast")
	is_control_locked = true
	match spell:
		Spell.FIRE:
			fire_audio.play()
		Spell.SHURIKEN:
			shuriken_audio.play()
		Spell.SEEKER:
			seeker_audio.play()
	SignalBus.start_spell.emit(self, spell)

func set_alpha():
	modulate.a = 0.5

func set_not_alpha():
	modulate.a = 1
	
func on_death():
	SignalBus.game_over.emit()
	# Cheap way to use nothing
	#process_mode = Node.PROCESS_MODE_DISABLED

func _on_spell_cast_timer_timeout():
	sprite_2d.play("default")
	is_control_locked = false
