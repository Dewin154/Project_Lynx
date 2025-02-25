extends Area2D

@onready var player = get_parent()

func _on_body_entered(body: Node2D) -> void:
		if body is Snail:
			body.take_damage(10)
	
