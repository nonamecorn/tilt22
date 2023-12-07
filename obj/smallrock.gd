extends RigidBody2D
var rng = RandomNumberGenerator.new()
var hp = 3;
var bullet_obj = preload("res://obj/medium_rock.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = rng.randi_range(0,3)
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(100000,300000)).rotated(rng.randf_range(0.0,PI*2)))
	apply_torque(rng.randi_range(3000,6000))

func hurt():
	hp -= 1;
	if hp == 0:
		queue_free()
func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
