extends RigidBody2D
var rng = RandomNumberGenerator.new()
var hp = 5;
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(400000,800000)).rotated(rng.randf_range(0.0,PI*2)))

func hurt():
	hp -= 1;
	if hp == 0:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
