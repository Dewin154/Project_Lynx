extends RayCast2D

#@onready var snail = get_parent()
var raycast_left = Vector2(-12,12)
var raycast_right = Vector2(12,12)

func flip_raycast(direction_right):
	if direction_right:
		set_position(raycast_right)
	else:
		set_position(raycast_left)
