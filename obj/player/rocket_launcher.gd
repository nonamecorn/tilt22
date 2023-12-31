extends Node2D

var bullet_path = "res://obj/projs/missile.tscn"
var look_vec
var dead = false
@export var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch():
	if active:
		active = false
	else:
		active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !dead and active:
		look_vec = (get_global_mouse_position() - global_position).rotated(PI/2)
		global_rotation = atan2(look_vec.y, look_vec.x)
		if Input.is_action_just_pressed("ui_lclick"):
			if $delay.is_stopped():
				$delay.start()
				fire()
			$Timer.start()
		if Input.is_action_just_released("ui_lclick"):
			$Timer.stop()

func fire():
	$Turret1.frame = 0
	$AnimatedSprite2D.play()
	var bullet_obj = load(bullet_path)
	var bullet_inst = bullet_obj.instantiate()
	bullet_inst.global_position = $Marker2D.global_position
	bullet_inst.global_rotation = $Marker2D.global_rotation
	bullet_inst.init(get_parent().get_parent().get_parent().linear_velocity)
	get_tree().current_scene.add_child(bullet_inst)


func _on_timer_timeout():
	fire()


func _on_delay_timeout():
	$Turret1.frame = 1
