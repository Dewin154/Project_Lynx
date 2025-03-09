class_name Bee
extends AbstractEnemies

enum State {Fly, Attack, Hit}

var health = 40



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	
# Must be overriden, otherwise gravity is applied to bee
func falling(delta: float) -> void:
	pass

# Controls the flying of the bee and as such the movement of the bee
func move(delta: float):
	pass
	
func take_damage(damage):
	pass

func play_animations() -> void:
	pass	
	
