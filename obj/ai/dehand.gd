extends Node2D

var bullet_path = "res://obj/newbullet.tscn"
var look_vec
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_vec = (get_global_mouse_position() - global_position).rotated(PI/2)
	global_rotation = atan2(look_vec.y, look_vec.x)
	if Input.is_action_just_pressed("ui_lclick"):
		fire()

func fire():
	var bullet_obj = load(bullet_path)
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_position = $Marker2D.global_position
	bullet_inst.global_rotation = $Marker2D.global_rotation
	bullet_inst.init(get_parent().linear_velocity)
	get_tree().current_scene.add_child(bullet_inst)
