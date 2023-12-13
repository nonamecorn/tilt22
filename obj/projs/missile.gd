extends RigidBody2D
var rng = RandomNumberGenerator.new()
var state = stt.IDLE
var dead = false
enum stt {
	IDLE,
	ATTACK
}
@export var nav_agent: NavigationAgent2D
var player
var locked = false
var speed = -6000

var explosion = preload("res://obj/other/explosion.tscn")
var turn_speed: float = 40000.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
func init(vec: Vector2):
	apply_impulse(Vector2(0,-50).rotated(global_rotation + rng.randf_range(-0.04,0.04)) + vec)

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	apply_torque(turn_speed * turn_dir)

func _physics_process(_delta):
	match  state:
		stt.IDLE:
			apply_force(Vector2(0,speed).rotated(rotation));
		stt.ATTACK:
			#if nav_agent.is_navigation_finished():
				#return
			if !is_instance_valid(player): return
			#var next_path = nav_agent.get_next_path_position()
			apply_force(Vector2(0,speed).rotated(rotation));
			#var target_pos = next_path;
			face_point(player.global_position + player.linear_velocity * 1);

func _on_body_entered(_body):
	var bullet_inst = explosion.instantiate()
	bullet_inst.global_position = global_position
	bullet_inst.exp_scale = 1.5
	
	get_tree().current_scene.add_child.call_deferred(bullet_inst)
	queue_free()
func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point
func _on_area_2d_body_entered(body):
	if dead or locked: return
	#$makepath.start()
	player = body;
	#set_movement_target(body.position)
	state = stt.ATTACK
	locked = true
func hurt(_ded):
	var bullet_inst = explosion.instantiate()
	bullet_inst.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(bullet_inst)
	queue_free()

func _on_makepath_timeout():
	if is_instance_valid(player):
		set_movement_target(player.position)
	else:
		state = stt.IDLE


func _on_body_exited(_body):
	state = stt.IDLE




func _on_arm_timeout():
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body == player:
		linear_damp = 0
		player = null
