extends RigidBody2D




func _on_area_2d_body_entered(body):
	body.shop()

func hurt(_ded):
	pass


func _on_selling_area_2d_2_body_entered(body):
	get_tree().get_nodes_in_group("player")[0].add_money(body.worth)
	body.queue_free()
