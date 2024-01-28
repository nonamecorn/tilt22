extends RigidBody2D

var turn_speed: float = 10000.0;
var dead = false
var rng = RandomNumberGenerator.new()
var chain = preload("res://obj/projs/big_chain.tscn")
var inst

func _ready():
	rng.randomize()
	

func init(vec: Vector2, rot, depath):
	global_rotation = rot
	var bullet_inst = chain.instantiate()
	bullet_inst.global_rotation = get_node(depath).global_rotation
	bullet_inst.global_position = global_position
	bullet_inst.path = depath
	bullet_inst.get_child(0).get_child(0).node_a = get_path()
	inst = bullet_inst
	get_tree().current_scene.add_child(bullet_inst)
	
	apply_impulse(Vector2(0,-1000).rotated(global_rotation + rng.randf_range(-0.02,0.02)) + vec)

func rat_king(depath):
	inst.path = depath
	inst.init()

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	apply_torque(turn_amnt * turn_dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if dead: return
	face_point(get_global_mouse_position());
	apply_force(Vector2(0,-700).rotated(rotation))
	if Input.is_action_just_pressed("ui_z"):
		if is_instance_valid(inst):
			inst.queue_free()
			$Timer.start()


func _on_body_entered(body):
	if body.is_in_group("attachable"):
		if $PinJoint2D3.node_a == NodePath(""):
			$Sprite2D.frame = 1
			$PinJoint2D3.set_node_a(body.get_path())


func _on_timer_timeout():
	queue_free()
