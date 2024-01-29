extends Ship

class_name Ai_Ship

var collider
var state
var target
@export var nav_agent: NavigationAgent2D
enum  stt {
	IDLE,
	SCOUT,
	BACK,
	ATTACK,
	RUN,
}
func _ready():
	rotate(rng.randf_range(0.0,PI*2))
	genrnforce()
func genrnforce():
	pass


func _physics_process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.BACK:
			back()
		stt.ATTACK:
			attack()
		stt.RUN:
			run()
		stt.SCOUT:
			apply_force(force.rotated(rotation));
			scout()

func back():
	apply_force((force*-0.5).rotated(rotation));
	face_point($Marker2D.global_position);
func attack():
	if nav_agent.is_navigation_finished():
		return
	var next_path = nav_agent.get_next_path_position()
	apply_force(force.rotated(rotation));
	var target_pos = next_path;
	face_point(target_pos);
	if hp < 10:
		state = stt.RUN;
func run():
	apply_force(force.rotated(rotation));
	if is_instance_valid(target):
		var target_pos = target.global_position*-1;
		face_point(target_pos);
func scout():
	pass

func turn_left():
	pass

func turn_right():
	pass

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	if turn_dir < 0:
		turn_left()
	else:
		turn_right()
	var turn_amnt = turn_speed
	apply_torque(turn_amnt * turn_dir)

func check():
	if $Area2D.get_overlapping_bodies().size() != 0:
		_on_area_2d_body_entered($Area2D.get_overlapping_bodies()[0])

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _on_area_2d_body_entered(body):
	if dead: return
	$makepath.start()
	target = body;
	set_movement_target(body.position)
	state = stt.ATTACK

func _on_makepath_timeout():
	if is_instance_valid(target):
		set_movement_target(target.position)
	else:
		state = stt.SCOUT

func _on_colltim_timeout():
	if $RayCast2D.get_collider() == null:
		$Playership/damp1.hide()
		$Playership/damp2.hide()
		state = stt.SCOUT
		check()
		return
	if collider == $RayCast2D.get_collider():
		$Playership/damp1.show()
		$Playership/damp2.show()
		state = stt.BACK
	collider = $RayCast2D.get_collider()



