extends RigidBody2D

signal died

var state: stt = stt.SCOUT;
var rng = RandomNumberGenerator.new();
var force: Vector2 = Vector2.ZERO;
var rads = Vector2.ZERO
var player = null;
var target;
var turn_speed: float = 60000.0;
var hp = 30;
var dead = false
var bullet_obj = preload("res://obj/parts/ship_parts2.tscn")
var reputation = 1
var station = null
var collider
var loot = [
	"res://obj/parts/remochka.tscn",
	"res://obj/parts/money.tscn"
]
@export var nav_agent: NavigationAgent2D

enum stt {
	IDLE,
	RUN,
	SCOUT,
	BACK
}



func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	genrnforce()

func genrnforce():
	force = Vector2(0,rng.randi_range(-4000,-6000))
	rads = Vector2.RIGHT.rotated(rng.randf_range(0.0,PI*2))

func set_movement_target(target_point: Vector2):
	nav_agent.target_position = target_point

func _physics_process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.RUN:
			apply_force(force.rotated(rotation));
			if player != null:
				var target_pos = player.global_position*-1;
				face_point(target_pos);
		stt.BACK:
			apply_force((force * -0.5).rotated(rotation));
			face_point($Marker2D.global_position);
		stt.SCOUT:
			if nav_agent.is_navigation_finished():
				return
			var next_path = nav_agent.get_next_path_position()
			apply_force(force.rotated(rotation));
			var target_pos = next_path;
			face_point(target_pos);
			if hp < 20:
				state = stt.RUN;
			#face_point(rads);
			#apply_force(force.rotated(rotation));

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	#var angle = Vector2.UP.angle_to(l_point)
#	if angle < turn_amnt:
#		turn_amnt = angle
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
	apply_torque(turn_amnt * turn_dir)

func _on_area_2d_body_entered(body):
	if dead: return
	player = body;

func anger(ammount):
	Global.anger(ammount)
	$hand.check()
	$hand2.check()
	

func hurt(ded):
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= ded;
	if hp <= 0 and !dead:
		die()

func die():
	emit_signal("died")
	dead = true
	$AnimatedSprite2D.play()
	loot.shuffle()
	var _obj = load(loot[0])
	var _inst = _obj.instantiate()
	_inst.global_position = global_position
	_inst.global_rotation = global_rotation
	call_deferred("add", _inst)
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
	$hand2.hide()

func reroute():
	if get_tree().get_nodes_in_group("neutral_station").size() != 0:
		var num = rng.randi_range(0,get_tree().get_nodes_in_group("neutral_station").size()-1);
		if num == station:
			reroute()
		station = num

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_makepath_timeout():
	if station == null:
		reroute()
	set_movement_target(get_tree().get_nodes_in_group("neutral_station")[station].position)


func _on_colltim_timeout():
	if $RayCast2D.get_collider() == null:
		$Playership/damp1.hide()
		$Playership/damp2.hide()
		$Playership/damp3.hide()
		$Playership/damp4.hide()
		state = stt.SCOUT
		return
	if collider == $RayCast2D.get_collider():
		$Playership/damp1.show()
		$Playership/damp2.show()
		$Playership/damp3.show()
		$Playership/damp4.show()
		state = stt.BACK
	collider = $RayCast2D.get_collider()
