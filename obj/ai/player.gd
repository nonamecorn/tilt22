extends RigidBody2D

var hp = 50;
var state = ALIVE;
var bullet_obj = preload("res://obj/parts/ship_parts3.tscn")
enum {
	DEAD,
	ALIVE
}


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	match state:
		DEAD:
			pass
		ALIVE:
			move()

func move():
	if Input.is_action_pressed("ui_up"):
		apply_force(Vector2(0, -12000).rotated(rotation));
		apply_central_force(Vector2(0,0))
		$Playership/damp1.hide();$Playership/damp2.hide();$Playership/engine.show()
		linear_damp = 0
	else:
		$Playership/damp1.show();$Playership/damp2.show();$Playership/engine.hide()
		linear_damp = 0.75
	if Input.is_action_pressed("ui_down"):
		$Playership/damp1.show();$Playership/damp2.show();$Playership/engine.hide()
		apply_force(Vector2(0, 7000).rotated(rotation));
		apply_central_force(Vector2(0,0))
		linear_damp = 0
	elif !Input.is_action_pressed("ui_up"):
		$Playership/damp1.hide();$Playership/damp2.hide(); linear_damp = 0.75
	else: $Playership/damp1.hide();$Playership/damp2.hide(); linear_damp = 0
	if Input.is_action_pressed("ui_left"):
		$Playership/torque1.show()
		$Playership/torque3.show()
		apply_torque(-100000);
	else: $Playership/torque1.hide(); $Playership/torque3.hide()
	if Input.is_action_pressed("ui_right"):
		$Playership/torque4.show()
		$Playership/torque2.show()
		apply_torque(100000);
	else: $Playership/torque2.hide(); $Playership/torque4.hide()
	

func hurt(_death):
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= _death;
	if hp <= 0 and state != DEAD:
		die()
func die():
	if state == DEAD: return
	state = DEAD;
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play()
	for childmark in $children.get_children():
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = childmark.global_position
		bullet_inst.global_rotation = childmark.global_rotation
		bullet_inst.frame = childmark.get_index()
		call_deferred("add", bullet_inst)
	linear_damp = 0
	$hand.dead = true
	$Playership.hide()
	$hand.hide()

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

#func _on_body_entered(body):
	#if state == DEAD or body.is_in_group("prj"): return
	#if (body.linear_velocity - linear_velocity).length() > 120:
		#die()
