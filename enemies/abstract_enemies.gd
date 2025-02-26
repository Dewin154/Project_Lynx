class_name AbstractEnemies
extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	falling(delta)
	move_and_slide()

func falling(delta: float):
	velocity.y += GRAVITY * delta

# Abstract function
func take_damage(_damage: int) -> void:
	push_error("Must be overridden in subclasses!")
