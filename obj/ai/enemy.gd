extends RigidBody2D

var state: stt = stt.SCOUT;
var rng = RandomNumberGenerator.new();
var force: Vector2 = Vector2.ZERO;
var player;
var target;
var turn_speed: float = 100000.0;
var hp = 20;
var dead = false
var bullet_obj = preload("res://obj/parts/ship_parts.tscn")
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
	force = Vector2(0,rng.randi_range(-10000,-12000))

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _physics_process(_delta):
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
			if is_instance_valid(player):
				var target_pos = player.global_position*-1;
				face_point(target_pos);
		stt.SCOUT:
			apply_force(force.rotated(rotation));

func _on_area_2d_body_entered(body):
	if dead: return
	$makepath.start()
	player = body;
	set_movement_target(body.position)
	state = stt.ATTACK;

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

func hurt(ded):
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= ded;
	if hp <= 0 and !dead:
		die()

func die():
	$AnimatedSprite2D.play()
	for childmark in $children.get_children():
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = childmark.global_position
		bullet_inst.global_rotation = childmark.global_rotation
		bullet_inst.frame = childmark.get_index()
		call_deferred("add", bullet_inst)
	$hand/Timer.stop()
	linear_damp = 0
	$hand.dead = true
	$Playership.hide()
	$hand.hide()
	dead = true
func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

func _on_makepath_timeout():
	if is_instance_valid(player):
		set_movement_target(player.position)
	else:
		state = stt.SCOUT


func _on_animated_sprite_2d_animation_finished():
	queue_free()


#func _on_body_entered(body):
	#if dead or body.is_in_group("prj"): return
	#if (body.linear_velocity - linear_velocity).length() > 100:
		#die()
