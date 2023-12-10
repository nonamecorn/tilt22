extends RigidBody2D

var turn_speed: float = 1000.0;
var armed = false

func _ready():
	$AnimatedSprite2D.play("default")
	$PinJoint2D.node_b = get_parent().get_path()
	$PinJoint2D2.node_b = get_parent().get_path()

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	apply_torque(turn_amnt * turn_dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_lclick") and !armed:
		$PinJoint2D.node_b = NodePath("")
		$AnimatedSprite2D.play("fire")
		$chain.show()
		$chain6.show()
		$chain2.show()
		$chain3.show()
		$chain4.show()
		$chain5.show()
		armed = true
	if armed:
		face_point(get_global_mouse_position());
		apply_force(Vector2(0,-700).rotated(global_rotation));
	if Input.is_action_just_pressed("ui_rclick"):
		$PinJoint2D.node_b = NodePath("")
		$PinJoint2D2.node_b = NodePath("")
		$Timer.start()


func _on_body_entered(body):
	if !armed: return
	if body.is_in_group("attachable"):
		if $PinJoint2D3.node_a == NodePath(""):
			print("hmm")
			$PinJoint2D3.set_node_a(body.get_path())
			armed = false



func _on_timer_timeout():
	queue_free()
