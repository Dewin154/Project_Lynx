class_name Player
extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300
const JUMP = -500
const JUMP_HORIZONTAL = 100

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var coyote_timer: Timer = $CoyoteTimer

enum State {Idle, Run, Jump, Fall, Attack, Dead}

var current_state
var last_state
var direction
var jump_animation_already_playing = false
var fall_animation_already_playing = false
var is_attacking = false
var attack_combo_available = false
var is_dying = false
var can_deal_damage = true
var coyote_available = false

func _ready() -> void:
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_attack(delta)
	player_dead(delta) 
	move_and_slide()
	player_animations()
	#print("State1: ", State.keys()[last_state])
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack1" or animated_sprite_2d.animation == "attack2":
		is_attacking = false
		can_deal_damage = true
	
func _on_attack_timer_timeout() -> void:
	attack_combo_available = false
	
func _on_coyote_timer_timeout() -> void:
	coyote_available = false
	
func player_falling(delta):
	velocity.y += GRAVITY * delta
	
func player_idle(delta):
	if is_on_floor() and !is_attacking and !is_dying:
		current_state = State.Idle
		fall_animation_already_playing = false
		jump_animation_already_playing = false

func player_run(delta):
	last_state = current_state
	if is_attacking:
		velocity.x = 0
		return
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		is_dying = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction != 0:
		animated_sprite_2d.flip_h = false if direction > 0 else true
		if current_state != State.Jump:
			current_state = State.Run

func player_animations():
	if !is_attacking and !is_dying:
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
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_available) and !is_attacking:
		_jump()
	if !is_on_floor() and current_state == State.Jump:
		velocity.x += direction * JUMP_HORIZONTAL * delta
	# Check if player ended jumping and is falling
	if velocity.y >= 0 and !is_on_floor():
		current_state = State.Fall
		if last_state == State.Run:
			coyote_available = true
			coyote_timer.start()
	
func _jump():
	current_state = State.Jump
	velocity.y = JUMP

func player_attack(delta):
	if Input.is_action_just_pressed("attack"):
		can_deal_damage = true
		if is_attacking and attack_combo_available:
			animated_sprite_2d.play("attack2")
			attack_combo_available = false
		elif is_on_floor():
			current_state = State.Attack
			is_attacking = true
			animated_sprite_2d.play("attack1")
			attack_combo_available = true
			attack_timer.start()
	
func player_dead(delta):
	# Numpad 9
	if Input.is_action_just_pressed("die"):
		is_dying = true
		current_state = State.Dead
		animated_sprite_2d.play("dead")
