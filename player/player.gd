extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300
const JUMP = -500
const JUMP_HORIZONTAL = 100
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum State {Idle, Run, Jump, Fall}

var current_state
var direction
var jump_animation_already_playing = false
var fall_animation_already_playing = false

func _ready() -> void:
	current_state = State.Idle
	
func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	move_and_slide()
	player_animations()
	#print("State: ", State.keys()[current_state])
	
func player_falling(delta):
	velocity.y += GRAVITY*delta
	
func player_idle(delta):
	if is_on_floor():
		current_state = State.Idle
		fall_animation_already_playing = false
		jump_animation_already_playing = false
		
func player_run(delta):
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction != 0 and current_state != State.Jump:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump and !jump_animation_already_playing:
		animated_sprite_2d.play("jump")
		jump_animation_already_playing = true
	elif current_state == State.Fall and !fall_animation_already_playing: 
		animated_sprite_2d.play("fall")
		fall_animation_already_playing = true
			
func player_jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		current_state = State.Jump
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += direction * JUMP_HORIZONTAL * delta
	# Check if player ended jumping and is falling
	if velocity.y >= 0 and !is_on_floor():
		current_state = State.Fall
