extends CollisionShape2D

@onready var player = get_parent().get_parent()

var vector_facing_left = Vector2(-23,-24)
var vector_facing_right = Vector2(27,-24)

func flip_hitbox():
	if player.animated_sprite_2d.flip_h:
		set_position(vector_facing_left)
	else:
		set_position(vector_facing_right)
# Called every Frame, Signal would be better for Performance
func _process(delta: float) -> void:
	flip_hitbox()
