extends Node2D

var bullet_path = "res://obj/ebullet.tscn"
var player = null
var look_vec
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		look_vec = player.global_position - global_position
		global_rotation = atan2(look_vec.y, look_vec.x)

func fire(bullet_path):
	var bullet_obj = load(bullet_path)
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_position = $Marker2D.global_position
	bullet_inst.global_rotation = $Marker2D.global_rotation
	bullet_inst.init(get_parent().linear_velocity)
	get_tree().current_scene.add_child(bullet_inst)

func _on_area_2d_body_entered(body):
	$Timer.start()
	player = body

func _on_timer_timeout():
	player = null
	fire(bullet_path)






func _on_area_2d_body_exited(body):
	$Timer.stop()
