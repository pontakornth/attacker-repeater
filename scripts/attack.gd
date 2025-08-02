extends Area2D
class_name Attack
@export var amount := 1

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	for child in body.get_children():
		# Determine attacker and receiver based on
		# collision layer.
		if child is Damageable:
			child.change_health(-amount)
