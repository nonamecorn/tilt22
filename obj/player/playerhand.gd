extends Node2D

var bullet_path = "res://obj/projs/piercebullet.tscn"
var look_vec
var dead = false
@export var active = false
var enemy
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !dead:
		if active:
			look_vec = (get_global_mouse_position() - global_position).rotated(PI/2)
			global_rotation = atan2(look_vec.y, look_vec.x)
			if Input.is_action_just_pressed("ui_lclick"):
				fire()
				$Timer.start()
			if Input.is_action_just_released("ui_lclick"):
				$Timer.stop()
		else:
			if is_instance_valid(enemy):
				look_vec = (enemy.global_position - global_position).rotated(PI/2)
				global_rotation = atan2(look_vec.y, look_vec.x)

func switch():
	if active:
		active = false
		check()
	else:
		active = true
		$Timer.stop()
		

func check():
	if $Area2D.get_overlapping_bodies().size() != 0:
		$Timer.start()

func fire():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play()
	var bullet_obj = load(bullet_path)
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_position = $Marker2D.global_position
	bullet_inst.global_rotation = $Marker2D.global_rotation
	bullet_inst.init(get_parent().get_parent().get_parent().linear_velocity)
	get_tree().current_scene.add_child(bullet_inst)




func _on_timer_timeout():
	if dead: $Timer.stop()
	fire()
	if active: return
	if $Area2D.get_overlapping_bodies().size() != 0:
		enemy = $Area2D.get_overlapping_bodies()[0]
	elif $Area2D.get_overlapping_bodies().size() == 0: 
		$Timer.stop()


func _on_area_2d_body_entered(body):
	enemy = body
	if !active:
		$Timer.start()


func _on_area_2d_body_exited(body):
	if body == enemy and !active:
		enemy = null
		$Timer.stop()
