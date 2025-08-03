extends Node

var score := 0
var loops_possible := 3
var replay_time := 5
var time_left := 100

const Spell = SignalBus.Spell

# Spell counts
var attack_available = {
	Spell.FIRE: 1,
	Spell.SHURIKEN: 1,
	Spell.SEEKER: 0
}

func reset_variables():
	score = 0
	loops_possible = 3
	replay_time = 5
	time_left = 100
	attack_available = {
		Spell.FIRE: 1,
		Spell.SHURIKEN: 1,
		Spell.SEEKER: 0
	}
