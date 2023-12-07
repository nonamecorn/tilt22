extends RigidBody2D

var damp: bool = true;
var hp = 50;
var state = ALIVE;
enum {
	DEAD,
	ALIVE
}

func _physics_process(_delta):
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
	elif damp:
		linear_damp = 0.75
	if Input.is_action_pressed("ui_down"):
		$Playership/damp1.show();$Playership/damp2.show();$Playership/engine.hide()
		apply_force(Vector2(0, 5000).rotated(rotation));
		apply_central_force(Vector2(0,0))
		linear_damp = 0
	else: $Playership/damp1.hide();$Playership/damp2.hide()
	if Input.is_action_pressed("ui_left"):
		$Playership/torque1.show()
		apply_torque(-100000);
	else: $Playership/torque1.hide()
	if Input.is_action_pressed("ui_right"):
		$Playership/torque2.show()
		apply_torque(100000);
	else: $Playership/torque2.hide()
	if Input.is_action_just_pressed("ui_z"):
		if damp: damp = false
		else: damp = true;

func hurt():
	hp -= 1;
	if hp == 0:
		state = DEAD;
