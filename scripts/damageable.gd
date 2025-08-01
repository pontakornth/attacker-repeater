extends Node
@export var max_health := 20
@export var health := max_health

signal on_death()
signal on_health_changed(new_health: int)

func change_health(amount: int):
	health += amount
	health = clamp(health, 0, max_health)
	_check_alive()
	on_health_changed.emit(health)
	
func _check_alive():
	if health <= 0:
		on_death.emit()
