extends RigidBody2D

var type = "offender"
var hp = Global.offhp;
var maxhp = Global.offmaxhp;
var force = Global.offforce
var state = ALIVE;
var bullet_obj = preload("res://obj/parts/ship_parts4.tscn")
var reputation = Global.reputation

enum {
	DEAD,
	ALIVE
}


func _ready():
	$RemoteTransform2D.remote_path = get_parent().get_child(1).get_path()
	Global.reputation_change.connect(_on_rep_change)
	$CanvasLayer/Label.text = "money: " + str(Global.money)
	updatehpbar()

func _physics_process(_delta):
	match state:
		DEAD:
			pass
		ALIVE:
			move()

func move():
	if Input.is_action_pressed("ui_e"):
		linear_damp = 0.25
		$Playership/torque1.show(); $Playership/torque4.show()
		apply_force(Vector2(0.5 * force, 0).rotated(rotation));
	elif !Input.is_action_pressed("ui_q"):
		$Playership/torque1.hide(); $Playership/torque4.hide(); linear_damp = 0.75
	else: $Playership/torque1.hide(); $Playership/torque4.hide(); 
	if Input.is_action_pressed("ui_q"):
		linear_damp = 0.25
		$Playership/torque3.show(); $Playership/torque2.show()
		apply_force(Vector2(-0.5 * force, 0).rotated(rotation));
	elif !Input.is_action_pressed("ui_e"):
		$Playership/torque3.hide(); $Playership/torque2.hide(); linear_damp = 0.75
	else: $Playership/torque3.hide(); $Playership/torque2.hide();
	if Input.is_action_pressed("ui_up"):
		apply_force(Vector2(0, force).rotated(rotation));
		apply_central_force(Vector2(0,0))
		$Playership/damp1.hide();$Playership/damp2.hide();$Playership/engine.show()
		linear_damp = 0.25
	else:
		$Playership/damp1.show();$Playership/damp2.show();$Playership/engine.hide()
		linear_damp = 0.75
	if Input.is_action_pressed("ui_down"):
		$Playership/damp1.show();$Playership/damp2.show();$Playership/engine.hide()
		apply_force(Vector2(0, (force * -0.5)).rotated(rotation));
		apply_central_force(Vector2(0,0))
		linear_damp = 0.25
	elif !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_q") and !Input.is_action_pressed("ui_q"):
		$Playership/damp1.hide();$Playership/damp2.hide(); linear_damp = 0.75
	else: $Playership/damp1.hide();$Playership/damp2.hide(); linear_damp = 0.25
	if Input.is_action_pressed("ui_left"):
		$Playership/torque1.show()
		$Playership/torque3.show()
		angular_damp = 0.5;
		apply_torque(-100000);
	elif !Input.is_action_pressed("ui_q") and !Input.is_action_pressed("ui_e"):
		angular_damp = 4;
		$Playership/torque1.hide(); $Playership/torque3.hide()
	if Input.is_action_pressed("ui_right"):
		$Playership/torque4.show()
		$Playership/torque2.show()
		angular_damp = 0.5;
		apply_torque(100000);
	elif !Input.is_action_pressed("ui_q") and !Input.is_action_pressed("ui_e") and !Input.is_action_pressed("ui_left"):
		angular_damp = 4;
		$Playership/torque2.hide(); $Playership/torque4.hide()
	
	if Input.is_action_just_pressed("ui_1"):
		if $markers/Marker2D.get_child(0).active:
			$markers/Marker2D.get_child(0).switch()
		else:
			$markers/Marker2D.get_child(0).switch()
		
func _on_rep_change(rep):
	reputation -= rep

func hurt(death):
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= death;
	Global.offhp -= (1 + death)
	if hp <= 0 and state != DEAD:
		die()
	updatehpbar()
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
	$markers/Marker2D.get_child(0).dead = true
	$Playership.hide()
	$markers.hide()

func repair():
	hp = maxhp
	Global.offhp = Global.offmaxhp
	updatehpbar()
func shop():
	$CanvasLayer/shop.show()
func updatehpbar():
	$CanvasLayer/ProgressBar.max_value = maxhp
	$CanvasLayer/ProgressBar.value = hp

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)
func add_money(amount):
	Global.money += amount
	$CanvasLayer/Label.text = "money: " + str(Global.money)
func deduct_money(amount):
	Global.money -= amount
	$CanvasLayer/Label.text = "money: " + str(Global.money)
#func _on_body_entered(body):
	#if state == DEAD or body.is_in_group("prj"): return
	#if (body.linear_velocity - linear_velocity).length() > 120:
		#die()


