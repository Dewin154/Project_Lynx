class_name Player
extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 300
const JUMP = -500
const BASE_HEALTH = 500
const BASE_STAMINA = 250
const STAMINA_REGEN_AMOUNT = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sword_hitbox_collison_shape: CollisionShape2D = $SwordHitbox/CollisionShape2D
@onready var healthbar: TextureProgressBar = $"../CanvasLayerPlayerHUD/Healthbar"
@onready var staminabar: TextureProgressBar = $"../CanvasLayerPlayerHUD/Staminabar"
@onready var stamina_refill_timer: Timer = $StaminaRefillTimer

enum State {Idle, Run, Jump, Fall, Attack, Dead}

var health = BASE_HEALTH
var stamina = BASE_STAMINA
var current_state
var last_state
var direction #-1,0,1
var light_attack = 50
var jump_animation_already_playing = false
var fall_animation_already_playing = false
var is_attacking = false
var attack_combo_available = false
var is_dying = false
var can_deal_damage = true
var coyote_available = false
var jump_buffer_available = false
var stamina_available = true
var start_stamina_refill = false

func _ready() -> void:
	current_state = State.Idle
	healthbar.value = health
	healthbar.max_value = health
	staminabar.value = stamina
	staminabar.max_value = stamina
	
func _process(delta: float) -> void:
	if start_stamina_refill:
		refill_stamina()
	
func _physics_process(delta: float) -> void:
	player_falling(delta)
	player_idle()
	player_run()
	player_jump(delta)
	player_attack()
	move_and_slide()
	player_animations()
	#print("State1: ", State.keys()[current_state])

# Signal to stop attacking animation after timeout
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack1":
		if attack_combo_available:
			animated_sprite_2d.play("attack2") # 1st Handling of attack2 Animation
			attack_combo_available = false
		else:
			is_attacking = false
	elif animated_sprite_2d.animation == "attack2":
		is_attacking = false

# Signal to disable the 2nd attack after timeout
func _on_attack_timer_timeout() -> void:
	attack_combo_available = false
	
# Signal to disable the availability of coyote time after timeout
func _on_coyote_timer_timeout() -> void:
	coyote_available = false
	
# Signal to disable the availability of jump buffer after timeout
func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer_available = false 

func _on_stamina_refill_timer_timeout() -> void:
	start_stamina_refill = true

# Handles falling and jump buffer with applying gravity to the player
func player_falling(delta):
	velocity.y += GRAVITY * delta
	
	if current_state == State.Fall and Input.is_action_just_pressed("jump"):
		jump_buffer_available = true
		jump_buffer_timer.start()
		
# Handles idling of the player
func player_idle():
	if is_on_floor() and !is_attacking and !is_dying:
		current_state = State.Idle
		fall_animation_already_playing = false
		jump_animation_already_playing = false

# Handles player running and flipping the sprite
func player_run() -> void:
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
		sword_hitbox_collison_shape.flip_hitbox(direction)
		animated_sprite_2d.flip_h = false if direction > 0 else true
		if current_state != State.Jump:
			current_state = State.Run

# Handles basic player animations based on current state
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

# Handles jumping, falling, coyote time and jump buffer
func player_jump(delta):
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_available) and !is_attacking:
		_jump()
		fall_animation_already_playing = false
	
	# Check if player ended jumping and is falling
	if velocity.y >= 0 and !is_on_floor():
		current_state = State.Fall
		if last_state == State.Run:
			coyote_available = true
			coyote_timer.start()
	
	if is_on_floor() and jump_buffer_available:
		_jump()
		jump_buffer_available = false
		
# Handles actual jump
func _jump():
	current_state = State.Jump
	velocity.y = JUMP
	
# Handles attacks of the player with animation
func player_attack():
	if Input.is_action_just_pressed("attack") and (current_state == State.Idle or current_state == State.Run or current_state == State.Attack) and stamina_available:
		can_deal_damage = true
		start_stamina_refill = false
		use_stamina(light_attack)
		stamina_refill_timer.start()
		if is_attacking and attack_combo_available:
			animated_sprite_2d.play("attack2") # 2nd Handling of attack2 Animation, redundancy? Otherwise it doesn't work
			attack_combo_available = false
		elif is_on_floor():
			animated_sprite_2d.play("attack1")
			attack_timer.start()
			current_state = State.Attack
			is_attacking = true
			attack_combo_available = true

#Handles player taking damage from enemies 
func player_take_damage(damage: float) -> void:
	health -= damage
	healthbar.value -= damage
	if health <= 0 and current_state != State.Dead:
		player_dead()

# Handles player dying with animation
func player_dead():
		is_dying = true
		current_state = State.Dead
		animated_sprite_2d.play("dead")

# Handles depleting stamina when player attacks
func use_stamina(amount: float) -> void:
	staminabar.value -= amount
	
	if staminabar.value <= 0:
		stamina_available = false

# Refills stamina gradually
func refill_stamina() -> void:
	if staminabar.value != staminabar.max_value:
		staminabar.value += STAMINA_REGEN_AMOUNT
		stamina_available = true
	else:
		start_stamina_refill = false
