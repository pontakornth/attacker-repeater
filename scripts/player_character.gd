extends CharacterBody2D
class_name Player

@export var speed := 200
@export var is_clone := false
# TODO: Change to animated sprite or use the one with animation player
@onready var sprite_2d = $Sprite2D
@onready var spell_cast_timer = $SpellCastTimer

@export var is_control_locked := false

const Spell = SignalBus.Spell

func _ready():
	for child in get_children():
		# Assume one controller
		if child is Controller:
			child.cast_spell.connect(cast_spell)

func cast_spell(spell: Spell):
	spell_cast_timer.start()
	is_control_locked = true
	SignalBus.start_spell.emit(self, spell)


func _on_spell_cast_timer_timeout():
	is_control_locked = false
