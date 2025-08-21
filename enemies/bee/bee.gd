class_name Bee
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var bee_hitbox: CollisionShape2D = $BeeHitbox2D
@onready var starting_position = position

@export var path_follow: PathFollow2D
@export var speed: float = 100.0

enum State {Fly, Attack, Hit}

var health = 40
var current_state


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = State.Fly
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if path_follow:
		# Move along the path
		path_follow.progress += speed * delta
		# Update bee position to match the path
		global_position = path_follow.global_position
