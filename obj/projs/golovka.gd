extends RigidBody2D

var turn_speed: float = 1000.0;
var dead = false
var rng = RandomNumberGenerator.new()

func _ready():
	$AnimatedSprite2D.play("fire")
	rng.randomize()
	$AnimatedSprite2D.play("default")
	

func init(vec: Vector2):
	apply_impulse(Vector2(0,-1000).rotated(global_rotation + rng.randf_range(-0.02,0.02)) + vec)


func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	apply_torque(turn_amnt * turn_dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if dead: return
	face_point(get_global_mouse_position());
	apply_force(Vector2(0,-1000).rotated(global_rotation));
	if Input.is_action_just_pressed("ui_lclick"):
		$PinJoint2D2.node_b = NodePath("")
		$Timer.start()


func _on_body_entered(body):
	if body.is_in_group("attachable"):
		if $PinJoint2D3.node_a == NodePath(""):
			print("hmm")
			$PinJoint2D3.set_node_a(body.get_path())


func _on_timer_timeout():
	queue_free()
