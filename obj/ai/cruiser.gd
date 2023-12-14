extends RigidBody2D

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
var rem_obj = preload("res://obj/parts/remochka.tscn")
@export var nav_agent: NavigationAgent2D

enum stt {
	IDLE,
	RUN,
	SCOUT
}
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	genrnforce()
func genrnforce():
	force = Vector2(0,rng.randi_range(-4000,-6000))
	rads = Vector2.RIGHT.rotated(rng.randf_range(0.0,PI*2))

func _physics_process(_delta):
	match  state:
		stt.IDLE:
			pass
		stt.RUN:
			apply_force(force.rotated(rotation));
			if player != null:
				var target_pos = player.global_position*-1;
				face_point(target_pos);
		stt.SCOUT:
			if hp < 20:
				state = stt.RUN;
			#face_point(rads);
			apply_force(force.rotated(rotation));

func face_point(point: Vector2):
	var l_point = to_local(point)
	var turn_dir = sign(l_point.x)
	var turn_amnt = turn_speed
	#var angle = Vector2.UP.angle_to(l_point)
#	if angle < turn_amnt:
#		turn_amnt = angle
	apply_torque(turn_amnt * turn_dir)

func _on_area_2d_body_entered(body):
	if dead: return
	player = body;

func hurt(ded):
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= ded;
	if hp <= 0 and !dead:
		die()

func die():
	dead = true
	$AnimatedSprite2D.play()
	var rem_inst = rem_obj.instantiate()
	rem_inst.global_position = global_position
	rem_inst.global_rotation = global_rotation
	call_deferred("add", rem_inst)
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
	

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

func _on_animated_sprite_2d_animation_finished():
	queue_free()
