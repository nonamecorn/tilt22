extends RigidBody2D

var state: stt = stt.SCOUT;
var rng = RandomNumberGenerator.new();
var force: Vector2 = Vector2.ZERO;
var player;
var target;
var turn_speed: float = 70000.0;
var hp = 30;
var dead = false
var bullet_obj = preload("res://obj/parts/ship_parts3.tscn")
var victum
var reputation = -1
var collider
@export var nav_agent: NavigationAgent2D

enum stt {
	IDLE,
	ATTACK,
	RUN,
	SCOUT,
	BACK
}
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	genrnforce()
func genrnforce():
	force = Vector2(0,rng.randi_range(-16000,-18000))

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _physics_process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.BACK:
			apply_force((force*-0.5).rotated(rotation));
			face_point($Marker2D.global_position);
		stt.ATTACK:
			if nav_agent.is_navigation_finished():
				return
			if player == null: state = stt.SCOUT
			var next_path = nav_agent.get_next_path_position()
			apply_force(force.rotated(rotation));
			var target_pos = next_path;
			face_point(target_pos);
			if hp < 10:
				state = stt.RUN;
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

func check():
	if $Area2D.get_overlapping_bodies().size() != 0:
		_on_area_2d_2_body_entered($Area2D.get_overlapping_bodies()[0])

func hurt(ded):
	if dead: return
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= ded;
	if hp <= 0:
		die()

func die():
	$CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.play()
	for childmark in $children.get_children():
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = childmark.global_position
		bullet_inst.global_rotation = childmark.global_rotation
		bullet_inst.frame = childmark.get_index()
		call_deferred("add", bullet_inst)
	linear_damp = 0
	$Playership.hide()
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


func _on_area_2d_2_body_entered(body):
	if dead: return
	$makepath.start()
	player = body;
	set_movement_target(body.position)
	state = stt.ATTACK;


func _on_area_2d_body_exited(_body):
	state = stt.ATTACK


func _on_area_2d_3_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(2)
		victum = body
		$drilltimer.start()
		state = stt.RUN

func _on_area_2d_3_body_exited(body):
	if body == victum:
		victum = null

func _on_drilltimer_timeout():
	if $Area2D3.get_overlapping_bodies().size() != 0:
		victum = $Area2D3.get_overlapping_bodies()[0]
		victum.hurt(2)
		

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
