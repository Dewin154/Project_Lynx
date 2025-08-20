class_name Bee
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D 
@onready var path_follow := $Path2D/PathFollow2D
@onready var starting_position = position
@onready var bee_hitbox: CollisionShape2D = $BeeHitbox2D
enum State {Fly, Attack, Hit}

var speed = 100.0
var health = 40
var last_x = 0
var direction
var current_state
var current_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = State.Fly
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fly(delta)
	
# TODO: could be simplified if Bee is made a child of PathFollow2D
# TODO: Optimize this since it checks every frame!
func fly(delta: float) -> void:
	current_x = path_follow.global_position.x
	path_follow.progress += speed * delta
	position = starting_position + path_follow.position
	
	if current_x < last_x:
		animated_sprite_2d.flip_h = false
		bee_hitbox.rotation = -48
	else: 
		animated_sprite_2d.flip_h = true
		bee_hitbox.rotation = 48
	last_x = current_x
