extends RigidBody2D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	apply_force(Vector2(0,rng.randi_range(700000,1200000)).rotated(rng.randf_range(0.0,PI*2)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
