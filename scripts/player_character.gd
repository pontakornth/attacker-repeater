extends CharacterBody2D
class_name Player
@export var speed := 200
@export var is_clone := false
# TODO: Change to animated sprite or use the one with animation player
@onready var sprite_2d = $Sprite2D
