class_name Bee
extends AbstractEnemies

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum State {Fly, Attack, Hit}

var health = 40
var temp = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.flip_h = false if velocity.x > 0 else true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	
# Must be overriden, otherwise gravity is applied to bee
func falling(delta: float) -> void:
	pass

# Controls the flying of the bee and as such the movement of the bee
func move(delta: float):
	if velocity.x <= 25:
		velocity.x += 1
	temp = sin(position.x) + 150
	position.y = temp 
	
func take_damage(damage):
	pass

func play_animations() -> void:
	pass	
	
