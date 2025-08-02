extends Node
class_name Damageable
@export var max_health := 20
@export var health := max_health
@export var invincible_time := 0.2

var is_invincible := false

signal on_death()
signal on_health_changed(new_health: int)
signal on_invincible_start()
signal on_invincible_end()

func change_health(amount: int):
	if is_invincible and amount < 0:
		return
	health += amount
	health = clamp(health, 0, max_health)
	if amount < 0:
		start_invincible()
	_check_alive()
	on_health_changed.emit(health)
	
func start_invincible():
	is_invincible = true
	on_invincible_start.emit()
	get_tree().create_timer(invincible_time).timeout.connect(end_invincible)
	
func end_invincible():
	is_invincible = false
	on_invincible_end.emit()
	
func _check_alive():
	if health <= 0:
		on_death.emit()
