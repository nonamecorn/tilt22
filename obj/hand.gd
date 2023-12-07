extends Node2D

var bullet_path = "res://obj/newebullet.tscn"
var player = null
var look_vec
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if player and !dead:
		look_vec = (player.global_position - global_position).rotated(PI/2)
		global_rotation = atan2(look_vec.y, look_vec.x)

func fire():
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
	fire()






func _on_area_2d_body_exited(_body):
	player = null
	$Timer.stop()
