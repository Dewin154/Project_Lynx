extends Area2D

@onready var player = get_parent()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and player.can_deal_damage:
		activate_hitbox()

func activate_hitbox():
	for body in get_overlapping_bodies():
		if body is Snail:
			body.take_damage(10)
	player.can_deal_damage = false
