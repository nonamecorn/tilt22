extends Node2D

var bullet_path = "res://obj/projs/ebullet.tscn"
var player
var look_vec
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if dead: return
	if is_instance_valid(player):
		look_vec = (player.global_position - global_position).rotated(PI/2)
		global_rotation = atan2(look_vec.y, look_vec.x)

func fire():
	$AnimatedSprite2D.play()
	var bullet_obj = load(bullet_path)
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_position = $Marker2D.global_position
	bullet_inst.global_rotation = $Marker2D.global_rotation
	bullet_inst.init(get_parent().linear_velocity)
	get_tree().current_scene.add_child.call_deferred(bullet_inst)

func _on_area_2d_body_entered(body):
	$Timer.start()
	player = body

func _on_timer_timeout():
	if $Area2D.get_overlapping_bodies().size() != 0:
		player = $Area2D.get_overlapping_bodies()[0]
		fire()
	else:
		$Timer.stop()




func _on_area_2d_body_exited(_body):
	_on_timer_timeout()
