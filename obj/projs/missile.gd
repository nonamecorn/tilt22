extends RigidBody2D
var rng = RandomNumberGenerator.new()
var state = stt.STOP
var dead = false
enum stt {
	IDLE,
	ATTACK,
	STOP
}
@export var nav_agent: NavigationAgent2D
var player
var locked = false
var speed = -6000

var explosion = preload("res://obj/other/explosion.tscn")
var turn_speed: float = 6000.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
func init(vec: Vector2):
	apply_impulse(Vector2(0,-100).rotated(global_rotation + rng.randf_range(-0.04,0.04)) + vec)

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	if turn_dir < 0:
		$Sprite2D/torque1.show()
		$Sprite2D/torque2.hide()
	else:
		$Sprite2D/torque2.show()
		$Sprite2D/torque1.hide()
	apply_torque(turn_speed * turn_dir)

func _physics_process(_delta):
	match  state:
		stt.STOP:
			pass
		stt.IDLE:
			$Sprite2D/torque2.hide()
			$Sprite2D/torque1.hide()
			apply_force(Vector2(0,speed).rotated(rotation));
		stt.ATTACK:
			if !$thump.is_stopped():
				return
			if !is_instance_valid(player): return
			#var next_path = nav_agent.get_next_path_position()
			apply_force(Vector2(0,speed).rotated(rotation));
			#var target_pos = next_path;
			var coef = global_position.distance_to(player.global_position + player.linear_velocity) / linear_velocity.length()
			if coef > 1:
				coef = 1
			face_point(player.global_position + player.linear_velocity * coef);

func _on_thump_timeout():
	linear_damp = 2
	state = stt.IDLE
	$Sprite2D/engine.show()
	if player != null:
		state = stt.ATTACK


func _on_body_entered(_body):
	if !$thump.is_stopped():
		return
	if dead: return
	dead = true
	var bullet_inst = explosion.instantiate()
	bullet_inst.global_position = global_position
	bullet_inst.exp_scale = 1
	bullet_inst.damage = 19
	get_tree().current_scene.add_child.call_deferred(bullet_inst)
	queue_free()
func _on_area_2d_body_entered(body):
	if dead: return
	if locked and body != player:
		return
	#$makepath.start()
	player = body;
	locked = true
	if !$thump.is_stopped():
		return
	#set_movement_target(body.position)
	state = stt.ATTACK
	
func hurt(_ded):
	var bullet_inst = explosion.instantiate()
	bullet_inst.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(bullet_inst)
	queue_free()


func _on_body_exited(_body):
	if !$thump.is_stopped():
		return
	state = stt.IDLE




func _on_arm_timeout():
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body == player:
		player = null
		state = stt.IDLE



