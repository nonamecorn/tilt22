extends RigidBody2D

var state: stt = stt.SCOUT;
var rng = RandomNumberGenerator.new();
var force: Vector2 = Vector2.ZERO;
var player;
var target;
var turn_speed: float = 60000.0;
var dead = false
var explosion = preload("res://obj/other/explosion.tscn")
@export var nav_agent: NavigationAgent2D

enum stt {
	IDLE,
	ATTACK,
	RUN,
	SCOUT
}
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	genrnforce()
func genrnforce():
	force = Vector2(0,rng.randi_range(-4000,-6000))

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _physics_process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.RUN:
			apply_force(force.rotated(rotation));
			if is_instance_valid(player):
				var target_pos = player.global_position*-1;
				face_point(target_pos);
		stt.SCOUT:
			apply_force(force.rotated(rotation));


func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	if turn_dir < 0:
		$Playership/torque1.show()
		$Playership/torque3.show()
		$Playership/torque2.hide()
		$Playership/torque4.hide()
	else:
		$Playership/torque2.show()
		$Playership/torque4.show()
		$Playership/torque1.hide()
		$Playership/torque3.hide()
	var turn_amnt = turn_speed
	#var angle = Vector2.UP.angle_to(l_point)
#	if angle < turn_amnt:
#		turn_amnt = angle
	apply_torque(turn_amnt * turn_dir)

func hurt(_ded):
	var bullet_inst = explosion.instantiate()
	bullet_inst.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(bullet_inst)
	queue_free()

func _on_area_2d_body_entered(body):
	if dead: return
	player = body;
	state = stt.RUN;
