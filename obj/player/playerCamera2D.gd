extends Camera2D
func _physics_process(_delta):
	if Input.is_action_pressed("ui_rclick"):
		global_position = Vector2(
		(get_global_mouse_position().x + get_parent().global_position.x) / 2,
		 (get_global_mouse_position().y + get_parent().global_position.y) / 2)
	else: global_position = get_parent().global_position
	
