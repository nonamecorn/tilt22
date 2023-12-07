extends RigidBody2D

var state: stt = stt.IDLE;
var rng = RandomNumberGenerator.new();
var force: Vector2 = Vector2.ZERO;
var player;
var target;
var turn_speed: float = 100000.0;
var hp = 20;
@export var nav_agent: NavigationAgent2D

enum stt {
	IDLE,
	ATTACK,
	RUN
}
func _ready():
	rng.randomize()
	genrnforce()
func genrnforce():
	force = Vector2(0,rng.randi_range(-10000,-12000))

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.ATTACK:
			if nav_agent.is_navigation_finished():
				return
			var next_path = nav_agent.get_next_path_position()
			apply_force(force.rotated(rotation));
			var target_pos = next_path;
			face_point(target_pos);
			if hp < 6:
				state = stt.RUN;
		stt.RUN:
			apply_force(force.rotated(rotation));
			var target_pos = player.global_position*-1;
			face_point(target_pos);

func _on_area_2d_body_entered(body):
	$makepath.start()
	player = body;
	set_movement_target(body.position)	
	state = stt.ATTACK;

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	var angle = Vector2.UP.angle_to(l_point)
#	if angle < turn_amnt:
#		turn_amnt = angle
	apply_torque(turn_amnt * turn_dir)

func hurt():
	hp -= 1;
	if hp == 0:
		state = stt.IDLE;


func _on_makepath_timeout():
	print("asds")
	set_movement_target(player.position)
