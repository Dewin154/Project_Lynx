class_name Bee
extends AbstractEnemies

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reverse_movement_timer: Timer = $ReverseMovementTimer
var fly_forward = false
var fly_velocity = 25 

enum State {Fly, Attack, Hit}

var health = 40
var temp = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.x = -fly_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	
func _on_reverse_movement_timer_timeout() -> void:
	fly_forward = !fly_forward
	if fly_forward:
		velocity.x = fly_velocity
	else:
		velocity.x = -fly_velocity
	animated_sprite_2d.flip_h = true if velocity.x > 0 else false

# Must be overriden, otherwise gravity is applied to bee
func falling(delta: float) -> void:
	pass

# Controls the flying of the bee and as such the movement of the bee
func move(delta: float):
	temp = sin(position.x) + 150
	position.y = temp

func take_damage(damage):
	pass

func play_animations() -> void:
	pass	
	
