extends Node
class_name IFrameAlpha
@export var node_to_adjust: CanvasItem
@export var damageable: Damageable
@export var alpha_value := 0.5

var previous_value

func _ready():
	previous_value = node_to_adjust.modulate.a
	damageable.on_invincible_start.connect(set_alpha)
	damageable.on_invincible_end.connect(unset_alpha)

func set_alpha():
	node_to_adjust.modulate.a = alpha_value

func unset_alpha():
	node_to_adjust.modulate.a = previous_value
