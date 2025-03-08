class_name Snail
extends AbstractEnemies

var health = 30
var current_state
var is_protecting = false
var protecting_animation_already_playing = false
var leaving_protection_animation_already_playing = false
var direction_right = false

enum State {Moving, Dying, Protecting, Leaving_Protection}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var leave_protection_timer: Timer = $LeaveProtectionTimer
@onready var floor_raycast: RayCast2D = $FloorRayCast2D
@onready var healthbar: TextureProgressBar = $Healthbar

func _ready() -> void:
	current_state = State.Moving

func _physics_process(delta: float) -> void:
	super(delta)
	move()
	#print("State1: ", State.keys()[current_state])
	play_animations()
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "dying":
		queue_free()
	elif animated_sprite_2d.animation == "leaving_protection":
		current_state = State.Moving
		leaving_protection_animation_already_playing = false

func _on_leave_protection_timer_timeout() -> void:
	current_state = State.Leaving_Protection
	protecting_animation_already_playing = false

func play_animations() -> void:
	animated_sprite_2d.flip_h = direction_right
	if current_state == State.Moving:
		animated_sprite_2d.play("moving")
	elif current_state == State.Dying:
		animated_sprite_2d.play("dying")
	elif current_state == State.Protecting and !protecting_animation_already_playing:
		animated_sprite_2d.play("protect")
		protecting_animation_already_playing = true
	elif current_state == State.Leaving_Protection and !leaving_protection_animation_already_playing:
		animated_sprite_2d.play("leaving_protection")
		leaving_protection_animation_already_playing = true
		is_protecting = false
		
func take_damage(damage: int) -> void:
	Input.start_joy_vibration(0,0.5,0.5,0.3) # Controller vibration for some haptic feedback
	if !is_protecting:
		health -= damage
		healthbar.value -= damage
	protecting_itself() # Indent or Unindent for different behaviour
	if health <= 0:
		current_state = State.Dying
		
func protecting_itself() -> void:
	current_state = State.Protecting
	is_protecting = true
	leaving_protection_animation_already_playing = false
	leave_protection_timer.start()
	
func move() -> void:
	if current_state not in [State.Dying, State.Protecting]:
		if direction_right and velocity.x <= 30:
			velocity.x += 0.5
		elif not direction_right and velocity.x >= -30:
			velocity.x -= 0.5
			
	if current_state == State.Protecting or current_state == State.Dying:
		velocity.x = 0
	
	if !floor_raycast.is_colliding():
		velocity.x = 0
		direction_right = !direction_right
		floor_raycast.flip_raycast(direction_right)

	
