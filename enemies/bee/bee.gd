class_name Bee
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $Path2D/PathFollow2D/Area2D/AnimatedSprite2D
@onready var path_follow := $Path2D/PathFollow2D

enum State {Fly, Attack, Hit}

var speed = 100.0
var health = 40
var current_state
var last_x = 0
var current_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = State.Fly
	pass

# TODO Optimize this since it checks every frame!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_x = path_follow.global_position.x
	path_follow.progress += speed * delta
	animated_sprite_2d.flip_h = false if current_x < last_x else true
	last_x = current_x
	
