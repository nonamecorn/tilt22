extends RigidBody2D

var damp: bool = true;

func _physics_process(_delta):
	if Input.is_action_pressed("ui_up"):
		apply_force(Vector2(0, -20000).rotated(rotation));
		apply_central_force(Vector2(0,0))
		linear_damp = 0
	elif damp: linear_damp = 0.75
	if Input.is_action_pressed("ui_down"):
		apply_force(Vector2(0, 5000).rotated(rotation));
		apply_central_force(Vector2(0,0))
		linear_damp = 0
	if Input.is_action_pressed("ui_left"):
		apply_torque(-100000);
	if Input.is_action_pressed("ui_right"):
		apply_torque(100000);
	if Input.is_action_just_pressed("ui_z"):
		if damp: damp = false
		else: damp = true;
