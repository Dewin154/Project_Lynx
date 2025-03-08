class_name AbstractEnemies
extends CharacterBody2D

const GRAVITY: int = 1000
const SPEED: int = 300

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	falling(delta)
	move_and_slide()

# All enemies inherit gravity from this abstract class
func falling(delta: float):
	velocity.y += GRAVITY * delta

# Abstract function
func take_damage(_damage: int) -> void:
	push_error("take_damage() must be overridden in subclasses!")
	
# Abstract function
func move() -> void:
	push_error("move() must be overridden in subclasses!")

# Abstract function
func play_animations() -> void:
	push_error("play_animations() must be overridden in subclasses!")
	
