extends BasicObject

class_name Part

@export var worth: int

func _ready():
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(100000,300000)).rotated(rng.randf_range(0.0,PI*2)))
	apply_torque(rng.randi_range(3000,6000))
