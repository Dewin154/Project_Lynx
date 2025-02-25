extends Area2D

@onready var player = get_parent()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		activate_hitbox()

func activate_hitbox():
	for body in get_overlapping_bodies():
		if body is Snail:
			body.take_damage(10)
