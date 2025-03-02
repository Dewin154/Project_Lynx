extends CollisionShape2D

@onready var player = get_parent().get_parent()

var vector_facing_left = Vector2(-23,-24)
var vector_facing_right = Vector2(27,-24)

# Flips hitbox based on players direction
# Because of Controller support, there need to be greater/less than signs
func flip_hitbox(direction):
	if direction < 0:
		set_position(vector_facing_left)
	elif direction > 0:
		set_position(vector_facing_right)
	
