extends Polygon2D



func _physics_process(_delta):
	global_rotation = global_position.angle_to_point(get_tree().get_nodes_in_group("spawn")[0].global_position)
	
