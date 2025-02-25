class_name Snail
extends AbstractEnemies

var health = 30
var current_state
var damage

enum State {Moving, Dying}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	current_state = State.Moving

func _physics_process(delta: float) -> void:
	super(delta)
	move()
	play_animations()
	print(health)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "dying":
		queue_free()
	
func play_animations() -> void:
	if current_state == State.Moving:
		animated_sprite_2d.play("moving")
	elif current_state == State.Dying:
		animated_sprite_2d.play("dying")
		
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		current_state = State.Dying 
	
func move() -> void:
	if velocity.x >= -20 and current_state != State.Dying:
		velocity.x -= 0.5
	else:
		velocity.x = 0
		
