extends RigidBody2D

var turn_speed: float = 1000.0;
var armed = false
var dead = false
var golovka = preload("res://obj/projs/golovka.tscn")

func _ready():
	$PinJoint2D.node_b = get_parent().get_parent().get_path()

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	apply_torque(turn_amnt * turn_dir)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if dead: return
	face_point(get_global_mouse_position());
	if Input.is_action_just_pressed("ui_lclick") and !armed:
		var bullet_inst = golovka.instantiate()
		bullet_inst.global_position = $Marker2D.global_position
		bullet_inst.global_rotation = $Marker2D.global_rotation
		bullet_inst.get_child(8).node_b = get_parent().get_parent().get_path()
		bullet_inst.init(get_parent().get_parent().linear_velocity)
		get_tree().current_scene.add_child(bullet_inst)

