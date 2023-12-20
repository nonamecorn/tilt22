extends StaticBody2D

var turn_speed = 500000
var linear_velocity = Vector2.ZERO

func _on_area_2d_body_entered(body):
	if body.has_method("shop"):
		body.shop()

func hurt(_ded):
	pass

func apply_impulse(_vector):
	pass

func _on_selling_area_2d_2_body_entered(body):
	get_tree().get_nodes_in_group("player")[0].add_money(body.worth)
	body.queue_free()
