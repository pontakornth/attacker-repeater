extends Node

signal record_start()
signal record_end(actions: Array, origin: Vector2)
signal replay(position: Vector2)

enum Spell {
	FIRE,
	SHURIKEN,
	SEEKER
}

signal start_casting(spell: Spell)

# Actual summoning spell
signal start_spell(origin: Node2D, spell: Spell)

signal start_game()
signal game_over()

signal add_score(amount: int)
