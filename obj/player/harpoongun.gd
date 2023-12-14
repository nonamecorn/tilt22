extends Node2D

var turn_speed: float = 1000.0;
var armed = false
var dead = false
var golovka = preload("res://obj/projs/golovka.tscn")
var rat_king = preload("res://obj/projs/rat_king.tscn")
var look_vec
var instances = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if dead: return
	look_vec = (get_global_mouse_position() - global_position).rotated(PI/2)
	global_rotation = atan2(look_vec.y, look_vec.x)
	if Input.is_action_just_pressed("ui_lclick") and !armed:
		var bullet_inst = golovka.instantiate()
		bullet_inst.global_position = $Marker2D.global_position
		get_tree().current_scene.add_child(bullet_inst)
		bullet_inst.init(get_parent().get_parent().linear_velocity, $Marker2D.global_rotation, get_parent().get_parent().get_path())
		instances.append(bullet_inst)
	if Input.is_action_just_pressed("ui_z"):
		instances = []
	if Input.is_action_just_pressed("ui_x"):
		var rat_inst = rat_king.instantiate()
		rat_inst.global_position = $Marker2D.global_position
		get_tree().current_scene.add_child(rat_inst)
		for inst in instances:
			inst.rat_king(rat_inst.get_path())
		instances = []
	

